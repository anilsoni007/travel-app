const express = require('express');
const pool = require('../config/db');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

router.post('/', authMiddleware, async (req, res) => {
  try {
    const { booking_id, amount, payment_method } = req.body;
    
    const transaction_id = `TXN${Date.now()}${Math.random().toString(36).substr(2, 9)}`;
    
    const result = await pool.query(
      'INSERT INTO payments (booking_id, amount, payment_method, transaction_id, status) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [booking_id, amount, payment_method, transaction_id, 'completed']
    );
    
    await pool.query(
      'UPDATE bookings SET status = $1 WHERE id = $2',
      ['confirmed', booking_id]
    );
    
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

router.get('/:bookingId', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM payments WHERE booking_id = $1',
      [req.params.bookingId]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
