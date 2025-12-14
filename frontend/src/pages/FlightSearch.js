import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { flightAPI, bookingAPI } from '../services/api';

function FlightSearch() {
  const [searchParams, setSearchParams] = useState({ origin: '', destination: '', date: '' });
  const [flights, setFlights] = useState([]);
  const navigate = useNavigate();

  const handleSearch = async (e) => {
    e.preventDefault();
    try {
      const response = await flightAPI.search(searchParams);
      setFlights(response.data);
    } catch (err) {
      alert('Search failed');
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
      <div className="card">
        <h2>Search Flights</h2>
        <form onSubmit={handleSearch}>
          <div style={{display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '15px'}}>
            <div className="form-group">
              <label>Origin</label>
              <input type="text" value={searchParams.origin} onChange={(e) => setSearchParams({...searchParams, origin: e.target.value})} />
            </div>
            <div className="form-group">
              <label>Destination</label>
              <input type="text" value={searchParams.destination} onChange={(e) => setSearchParams({...searchParams, destination: e.target.value})} />
            </div>
            <div className="form-group">
              <label>Date</label>
              <input type="date" value={searchParams.date} onChange={(e) => setSearchParams({...searchParams, date: e.target.value})} />
            </div>
          </div>
          <button type="submit" className="btn btn-primary">Search</button>
        </form>
      </div>

      <div className="search-results">
        {flights.map(flight => (
          <div key={flight.id} className="result-card">
            <h3>{flight.airline} - {flight.flight_number}</h3>
            <p><strong>From:</strong> {flight.origin}</p>
            <p><strong>To:</strong> {flight.destination}</p>
            <p><strong>Departure:</strong> {new Date(flight.departure_time).toLocaleString()}</p>
            <p><strong>Arrival:</strong> {new Date(flight.arrival_time).toLocaleString()}</p>
            <p className="price">${flight.price}</p>
            <button onClick={() => handleBook(flight)} className="btn btn-success">Book Now</button>
          </div>
        ))}
      </div>
    </div>
  );
}

export default FlightSearch;
