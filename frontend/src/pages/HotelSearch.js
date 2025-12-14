import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { hotelAPI, bookingAPI } from '../services/api';

function HotelSearch() {
  const [searchParams, setSearchParams] = useState({ location: '', starRating: '', minPrice: '', maxPrice: '' });
  const [hotels, setHotels] = useState([]);
  const [checkIn, setCheckIn] = useState('');
  const [checkOut, setCheckOut] = useState('');
  const navigate = useNavigate();

  const handleSearch = async (e) => {
    e.preventDefault();
    try {
      const response = await hotelAPI.search(searchParams);
      setHotels(response.data);
    } catch (err) {
      alert('Search failed');
    }
  };

  const handleBook = async (hotel) => {
    if (!checkIn || !checkOut) {
      alert('Please select check-in and check-out dates');
      return;
    }
    try {
      const nights = Math.ceil((new Date(checkOut) - new Date(checkIn)) / (1000 * 60 * 60 * 24));
      const bookingData = {
        booking_type: 'hotel',
        hotel_id: hotel.id,
        check_in_date: checkIn,
        check_out_date: checkOut,
        total_price: hotel.price_per_night * nights
      };
      const response = await bookingAPI.create(bookingData);
      navigate(`/payment/${response.data.id}`);
    } catch (err) {
      alert('Booking failed');
    }
  };

  return (
    <div>
      <div className="card">
        <h2>Search Hotels</h2>
        <form onSubmit={handleSearch}>
          <div style={{display: 'grid', gridTemplateColumns: '1fr 1fr 1fr 1fr', gap: '15px'}}>
            <div className="form-group">
              <label>Location</label>
              <input type="text" value={searchParams.location} onChange={(e) => setSearchParams({...searchParams, location: e.target.value})} />
            </div>
            <div className="form-group">
              <label>Star Rating</label>
              <select value={searchParams.starRating} onChange={(e) => setSearchParams({...searchParams, starRating: e.target.value})}>
                <option value="">Any</option>
                <option value="3">3 Stars</option>
                <option value="4">4 Stars</option>
                <option value="5">5 Stars</option>
              </select>
            </div>
            <div className="form-group">
              <label>Check-in</label>
              <input type="date" value={checkIn} onChange={(e) => setCheckIn(e.target.value)} />
            </div>
            <div className="form-group">
              <label>Check-out</label>
              <input type="date" value={checkOut} onChange={(e) => setCheckOut(e.target.value)} />
            </div>
          </div>
          <button type="submit" className="btn btn-primary">Search</button>
        </form>
      </div>

      <div className="search-results">
        {hotels.map(hotel => (
          <div key={hotel.id} className="result-card">
            <h3>{hotel.name}</h3>
            <p><strong>Location:</strong> {hotel.location}</p>
            <p><strong>Rating:</strong> {'⭐'.repeat(hotel.star_rating)}</p>
            <p><strong>Amenities:</strong> {hotel.amenities?.join(', ')}</p>
            <p className="price">${hotel.price_per_night}/night</p>
            <button onClick={() => handleBook(hotel)} className="btn btn-success">Book Now</button>
          </div>
        ))}
      </div>
    </div>
  );
}

export default HotelSearch;
