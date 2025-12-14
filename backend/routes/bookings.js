const express = require('express');
const pool = require('../config/db');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

router.post('/', authMiddleware, async (req, res) => {
  try {
    const { booking_type, flight_id, hotel_id, check_in_date, check_out_date, total_price } = req.body;
    
    const result = await pool.query(
      'INSERT INTO bookings (user_id, booking_type, flight_id, hotel_id, check_in_date, check_out_date, total_price) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
      [req.user.id, booking_type, flight_id, hotel_id, check_in_date, check_out_date, total_price]
    );
    
    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

router.get('/', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT b.*, f.airline, f.flight_number, f.origin, f.destination, 
              h.name as hotel_name, h.location as hotel_location
       FROM bookings b
       LEFT JOIN flights f ON b.flight_id = f.id
       LEFT JOIN hotels h ON b.hotel_id = h.id
       WHERE b.user_id = $1
       ORDER BY b.created_at DESC`,
      [req.user.id]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.patch('/:id/cancel', authMiddleware, async (req, res) => {
  try {
    const result = await pool.query(
      'UPDATE bookings SET status = $1 WHERE id = $2 AND user_id = $3 RETURNING *',
      ['cancelled', req.params.id, req.user.id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Booking not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;
