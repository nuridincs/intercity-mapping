// test.js - API Testing Examples
const axios = require('axios');

const API_BASE_URL = 'http://localhost:3000/api';

// Test functions
async function testAPI() {
  console.log('🚀 Starting API Tests...\n');

  try {
    // 1. Health Check
    console.log('1. Testing Health Check...');
    const healthResponse = await axios.get(`${API_BASE_URL}/health`);
    console.log('✅ Health Check:', healthResponse.data.message);
    console.log('');

    // 2. Get all warehouses
    console.log('2. Testing Get All Warehouses...');
    const warehousesResponse = await axios.get(`${API_BASE_URL}/warehouses`);
    console.log(
      `✅ Found ${warehousesResponse.data.data.length} active warehouses`
    );
    console.log(
      'First 3 warehouses:',
      warehousesResponse.data.data.slice(0, 3).map((w) => w.warehouse_name)
    );
    console.log('');

    // 3. Test intercity detection - Magelang to Yogyakarta (should be NOT INTERCITY)
    console.log('3. Testing Intercity Detection - Magelang to Yogyakarta...');
    const intercityTest1 = await axios.post(`${API_BASE_URL}/check-intercity`, {
      warehouseName: 'Magelang',
      inspectionArea: 'Yogyakarta',
    });
    console.log(
      '✅ Magelang → Yogyakarta:',
      intercityTest1.data.data.result.resultLogic
    );
    console.log('   Reasoning:', intercityTest1.data.data.result.reasoning);
    console.log('');

    // 4. Test intercity detection - Magelang to Jakarta (should be INTERCITY)
    console.log('4. Testing Intercity Detection - Magelang to Jakarta...');
    const intercityTest2 = await axios.post(`${API_BASE_URL}/check-intercity`, {
      warehouseName: 'Magelang',
      inspectionArea: 'Jakarta',
    });
    console.log(
      '✅ Magelang → Jakarta:',
      intercityTest2.data.data.result.resultLogic
    );
    console.log('   Reasoning:', intercityTest2.data.data.result.reasoning);
    console.log('');

    // 5. Test same area - Bekasi to Bekasi (should be NOT INTERCITY)
    console.log('5. Testing Same Area Detection - Cikarang to Bekasi...');
    const intercityTest3 = await axios.post(`${API_BASE_URL}/check-intercity`, {
      warehouseName: 'Cikarang',
      inspectionArea: 'Bekasi',
    });
    console.log(
      '✅ Cikarang → Bekasi:',
      intercityTest3.data.data.result.resultLogic
    );
    console.log('   Reasoning:', intercityTest3.data.data.result.reasoning);
    console.log('');

    // 6. Test Jabodetabek area (should be NOT INTERCITY)
    console.log('6. Testing Jabodetabek Area - Jatibening to Tangerang...');
    const intercityTest4 = await axios.post(`${API_BASE_URL}/check-intercity`, {
      warehouseName: 'Jatibening',
      inspectionArea: 'Tangerang',
    });
    console.log(
      '✅ Jatibening → Tangerang:',
      intercityTest4.data.data.result.resultLogic
    );
    console.log('   Reasoning:', intercityTest4.data.data.result.reasoning);
    console.log('');

    // 7. Test cross-province (should be INTERCITY)
    console.log('7. Testing Cross Province - Medan to Surabaya...');
    const intercityTest5 = await axios.post(`${API_BASE_URL}/check-intercity`, {
      warehouseName: 'Medan Pusat',
      inspectionArea: 'Surabaya',
    });
    console.log(
      '✅ Medan Pusat → Surabaya:',
      intercityTest5.data.data.result.resultLogic
    );
    console.log('   Reasoning:', intercityTest5.data.data.result.reasoning);
    console.log('');

    // 8. Test the specific test endpoint
    console.log('8. Testing Specific Test Endpoint...');
    const testEndpoint = await axios.get(
      `${API_BASE_URL}/test/magelang-yogyakarta`
    );
    console.log('✅ Test Endpoint Result:', testEndpoint.data.message);
    console.log('   Expected:', testEndpoint.data.expected);
    console.log('');

    // 9. Get intercity mappings
    console.log('9. Testing Get Intercity Mappings...');
    const mappingsResponse = await axios.get(
      `${API_BASE_URL}/intercity-mappings`
    );
    console.log(
      `✅ Found ${mappingsResponse.data.data.length} predefined mappings`
    );
    console.log(
      'Sample mappings:',
      mappingsResponse.data.data
        .slice(0, 3)
        .map(
          (m) => `${m.warehouse_area} → ${m.inspection_area}: ${m.result_logic}`
        )
    );
    console.log('');
  } catch (error) {
    console.error('❌ Error during API tests:', error.message);
    if (error.response) {
      console.error('Response data:', error.response.data);
    }
    console.error(
      'Status code:',
      error.response ? error.response.status : 'N/A'
    );
  }
}

testAPI();