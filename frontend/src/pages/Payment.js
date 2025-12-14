import React, { useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { paymentAPI } from '../services/api';

function Payment() {
  const { bookingId } = useParams();
  const navigate = useNavigate();
  const [paymentData, setPaymentData] = useState({
    payment_method: 'credit_card',
    card_number: '',
    card_holder: '',
    expiry: '',
    cvv: ''
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await paymentAPI.process({
        booking_id: bookingId,
        amount: 100,
        payment_method: paymentData.payment_method
      });
      alert('Payment successful! Booking confirmed.');
      navigate('/bookings');
    } catch (err) {
      alert('Payment failed');
    }
  };

  return (
    <div className="card" style={{maxWidth: '500px', margin: '50px auto'}}>
      <h2>Payment</h2>
      <p style={{background: '#fff3cd', padding: '10px', borderRadius: '4px', marginBottom: '20px'}}>
        This is a dummy payment page. No real payment will be processed.
      </p>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label>Payment Method</label>
          <select value={paymentData.payment_method} onChange={(e) => setPaymentData({...paymentData, payment_method: e.target.value})}>
            <option value="credit_card">Credit Card</option>
            <option value="debit_card">Debit Card</option>
            <option value="paypal">PayPal</option>
          </select>
        </div>
        <div className="form-group">
          <label>Card Number</label>
          <input type="text" placeholder="1234 5678 9012 3456" value={paymentData.card_number} onChange={(e) => setPaymentData({...paymentData, card_number: e.target.value})} required />
        </div>
        <div className="form-group">
          <label>Card Holder Name</label>
          <input type="text" value={paymentData.card_holder} onChange={(e) => setPaymentData({...paymentData, card_holder: e.target.value})} required />
        </div>
        <div style={{display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '15px'}}>
          <div className="form-group">
            <label>Expiry Date</label>
            <input type="text" placeholder="MM/YY" value={paymentData.expiry} onChange={(e) => setPaymentData({...paymentData, expiry: e.target.value})} required />
          </div>
          <div className="form-group">
            <label>CVV</label>
            <input type="text" placeholder="123" value={paymentData.cvv} onChange={(e) => setPaymentData({...paymentData, cvv: e.target.value})} required />
          </div>
        </div>
        <button type="submit" className="btn btn-success" style={{width: '100%', marginTop: '10px'}}>Complete Payment</button>
      </form>
    </div>
  );
}

export default Payment;
