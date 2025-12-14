const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'traveldb',
  user: process.env.DB_USER || 'traveluser',
  password: process.env.DB_PASSWORD || 'travelpass',
});

module.exports = pool;
