-- Generate flights for TODAY, TOMORROW, and next 7 days with dynamic pricing
-- TODAY: 50% higher prices, TOMORROW: 25% higher, REST: normal

-- Mumbai routes (TODAY - premium pricing)
INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats) 
SELECT 'Air India', 'AI' || gs, 'Mumbai', city, 
       CURRENT_DATE + (gs || ' hours')::interval, 
       CURRENT_DATE + ((gs + 2) || ' hours')::interval,
       base_price * 1.5, 150
FROM generate_series(6, 20, 2) gs,
     (VALUES ('Delhi', 120), ('Bangalore', 110), ('Kolkata', 140), ('Chennai', 130), 
             ('Hyderabad', 100), ('Pune', 80), ('Goa', 95), ('Ahmedabad', 90)) AS cities(city, base_price)
WHERE gs <= 20;
