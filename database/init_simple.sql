-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Flights table
CREATE TABLE flights (
    id SERIAL PRIMARY KEY,
    airline VARCHAR(100) NOT NULL,
    flight_number VARCHAR(20) NOT NULL,
    origin VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    departure_time TIMESTAMP NOT NULL,
    arrival_time TIMESTAMP NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    available_seats INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Hotels table
CREATE TABLE hotels (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    address TEXT,
    star_rating INTEGER CHECK (star_rating >= 1 AND star_rating <= 5),
    price_per_night DECIMAL(10, 2) NOT NULL,
    available_rooms INTEGER NOT NULL,
    amenities TEXT[],
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bookings table
CREATE TABLE bookings (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    booking_type VARCHAR(20) CHECK (booking_type IN ('flight', 'hotel', 'both')),
    flight_id INTEGER REFERENCES flights(id) ON DELETE SET NULL,
    hotel_id INTEGER REFERENCES hotels(id) ON DELETE SET NULL,
    check_in_date DATE,
    check_out_date DATE,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payments table
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES bookings(id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    transaction_id VARCHAR(255) UNIQUE,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert test user
INSERT INTO users (email, password, first_name, last_name, phone) VALUES
('test@example.com', '$2a$10$rXKv7VZJZJZJZJZJZJZJZOqKqKqKqKqKqKqKqKqKqKqKqKqKqKqKqK', 'Test', 'User', '1234567890');

-- 10 MAJOR CITIES: Mumbai, Delhi, Bangalore, Dubai, Singapore, London, New York, Paris, Tokyo, Sydney

-- ALL PAIRINGS - TODAY (50% higher price)
INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats) VALUES
('Air India', 'AI1001', 'Mumbai', 'Delhi', CURRENT_DATE + TIME '08:00:00', CURRENT_DATE + TIME '10:30:00', 180.00, 150),
('Air India', 'AI1002', 'Mumbai', 'Bangalore', CURRENT_DATE + TIME '09:00:00', CURRENT_DATE + TIME '10:45:00', 165.00, 150),
('Air India', 'AI1003', 'Mumbai', 'Dubai', CURRENT_DATE + TIME '22:00:00', CURRENT_DATE + TIME '00:30:00', 480.00, 200),
('Air India', 'AI1004', 'Mumbai', 'Singapore', CURRENT_DATE + TIME '23:00:00', CURRENT_DATE + TIME '07:00:00', 675.00, 200),
('Air India', 'AI1005', 'Mumbai', 'London', CURRENT_DATE + TIME '15:00:00', CURRENT_DATE + TIME '20:30:00', 975.00, 250),
('Air India', 'AI1006', 'Mumbai', 'New York', CURRENT_DATE + TIME '02:00:00', CURRENT_DATE + TIME '08:00:00', 1275.00, 250),
('Air India', 'AI1007', 'Mumbai', 'Paris', CURRENT_DATE + TIME '16:00:00', CURRENT_DATE + TIME '22:00:00', 1080.00, 250),
('Air India', 'AI1008', 'Mumbai', 'Tokyo', CURRENT_DATE + TIME '03:00:00', CURRENT_DATE + TIME '15:00:00', 1170.00, 250),
('Air India', 'AI1009', 'Mumbai', 'Sydney', CURRENT_DATE + TIME '20:00:00', CURRENT_DATE + TIME '16:00:00', 1425.00, 250),

('IndiGo', 'IG2001', 'Delhi', 'Mumbai', CURRENT_DATE + TIME '14:00:00', CURRENT_DATE + TIME '16:30:00', 180.00, 150),
('IndiGo', 'IG2002', 'Delhi', 'Bangalore', CURRENT_DATE + TIME '11:00:00', CURRENT_DATE + TIME '13:45:00', 225.00, 150),
('IndiGo', 'IG2003', 'Delhi', 'Dubai', CURRENT_DATE + TIME '09:00:00', CURRENT_DATE + TIME '11:30:00', 420.00, 200),
('IndiGo', 'IG2004', 'Delhi', 'Singapore', CURRENT_DATE + TIME '03:00:00', CURRENT_DATE + TIME '10:30:00', 675.00, 200),
('IndiGo', 'IG2005', 'Delhi', 'London', CURRENT_DATE + TIME '14:00:00', CURRENT_DATE + TIME '19:30:00', 975.00, 250),
('IndiGo', 'IG2006', 'Delhi', 'New York', CURRENT_DATE + TIME '01:00:00', CURRENT_DATE + TIME '08:30:00', 1275.00, 250),
('IndiGo', 'IG2007', 'Delhi', 'Paris', CURRENT_DATE + TIME '11:00:00', CURRENT_DATE + TIME '17:30:00', 1080.00, 250),
('IndiGo', 'IG2008', 'Delhi', 'Tokyo', CURRENT_DATE + TIME '22:00:00', CURRENT_DATE + TIME '10:00:00', 1170.00, 250),
('IndiGo', 'IG2009', 'Delhi', 'Sydney', CURRENT_DATE + TIME '22:00:00', CURRENT_DATE + TIME '18:30:00', 1425.00, 250),

('SpiceJet', 'SJ3001', 'Bangalore', 'Mumbai', CURRENT_DATE + TIME '18:00:00', CURRENT_DATE + TIME '19:45:00', 165.00, 150),
('SpiceJet', 'SJ3002', 'Bangalore', 'Delhi', CURRENT_DATE + TIME '09:00:00', CURRENT_DATE + TIME '11:45:00', 225.00, 150),
('SpiceJet', 'SJ3003', 'Bangalore', 'Dubai', CURRENT_DATE + TIME '21:00:00', CURRENT_DATE + TIME '23:30:00', 450.00, 200),
('SpiceJet', 'SJ3004', 'Bangalore', 'Singapore', CURRENT_DATE + TIME '08:00:00', CURRENT_DATE + TIME '13:30:00', 570.00, 200),
('SpiceJet', 'SJ3005', 'Bangalore', 'London', CURRENT_DATE + TIME '13:00:00', CURRENT_DATE + TIME '19:00:00', 975.00, 250),
('SpiceJet', 'SJ3006', 'Bangalore', 'New York', CURRENT_DATE + TIME '23:00:00', CURRENT_DATE + TIME '07:00:00', 1275.00, 250),
('SpiceJet', 'SJ3007', 'Bangalore', 'Paris', CURRENT_DATE + TIME '12:00:00', CURRENT_DATE + TIME '18:30:00', 1080.00, 250),
('SpiceJet', 'SJ3008', 'Bangalore', 'Tokyo', CURRENT_DATE + TIME '01:00:00', CURRENT_DATE + TIME '12:00:00', 1170.00, 250),
('SpiceJet', 'SJ3009', 'Bangalore', 'Sydney', CURRENT_DATE + TIME '19:00:00', CURRENT_DATE + TIME '15:00:00', 1425.00, 250),

-- TOMORROW (25% higher price)
('Air India', 'AI1101', 'Mumbai', 'Delhi', CURRENT_DATE + INTERVAL '1 day' + TIME '08:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '10:30:00', 150.00, 150),
('IndiGo', 'IG2101', 'Delhi', 'Mumbai', CURRENT_DATE + INTERVAL '1 day' + TIME '14:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '16:30:00', 150.00, 150),
('SpiceJet', 'SJ3101', 'Bangalore', 'Mumbai', CURRENT_DATE + INTERVAL '1 day' + TIME '18:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '19:45:00', 138.00, 150),
('Air India', 'AI1102', 'Mumbai', 'Bangalore', CURRENT_DATE + INTERVAL '1 day' + TIME '09:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '10:45:00', 138.00, 150),
('IndiGo', 'IG2102', 'Delhi', 'Bangalore', CURRENT_DATE + INTERVAL '1 day' + TIME '11:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '13:45:00', 188.00, 150),
('SpiceJet', 'SJ3102', 'Bangalore', 'Delhi', CURRENT_DATE + INTERVAL '1 day' + TIME '09:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '11:45:00', 188.00, 150),

-- REGULAR PRICE (2-7 days out) - ALL COMBINATIONS
('Air India', 'AI1201', 'Mumbai', 'Delhi', CURRENT_DATE + INTERVAL '2 days' + TIME '08:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '10:30:00', 120.00, 150),
('Air India', 'AI1202', 'Mumbai', 'Bangalore', CURRENT_DATE + INTERVAL '2 days' + TIME '09:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '10:45:00', 110.00, 150),
('Air India', 'AI1203', 'Mumbai', 'Dubai', CURRENT_DATE + INTERVAL '2 days' + TIME '22:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '00:30:00', 320.00, 200),
('Air India', 'AI1204', 'Mumbai', 'Singapore', CURRENT_DATE + INTERVAL '2 days' + TIME '23:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '07:00:00', 450.00, 200),
('Air India', 'AI1205', 'Mumbai', 'London', CURRENT_DATE + INTERVAL '2 days' + TIME '15:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '20:30:00', 650.00, 250),
('Air India', 'AI1206', 'Mumbai', 'New York', CURRENT_DATE + INTERVAL '2 days' + TIME '02:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '08:00:00', 850.00, 250),
('Air India', 'AI1207', 'Mumbai', 'Paris', CURRENT_DATE + INTERVAL '2 days' + TIME '16:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '22:00:00', 720.00, 250),
('Air India', 'AI1208', 'Mumbai', 'Tokyo', CURRENT_DATE + INTERVAL '2 days' + TIME '03:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '15:00:00', 780.00, 250),
('Air India', 'AI1209', 'Mumbai', 'Sydney', CURRENT_DATE + INTERVAL '2 days' + TIME '20:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '16:00:00', 950.00, 250),

('IndiGo', 'IG2201', 'Delhi', 'Mumbai', CURRENT_DATE + INTERVAL '3 days' + TIME '14:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '16:30:00', 120.00, 150),
('IndiGo', 'IG2202', 'Delhi', 'Bangalore', CURRENT_DATE + INTERVAL '3 days' + TIME '11:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '13:45:00', 150.00, 150),
('IndiGo', 'IG2203', 'Delhi', 'Dubai', CURRENT_DATE + INTERVAL '3 days' + TIME '09:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '11:30:00', 280.00, 200),
('IndiGo', 'IG2204', 'Delhi', 'Singapore', CURRENT_DATE + INTERVAL '3 days' + TIME '03:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '10:30:00', 450.00, 200),
('IndiGo', 'IG2205', 'Delhi', 'London', CURRENT_DATE + INTERVAL '3 days' + TIME '14:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '19:30:00', 650.00, 250),
('IndiGo', 'IG2206', 'Delhi', 'New York', CURRENT_DATE + INTERVAL '3 days' + TIME '01:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '08:30:00', 850.00, 250),
('IndiGo', 'IG2207', 'Delhi', 'Paris', CURRENT_DATE + INTERVAL '3 days' + TIME '11:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '17:30:00', 720.00, 250),
('IndiGo', 'IG2208', 'Delhi', 'Tokyo', CURRENT_DATE + INTERVAL '3 days' + TIME '22:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '10:00:00', 780.00, 250),
('IndiGo', 'IG2209', 'Delhi', 'Sydney', CURRENT_DATE + INTERVAL '3 days' + TIME '22:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '18:30:00', 950.00, 250),

('SpiceJet', 'SJ3201', 'Bangalore', 'Mumbai', CURRENT_DATE + INTERVAL '4 days' + TIME '18:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '19:45:00', 110.00, 150),
('SpiceJet', 'SJ3202', 'Bangalore', 'Delhi', CURRENT_DATE + INTERVAL '4 days' + TIME '09:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '11:45:00', 150.00, 150),
('SpiceJet', 'SJ3203', 'Bangalore', 'Dubai', CURRENT_DATE + INTERVAL '4 days' + TIME '21:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '23:30:00', 300.00, 200),
('SpiceJet', 'SJ3204', 'Bangalore', 'Singapore', CURRENT_DATE + INTERVAL '4 days' + TIME '08:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '13:30:00', 380.00, 200),
('SpiceJet', 'SJ3205', 'Bangalore', 'London', CURRENT_DATE + INTERVAL '4 days' + TIME '13:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '19:00:00', 650.00, 250),
('SpiceJet', 'SJ3206', 'Bangalore', 'New York', CURRENT_DATE + INTERVAL '4 days' + TIME '23:00:00', CURRENT_DATE + INTERVAL '5 days' + TIME '07:00:00', 850.00, 250),
('SpiceJet', 'SJ3207', 'Bangalore', 'Paris', CURRENT_DATE + INTERVAL '4 days' + TIME '12:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '18:30:00', 720.00, 250),
('SpiceJet', 'SJ3208', 'Bangalore', 'Tokyo', CURRENT_DATE + INTERVAL '4 days' + TIME '01:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '12:00:00', 780.00, 250),
('SpiceJet', 'SJ3209', 'Bangalore', 'Sydney', CURRENT_DATE + INTERVAL '4 days' + TIME '19:00:00', CURRENT_DATE + INTERVAL '5 days' + TIME '15:00:00', 950.00, 250),

-- Return flights from international cities
('Emirates', 'EK4001', 'Dubai', 'Mumbai', CURRENT_DATE + INTERVAL '2 days' + TIME '03:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '08:00:00', 320.00, 200),
('Emirates', 'EK4002', 'Dubai', 'Delhi', CURRENT_DATE + INTERVAL '2 days' + TIME '14:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '19:30:00', 280.00, 200),
('Emirates', 'EK4003', 'Dubai', 'Bangalore', CURRENT_DATE + INTERVAL '2 days' + TIME '05:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '10:30:00', 300.00, 200),

('Singapore Airlines', 'SQ5001', 'Singapore', 'Mumbai', CURRENT_DATE + INTERVAL '3 days' + TIME '22:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '04:00:00', 450.00, 200),
('Singapore Airlines', 'SQ5002', 'Singapore', 'Delhi', CURRENT_DATE + INTERVAL '3 days' + TIME '23:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '06:30:00', 450.00, 200),
('Singapore Airlines', 'SQ5003', 'Singapore', 'Bangalore', CURRENT_DATE + INTERVAL '3 days' + TIME '15:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '20:30:00', 380.00, 200),

('British Airways', 'BA6001', 'London', 'Mumbai', CURRENT_DATE + INTERVAL '2 days' + TIME '21:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '10:30:00', 650.00, 250),
('British Airways', 'BA6002', 'London', 'Delhi', CURRENT_DATE + INTERVAL '2 days' + TIME '20:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '09:30:00', 650.00, 250),
('British Airways', 'BA6003', 'London', 'Bangalore', CURRENT_DATE + INTERVAL '2 days' + TIME '19:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '08:30:00', 650.00, 250),

('American Airlines', 'AA7001', 'New York', 'Mumbai', CURRENT_DATE + INTERVAL '3 days' + TIME '20:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '20:00:00', 850.00, 250),
('American Airlines', 'AA7002', 'New York', 'Delhi', CURRENT_DATE + INTERVAL '3 days' + TIME '11:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '10:30:00', 850.00, 250),
('American Airlines', 'AA7003', 'New York', 'Bangalore', CURRENT_DATE + INTERVAL '3 days' + TIME '22:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '22:00:00', 850.00, 250),

('Air France', 'AF8001', 'Paris', 'Mumbai', CURRENT_DATE + INTERVAL '2 days' + TIME '22:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '11:00:00', 720.00, 250),
('Air France', 'AF8002', 'Paris', 'Delhi', CURRENT_DATE + INTERVAL '2 days' + TIME '13:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '01:30:00', 720.00, 250),
('Air France', 'AF8003', 'Paris', 'Bangalore', CURRENT_DATE + INTERVAL '2 days' + TIME '21:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '10:00:00', 720.00, 250),

('JAL', 'JL9001', 'Tokyo', 'Mumbai', CURRENT_DATE + INTERVAL '3 days' + TIME '16:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '00:30:00', 780.00, 250),
('JAL', 'JL9002', 'Tokyo', 'Delhi', CURRENT_DATE + INTERVAL '3 days' + TIME '11:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '19:00:00', 780.00, 250),
('JAL', 'JL9003', 'Tokyo', 'Bangalore', CURRENT_DATE + INTERVAL '3 days' + TIME '13:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '21:00:00', 780.00, 250),

('Qantas', 'QF1001', 'Sydney', 'Mumbai', CURRENT_DATE + INTERVAL '3 days' + TIME '10:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '22:00:00', 950.00, 250),
('Qantas', 'QF1002', 'Sydney', 'Delhi', CURRENT_DATE + INTERVAL '3 days' + TIME '08:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '20:30:00', 950.00, 250),
('Qantas', 'QF1003', 'Sydney', 'Bangalore', CURRENT_DATE + INTERVAL '3 days' + TIME '16:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '04:00:00', 950.00, 250);

-- Hotels for 10 cities
INSERT INTO hotels (name, location, address, star_rating, price_per_night, available_rooms, amenities) VALUES
('Taj Mahal Palace', 'Mumbai', 'Apollo Bunder, Mumbai', 5, 300.00, 50, ARRAY['WiFi', 'Pool', 'Spa', 'Restaurant', 'Gym']),
('The Leela Palace', 'Delhi', 'Diplomatic Enclave, Delhi', 5, 280.00, 45, ARRAY['WiFi', 'Pool', 'Spa', 'Restaurant', 'Bar']),
('ITC Gardenia', 'Bangalore', 'Residency Road, Bangalore', 5, 220.00, 60, ARRAY['WiFi', 'Pool', 'Gym', 'Restaurant']),
('Burj Al Arab', 'Dubai', 'Jumeirah Beach, Dubai', 5, 500.00, 30, ARRAY['WiFi', 'Beach Access', 'Pool', 'Spa', 'Restaurant']),
('Marina Bay Sands', 'Singapore', 'Marina Bay, Singapore', 5, 380.00, 55, ARRAY['WiFi', 'Infinity Pool', 'Casino', 'Restaurant']),
('The Savoy', 'London', 'Strand, London', 5, 450.00, 50, ARRAY['WiFi', 'Pool', 'Spa', 'Restaurant', 'Bar']),
('The Plaza', 'New York', 'Fifth Avenue, New York', 5, 500.00, 45, ARRAY['WiFi', 'Spa', 'Restaurant', 'Bar', 'Gym']),
('Le Meurice', 'Paris', 'Rue de Rivoli, Paris', 5, 420.00, 40, ARRAY['WiFi', 'Spa', 'Restaurant', 'Bar']),
('Park Hyatt', 'Tokyo', 'Shinjuku, Tokyo', 5, 380.00, 60, ARRAY['WiFi', 'Pool', 'Spa', 'Restaurant']),
('Four Seasons', 'Sydney', 'The Rocks, Sydney', 5, 400.00, 55, ARRAY['WiFi', 'Pool', 'Spa', 'Restaurant', 'Bar']);
