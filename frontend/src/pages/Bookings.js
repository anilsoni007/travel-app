import React, { useState, useEffect } from 'react';
import { bookingAPI } from '../services/api';

function Bookings() {
  const [bookings, setBookings] = useState([]);

  useEffect(() => {
    loadBookings();
  }, []);

  const loadBookings = async () => {
    try {
      const response = await bookingAPI.getAll();
      setBookings(response.data);
    } catch (err) {
      alert('Failed to load bookings');
    }
  };

  const handleCancel = async (id) => {
    if (window.confirm('Are you sure you want to cancel this booking?')) {
      try {
        await bookingAPI.cancel(id);
        loadBookings();
      } catch (err) {
        alert('Failed to cancel booking');
      }
    }
  };

  return (
    <div>
      <h2>My Bookings</h2>
      {bookings.length === 0 ? (
        <div className="card">
          <p>No bookings found</p>
        </div>
      ) : (
        bookings.map(booking => (
          <div key={booking.id} className="card">
            <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'start'}}>
              <div>
                <h3>Booking #{booking.id} - {booking.booking_type.toUpperCase()}</h3>
                {booking.airline && <p><strong>Flight:</strong> {booking.airline} {booking.flight_number} ({booking.origin} → {booking.destination})</p>}
                {booking.hotel_name && <p><strong>Hotel:</strong> {booking.hotel_name} - {booking.hotel_location}</p>}
                {booking.check_in_date && <p><strong>Check-in:</strong> {booking.check_in_date}</p>}
                {booking.check_out_date && <p><strong>Check-out:</strong> {booking.check_out_date}</p>}
                <p><strong>Total Price:</strong> ${booking.total_price}</p>
                <p><strong>Status:</strong> <span style={{color: booking.status === 'confirmed' ? 'green' : booking.status === 'cancelled' ? 'red' : 'orange'}}>{booking.status.toUpperCase()}</span></p>
              </div>
              {booking.status === 'pending' && (
                <button onClick={() => handleCancel(booking.id)} className="btn btn-danger">Cancel</button>
              )}
            </div>
          </div>
        ))
      )}
    </div>
  );
}

export default Bookings;
