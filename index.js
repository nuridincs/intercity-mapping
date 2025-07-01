const dot = require('express');
const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const app = express();
require('dotenv').config();

// Middleware
app.use(cors());
app.use(express.json());

// Database configuration
const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: 'db_intercity_mapping',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
};
console.log(" dbConfig:", dbConfig)

// Create connection pool
const pool = mysql.createPool(dbConfig);

// Helper function to normalize area names for comparison
function normalizeAreaName(areaName) {
  return areaName
    .toLowerCase()
    .trim()
    .replace(/\s+/g, ' ')
    .replace(/[()]/g, '');
}

// Helper function to check if areas are in the same region
function isSameRegion(warehouseProvince, inspectionArea) {
  const jabodetabekAreas = [
    'bekasi',
    'jakarta',
    'depok',
    'tangerang',
    'bogor',
    'cikarang',
  ];
  const normalizedInspection = normalizeAreaName(inspectionArea);

  // Check if warehouse is in Jabodetabek and inspection area is also Jabodetabek
  if (warehouseProvince.toLowerCase() === 'jabodetabek') {
    return jabodetabekAreas.some(
      (area) =>
        normalizedInspection.includes(area) ||
        normalizedInspection.includes('jabodetabek')
    );
  }

  return false;
}

// API Routes

// 1. Get all warehouses
app.get('/api/warehouses', async (req, res) => {
  try {
    const [rows] = await pool.execute(
      'SELECT * FROM warehouses WHERE status = "Active" ORDER BY warehouse_name'
    );
    res.json({
      success: true,
      data: rows,
    });
  } catch (error) {
    console.error('Error fetching warehouses:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching warehouses',
      error: error.message,
    });
  }
});

// 2. Get warehouses by area
app.get('/api/warehouses/area/:area', async (req, res) => {
  try {
    const { area } = req.params;
    const [rows] = await pool.execute(
      'SELECT * FROM warehouses WHERE area_mapping LIKE ? AND status = "Active"',
      [`%${area}%`]
    );
    res.json({
      success: true,
      data: rows,
    });
  } catch (error) {
    console.error('Error fetching warehouses by area:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching warehouses by area',
      error: error.message,
    });
  }
});

// 3. Check intercity status
app.post('/api/check-intercity', async (req, res) => {
  try {
    const { warehouseName, inspectionArea } = req.body;

    if (!warehouseName || !inspectionArea) {
      return res.status(400).json({
        success: false,
        message: 'Warehouse name and inspection area are required',
      });
    }

    // Get warehouse information
    const [warehouseRows] = await pool.execute(
      'SELECT * FROM warehouses WHERE warehouse_name = ? AND status = "Active"',
      [warehouseName]
    );

    if (warehouseRows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Warehouse not found or inactive',
      });
    }

    const warehouse = warehouseRows[0];

    // Check for exact mapping in intercity_mappings table
    const [mappingRows] = await pool.execute(
      `
            SELECT * FROM intercity_mappings 
            WHERE warehouse_area = ? 
            AND (inspection_area = ? OR inspection_area LIKE ?)
        `,
      [warehouse.area_mapping, inspectionArea, `%${inspectionArea}%`],
    );

    console.log('Mapping rows found:', mappingRows);

    let result;

    if (mappingRows.length > 0) {
      // Use existing mapping
      const mapping = mappingRows[0];
      result = {
        isIntercity: mapping.is_intercity,
        resultLogic: mapping.result_logic,
        reasoning: mapping.notes || 'Based on predefined mapping',
        mappingSource: 'database',
      };
    } else {
      // Apply fallback logic
      const normalizedWarehouseArea = normalizeAreaName(warehouse.area_mapping);
      const normalizedInspectionArea = normalizeAreaName(inspectionArea);

      // Check if same area/city
      if (normalizedWarehouseArea === normalizedInspectionArea) {
        result = {
          isIntercity: false,
          resultLogic: 'NOT INTERCITY',
          reasoning: 'Same area/city',
          mappingSource: 'fallback_logic',
        };
      }
      // Check if same region (e.g., Jabodetabek)
      else if (isSameRegion(warehouse.province, inspectionArea)) {
        result = {
          isIntercity: false,
          resultLogic: 'NOT INTERCITY',
          reasoning: 'Same metropolitan region',
          mappingSource: 'fallback_logic',
        };
      }
      // Check if same province
      else if (
        warehouse.province.toLowerCase() === inspectionArea.toLowerCase()
      ) {
        result = {
          isIntercity: false,
          resultLogic: 'NOT INTERCITY',
          reasoning: 'Same province',
          mappingSource: 'fallback_logic',
        };
      }
      // Default to intercity
      else {
        result = {
          isIntercity: true,
          resultLogic: 'INTERCITY',
          reasoning: 'Different provinces/regions',
          mappingSource: 'fallback_logic',
        };
      }
    }

    res.json({
      success: true,
      data: {
        warehouse: {
          name: warehouse.warehouse_name,
          area: warehouse.area_mapping,
          province: warehouse.province,
        },
        inspectionArea: inspectionArea,
        result: result,
      },
    });
  } catch (error) {
    console.error('Error checking intercity status:', error);
    res.status(500).json({
      success: false,
      message: 'Error checking intercity status',
      error: error.message,
    });
  }
});

