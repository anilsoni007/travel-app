import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { hotelAPI, bookingAPI } from '../services/api';

const LOCATIONS = [
  'Mumbai', 'Delhi', 'Bangalore', 'Dubai', 'Singapore', 
  'London', 'New York', 'Paris', 'Tokyo', 'Sydney'
];

function HotelSearch() {
  const [searchParams, setSearchParams] = useState({ location: '', starRating: '' });
  const [hotels, setHotels] = useState([]);
  const [checkIn, setCheckIn] = useState('');
  const [checkOut, setCheckOut] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleSearch = async (e) => {
    e.preventDefault();
    if (!searchParams.location) {
      alert('Please select a location');
      return;
    }
    setLoading(true);
    try {
      const response = await hotelAPI.search(searchParams);
      setHotels(response.data || []);
      if (response.data.length === 0) {
        alert('No hotels found. Try different search criteria.');
      }
    } catch (err) {
      console.error('Search error:', err);
      alert('Search failed: ' + (err.response?.data?.error || err.message));
    } finally {
      setLoading(false);
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
      <div className="card hotel-search-card">
        <h2>🏨 Search Hotels</h2>
        <form onSubmit={handleSearch}>
          <div style={{display: 'grid', gridTemplateColumns: '1fr 1fr 1fr 1fr', gap: '15px'}}>
            <div className="form-group">
              <label>📍 Location</label>
              <select 
                value={searchParams.location} 
                onChange={(e) => setSearchParams({...searchParams, location: e.target.value})}
                required
              >
                <option value="">Select Location</option>
                {LOCATIONS.map(loc => <option key={loc} value={loc}>{loc}</option>)}
              </select>
            </div>
            <div className="form-group">
              <label>⭐ Star Rating</label>
              <select value={searchParams.starRating} onChange={(e) => setSearchParams({...searchParams, starRating: e.target.value})}>
                <option value="">Any</option>
                <option value="3">3 Stars</option>
                <option value="4">4 Stars</option>
                <option value="5">5 Stars</option>
              </select>
            </div>
            <div className="form-group">
              <label>📅 Check-in</label>
              <input 
                type="date" 
                value={checkIn} 
                onChange={(e) => setCheckIn(e.target.value)} 
                min={new Date().toISOString().split('T')[0]}
              />
            </div>
            <div className="form-group">
              <label>📅 Check-out</label>
              <input 
                type="date" 
                value={checkOut} 
                onChange={(e) => setCheckOut(e.target.value)} 
                min={checkIn || new Date().toISOString().split('T')[0]}
              />
            </div>
          </div>
          <button type="submit" className="btn btn-primary" disabled={loading}>
            {loading ? '🔍 Searching...' : '🔍 Search Hotels'}
          </button>
        </form>
      </div>

      {hotels.length > 0 && (
        <div className="search-results">
          {hotels.map(hotel => (
            <div key={hotel.id} className="result-card hotel-card">
              <div className="hotel-header">
                <h3>🏨 {hotel.name}</h3>
                <div className="rating">{'⭐'.repeat(hotel.star_rating)}</div>
              </div>
              <p className="location">📍 {hotel.location}</p>
              <p className="address">{hotel.address}</p>
              <div className="amenities">
                {hotel.amenities?.map((amenity, idx) => (
                  <span key={idx} className="amenity-tag">{amenity}</span>
                ))}
              </div>
              <p className="price">₹{(hotel.price_per_night * 83).toFixed(0)}/night</p>
              <button onClick={() => handleBook(hotel)} className="btn btn-success">Book Now</button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export default HotelSearch;
