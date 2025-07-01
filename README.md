# Intercity Mapping API

A Node.js/Express API for determining whether shipping between warehouses and inspection areas is classified as intercity or not, based on geographical mapping and business rules.

## Features

- **Warehouse Management**: Retrieve active warehouses and filter by area
- **Intercity Detection**: Intelligent routing logic to determine if shipping is intercity
- **Smart Mapping**: Supports predefined mappings and fallback logic
- **Regional Awareness**: Special handling for metropolitan areas like Jabodetabek
- **RESTful API**: Clean API endpoints with proper error handling

## Prerequisites

- Node.js (v14 or higher)
- MySQL (v5.7 or higher)
- npm or yarn package manager

## Database Setup

### 1. Create Database
```sql
CREATE DATABASE db_intercity_mapping;
USE db_intercity_mapping;
```

### 2. Create Tables

#### Warehouses Table
```sql
CREATE TABLE warehouses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_name VARCHAR(255) NOT NULL,
    area_mapping VARCHAR(255) NOT NULL,
    province VARCHAR(255) NOT NULL,
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### Intercity Mappings Table
```sql
CREATE TABLE intercity_mappings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    warehouse_area VARCHAR(255) NOT NULL,
    inspection_area VARCHAR(255) NOT NULL,
    is_intercity BOOLEAN NOT NULL,
    result_logic ENUM('INTERCITY', 'NOT INTERCITY') NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_mapping (warehouse_area, inspection_area)
);
```

### 3. Sample Data

#### Sample Warehouses
```sql
INSERT INTO warehouses (warehouse_name, area_mapping, province, status) VALUES
('Magelang', 'Magelang', 'Central Java', 'Active'),
('Cikarang', 'Cikarang', 'Jabodetabek', 'Active'),
('Jatibening', 'Jatibening', 'Jabodetabek', 'Active'),
('Medan Pusat', 'Medan', 'North Sumatra', 'Active'),
('Jakarta Pusat', 'Jakarta', 'Jabodetabek', 'Active');
```

#### Sample Mappings
```sql
INSERT INTO intercity_mappings (warehouse_area, inspection_area, is_intercity, result_logic, notes) VALUES
('Magelang', 'Yogyakarta', false, 'NOT INTERCITY', 'Same province - Central Java'),
('Cikarang', 'Jakarta', false, 'NOT INTERCITY', 'Same metropolitan area - Jabodetabek'),
('Medan', 'Jakarta', true, 'INTERCITY', 'Different provinces');
```

## Installation

### 1. Clone the Repository
```bash
git clone <repository-url>
cd intercity-mapping-api
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Configure Database
Update the database configuration in `index.js`:
```javascript
const dbConfig = {
  host: '127.0.0.1',
  user: 'root',
  password: 'your_password',
  database: 'db_intercity_mapping',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
};
```

### 4. Start the Server
```bash
node index.js
```

The server will start on port 3000 by default. You should see:
```
Server is running on port 3000
Health check: http://localhost:3000/api/health
Test Magelang-Yogyakarta case: http://localhost:3000/api/test/magelang-yogyakarta
```

## API Endpoints

### Health Check
```
GET /api/health
```
Check if the API is running.

### Warehouses
```
GET /api/warehouses
GET /api/warehouses/area/:area
```
Get all active warehouses or filter by area.

### Intercity Detection
```
POST /api/check-intercity
```
**Request Body:**
```json
{
  "warehouseName": "Magelang",
  "inspectionArea": "Yogyakarta"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "warehouse": {
      "name": "Magelang",
      "area": "Magelang",
      "province": "Central Java"
    },
    "inspectionArea": "Yogyakarta",
    "result": {
      "isIntercity": false,
      "resultLogic": "NOT INTERCITY",
      "reasoning": "Same province",
      "mappingSource": "fallback_logic"
    }
  }
}
```

### Intercity Mappings
```
GET /api/intercity-mappings
GET /api/intercity-mappings/warehouse/:warehouseArea
POST /api/intercity-mappings
```

Create new mapping:
```json
{
  "warehouseArea": "Bandung",
  "inspectionArea": "Cimahi",
  "isIntercity": false,
  "notes": "Same metropolitan area"
}
```

### Test Endpoint
```
GET /api/test/magelang-yogyakarta
```
Test the specific Magelang-Yogyakarta case.

## Running Tests

The project includes a test script to verify API functionality:

```bash
# Install axios for testing (if not already installed)
npm install axios

# Run tests
node test.js
```

The test script will:
- Check API health
- Test warehouse retrieval
- Test various intercity detection scenarios
- Verify special regional rules (Jabodetabek)
- Test cross-province shipping

## Business Logic

### Intercity Detection Rules

1. **Predefined Mappings**: Check database for existing warehouse-area mappings
2. **Same Area/City**: Not intercity if normalized names match
3. **Metropolitan Regions**: Special handling for Jabodetabek (Jakarta, Bogor, Depok, Tangerang, Bekasi, Cikarang)
4. **Same Province**: Not intercity if warehouse and inspection area are in same province
5. **Default**: Different provinces/regions are considered intercity

### Jabodetabek Areas
The system recognizes these areas as part of the same metropolitan region:
- Jakarta
- Bogor
- Depok
- Tangerang
- Bekasi
- Cikarang

## Environment Variables

Create a `.env` file for production:
```env
PORT=3000
DB_HOST=127.0.0.1
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=db_intercity_mapping
NODE_ENV=production
```

## Error Handling

The API includes comprehensive error handling:
- Database connection errors
- Invalid request parameters
- Missing warehouses
- Server errors (500)
- Not found endpoints (404)

## Development

### Project Structure
```
├── index.js          # Main API server
├── test.js           # API test script
├── package.json      # Dependencies
└── README.md         # This file
```

### Adding New Features
1. Add new endpoints in `index.js`
2. Update test cases in `test.js`
3. Update this README with new functionality

## Production Deployment

1. Set up production database
2. Configure environment variables
3. Use process manager like PM2:
```bash
npm install -g pm2
pm2 start index.js --name "intercity-api"
```

## Dependencies

- **express**: Web framework
- **mysql2**: MySQL database driver with promise support
- **cors**: Cross-origin resource sharing
- **axios**: HTTP client (for testing)

## License

This project is licensed under the MIT License.

## Support

For issues or questions, please check the API health endpoint and review the test cases for expected behavior.