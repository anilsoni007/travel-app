const express = require('express');
const pool = require('../config/db');

const router = express.Router();

router.get('/search', async (req, res) => {
  try {
    const { origin, destination, date } = req.query;
    let query = 'SELECT * FROM flights WHERE departure_time >= CURRENT_TIMESTAMP';
    const params = [];
    
    if (origin) {
      params.push(`%${origin}%`);
      query += ` AND origin ILIKE $${params.length}`;
    }
    if (destination) {
      params.push(`%${destination}%`);
      query += ` AND destination ILIKE $${params.length}`;
    }
    if (date) {
      params.push(date);
      query += ` AND DATE(departure_time) = $${params.length}`;
    }
    
    query += ' ORDER BY departure_time LIMIT 50';
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/all', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM flights ORDER BY departure_time LIMIT 20');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM flights WHERE id = $1', [req.params.id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Flight not found' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
