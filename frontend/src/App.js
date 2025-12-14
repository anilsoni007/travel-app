import React, { useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Link, Navigate } from 'react-router-dom';
import Login from './pages/Login';
import Register from './pages/Register';
import FlightSearch from './pages/FlightSearch';
import HotelSearch from './pages/HotelSearch';
import Bookings from './pages/Bookings';
import Payment from './pages/Payment';

function App() {
  const [token, setToken] = useState(localStorage.getItem('token'));

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    setToken(null);
  };

  return (
    <Router>
      <div className="App">
        <nav className="navbar">
          <h1>Travel Booking System</h1>
          <div>
            {token ? (
              <>
                <Link to="/flights">Flights</Link>
                <Link to="/hotels">Hotels</Link>
                <Link to="/bookings">My Bookings</Link>
                <button onClick={handleLogout} className="btn btn-danger" style={{marginLeft: '20px'}}>Logout</button>
              </>
            ) : (
              <>
                <Link to="/login">Login</Link>
                <Link to="/register">Register</Link>
              </>
            )}
          </div>
        </nav>

        <div className="container">
          <Routes>
            <Route path="/login" element={<Login setToken={setToken} />} />
            <Route path="/register" element={<Register />} />
            <Route path="/flights" element={token ? <FlightSearch /> : <Navigate to="/login" />} />
            <Route path="/hotels" element={token ? <HotelSearch /> : <Navigate to="/login" />} />
            <Route path="/bookings" element={token ? <Bookings /> : <Navigate to="/login" />} />
            <Route path="/payment/:bookingId" element={token ? <Payment /> : <Navigate to="/login" />} />
            <Route path="/" element={<Navigate to={token ? "/flights" : "/login"} />} />
          </Routes>
        </div>
      </div>
    </Router>
  );
}

export default App;
