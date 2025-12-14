const express = require('express');
const pool = require('../config/db');

const router = express.Router();

router.get('/search', async (req, res) => {
  try {
    const { location, minPrice, maxPrice, starRating } = req.query;
    let query = 'SELECT * FROM hotels WHERE 1=1';
    const params = [];
    
    if (location) {
      params.push(`%${location}%`);
      query += ` AND location ILIKE $${params.length}`;
    }
    if (minPrice) {
      params.push(minPrice);
      query += ` AND price_per_night >= $${params.length}`;
    }
    if (maxPrice) {
      params.push(maxPrice);
      query += ` AND price_per_night <= $${params.length}`;
    }
    if (starRating) {
      params.push(starRating);
      query += ` AND star_rating = $${params.length}`;
    }
    
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM hotels WHERE id = $1', [req.params.id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Hotel not found' });
    }
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