// 4. Add new intercity mapping
app.post('/api/intercity-mappings', async (req, res) => {
  try {
    const { warehouseArea, inspectionArea, isIntercity, notes } = req.body;

    if (!warehouseArea || !inspectionArea || isIntercity === undefined) {
      return res.status(400).json({
        success: false,
        message:
          'Warehouse area, inspection area, and intercity status are required',
      });
    }

    const resultLogic = isIntercity ? 'INTERCITY' : 'NOT INTERCITY';

    const [result] = await pool.execute(
      `
            INSERT INTO intercity_mappings (warehouse_area, inspection_area, is_intercity, result_logic, notes)
            VALUES (?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
            is_intercity = VALUES(is_intercity),
            result_logic = VALUES(result_logic),
            notes = VALUES(notes),
            updated_at = CURRENT_TIMESTAMP
        `,
      [warehouseArea, inspectionArea, isIntercity, resultLogic, notes || null]
    );

    res.json({
      success: true,
      message: 'Intercity mapping saved successfully',
      data: {
        id: result.insertId,
        warehouseArea,
        inspectionArea,
        isIntercity,
        resultLogic,
        notes,
      },
    });
  } catch (error) {
    console.error('Error saving intercity mapping:', error);
    res.status(500).json({
      success: false,
      message: 'Error saving intercity mapping',
      error: error.message,
    });
  }
});

// 5. Get all intercity mappings
app.get('/api/intercity-mappings', async (req, res) => {
  try {
    const [rows] = await pool.execute(
      'SELECT * FROM intercity_mappings ORDER BY warehouse_area, inspection_area'
    );
    res.json({
      success: true,
      data: rows,
    });
  } catch (error) {
    console.error('Error fetching intercity mappings:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching intercity mappings',
      error: error.message,
    });
  }
});

// 6. Get intercity mapping by warehouse area
app.get(
  '/api/intercity-mappings/warehouse/:warehouseArea',
  async (req, res) => {
    try {
      const { warehouseArea } = req.params;
      const [rows] = await pool.execute(
        'SELECT * FROM intercity_mappings WHERE warehouse_area = ? ORDER BY inspection_area',
        [warehouseArea]
      );
      res.json({
        success: true,
        data: rows,
      });
    } catch (error) {
      console.error(
        'Error fetching intercity mappings by warehouse area:',
        error
      );
      res.status(500).json({
        success: false,
        message: 'Error fetching intercity mappings by warehouse area',
        error: error.message,
      });
    }
  }
);

// 7. Test endpoint for the example case
app.get('/api/test/magelang-yogyakarta', async (req, res) => {
  try {
    // Test the specific case: Magelang warehouse, Yogyakarta inspection area
    const testResult = await pool.execute(`
            SELECT 
                w.warehouse_name,
                w.area_mapping as warehouse_area,
                w.province as warehouse_province,
                'Yogyakarta' as inspection_area,
                im.is_intercity,
                im.result_logic,
                im.notes
            FROM warehouses w
            LEFT JOIN intercity_mappings im ON w.area_mapping = im.warehouse_area AND im.inspection_area LIKE '%Yogyakarta%'
            WHERE w.warehouse_name = 'Magelang'
        `);

    res.json({
      success: true,
      message: 'Test case: Magelang warehouse checking Yogyakarta area',
      data: testResult[0],
      expected: 'Should be NOT INTERCITY (same province - Central Java)',
    });
  } catch (error) {
    console.error('Error in test endpoint:', error);
    res.status(500).json({
      success: false,
      message: 'Error in test endpoint',
      error: error.message,
    });
  }
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    message: 'API is running',
    timestamp: new Date().toISOString(),
  });
});

// Error handling middleware
app.use((error, req, res, next) => {
  console.error('Unhandled error:', error);
  res.status(500).json({
    success: false,
    message: 'Internal server error',
    error: error.message,
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Endpoint not found',
  });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/api/health`);
  console.log(
    `Test Magelang-Yogyakarta case: http://localhost:${PORT}/api/test/magelang-yogyakarta`
  );
});

module.exports = app;
