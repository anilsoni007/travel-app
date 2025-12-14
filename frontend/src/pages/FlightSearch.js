import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { flightAPI, bookingAPI } from '../services/api';

const CITIES = [
  'Mumbai', 'Delhi', 'Bangalore', 'Kolkata', 'Chennai', 'Hyderabad', 'Pune', 'Ahmedabad',
  'Jaipur', 'Goa', 'Kochi', 'Lucknow', 'Chandigarh', 'Indore', 'Bhopal',
  'London', 'New York', 'Dubai', 'Singapore', 'Paris', 'Tokyo', 'Bangkok', 'Sydney',
  'Los Angeles', 'Hong Kong', 'Toronto', 'Amsterdam', 'Barcelona', 'Rome'
];

function FlightSearch() {
  const [searchParams, setSearchParams] = useState({ origin: '', destination: '', date: '' });
  const [flights, setFlights] = useState([]);
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  const handleSearch = async (e) => {
    e.preventDefault();
    if (!searchParams.origin || !searchParams.destination) {
      alert('Please select origin and destination');
      return;
    }
    setLoading(true);
    try {
      const response = await flightAPI.search(searchParams);
      setFlights(response.data || []);
      if (response.data.length === 0) {
        alert('No flights found. Try different search criteria.');
      }
    } catch (err) {
      console.error('Search error:', err);
      alert('Search failed: ' + (err.response?.data?.error || err.message));
    } finally {
      setLoading(false);
    }
  };

  const handleBook = async (flight) => {
    try {
      const bookingData = {
        booking_type: 'flight',
        flight_id: flight.id,
        total_price: flight.price
      };
      const response = await bookingAPI.create(bookingData);
      navigate(`/payment/${response.data.id}`);
    } catch (err) {
      alert('Booking failed');
    }
  };

  return (
    <div>
      <div className="card flight-search-card">
        <h2>✈️ Search Flights</h2>
        <form onSubmit={handleSearch}>
          <div style={{display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '15px'}}>
            <div className="form-group">
              <label>🛫 Origin</label>
              <select 
                value={searchParams.origin} 
                onChange={(e) => setSearchParams({...searchParams, origin: e.target.value})}
                required
              >
                <option value="">Select Origin</option>
                {CITIES.map(city => <option key={city} value={city}>{city}</option>)}
              </select>
            </div>
            <div className="form-group">
              <label>🛬 Destination</label>
              <select 
                value={searchParams.destination} 
                onChange={(e) => setSearchParams({...searchParams, destination: e.target.value})}                required
              >
                <option value="">Select Destination</option>
                {CITIES.map(city => <option key={city} value={city}>{city}</option>)}
              </select>
            </div>
            <div className="form-group">
              <label>📅 Date</label>
              <input 
                type="date" 
                value={searchParams.date} 
                onChange={(e) => setSearchParams({...searchParams, date: e.target.value})} 
                min={new Date().toISOString().split('T')[0]}
              />
            </div>
          </div>
          <button type="submit" className="btn btn-primary" disabled={loading}>
            {loading ? '🔍 Searching...' : '🔍 Search Flights'}
          </button>
        </form>
      </div>

      {flights.length > 0 && (
        <div className="search-results">
          {flights.map(flight => (
            <div key={flight.id} className="result-card flight-card">
              <div className="flight-header">
                <h3>✈️ {flight.airline}</h3>
                <span className="flight-number">{flight.flight_number}</span>
              </div>
              <div className="flight-route">
                <div className="route-point">
                  <span className="city">{flight.origin}</span>
                  <span className="time">{new Date(flight.departure_time).toLocaleTimeString('en-US', {hour: '2-digit', minute: '2-digit'})}</span>
                </div>
                <div className="route-line">→</div>
                <div className="route-point">
                  <span className="city">{flight.destination}</span>
                  <span className="time">{new Date(flight.arrival_time).toLocaleTimeString('en-US', {hour: '2-digit', minute: '2-digit'})}</span>
                </div>
              </div>
              <p className="flight-date">📅 {new Date(flight.departure_time).toLocaleDateString('en-US', {weekday: 'short', year: 'numeric', month: 'short', day: 'numeric'})}</p>
              <p className="seats">💺 {flight.available_seats} seats available</p>
              <p className="price">₹{(flight.price * 83).toFixed(0)}</p>
              <button onClick={() => handleBook(flight)} className="btn btn-success">Book Now</button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export default FlightSearch;
