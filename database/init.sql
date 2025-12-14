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

-- Insert default test user (email: test@example.com, password: test123)
INSERT INTO users (email, password, first_name, last_name, phone) VALUES
('test@example.com', '$2a$10$rXKv7VZJZJZJZJZJZJZJZOqKqKqKqKqKqKqKqKqKqKqKqKqKqKqKqK', 'Test', 'User', '1234567890');

-- Insert sample flights (multiple days with dynamic pricing)
INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats) VALUES
-- TODAY (Higher prices)
('Air India', 'AI101', 'Mumbai', 'Delhi', CURRENT_DATE + TIME '08:00:00', CURRENT_DATE + TIME '10:30:00', 180.00, 150),
('IndiGo', 'IG202', 'Delhi', 'Mumbai', CURRENT_DATE + TIME '14:00:00', CURRENT_DATE + TIME '16:30:00', 180.00, 180),
('SpiceJet', 'SJ303', 'Mumbai', 'Bangalore', CURRENT_DATE + TIME '06:30:00', CURRENT_DATE + TIME '08:15:00', 165.00, 160),
('Air India', 'AI105', 'Delhi', 'Bangalore', CURRENT_DATE + TIME '11:00:00', CURRENT_DATE + TIME '13:45:00', 225.00, 180),
-- TOMORROW (Higher prices)
('Air India', 'AI101T', 'Mumbai', 'Delhi', CURRENT_DATE + INTERVAL '1 day' + TIME '08:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '10:30:00', 150.00, 150),
('IndiGo', 'IG202T', 'Delhi', 'Mumbai', CURRENT_DATE + INTERVAL '1 day' + TIME '14:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '16:30:00', 150.00, 180),
('SpiceJet', 'SJ303T', 'Mumbai', 'Bangalore', CURRENT_DATE + INTERVAL '1 day' + TIME '06:30:00', CURRENT_DATE + INTERVAL '1 day' + TIME '08:15:00', 138.00, 160),
('Air India', 'AI105T', 'Delhi', 'Bangalore', CURRENT_DATE + INTERVAL '1 day' + TIME '11:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '13:45:00', 188.00, 180),
-- REGULAR PRICES (2+ days out)
('Air India', 'AI101R', 'Mumbai', 'Delhi', CURRENT_DATE + INTERVAL '2 days' + TIME '08:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '10:30:00', 120.00, 150),
('IndiGo', 'IG202R', 'Delhi', 'Mumbai', CURRENT_DATE + INTERVAL '3 days' + TIME '14:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '16:30:00', 120.00, 180),
('SpiceJet', 'SJ303R', 'Mumbai', 'Bangalore', CURRENT_DATE + INTERVAL '4 days' + TIME '06:30:00', CURRENT_DATE + INTERVAL '4 days' + TIME '08:15:00', 110.00, 160),
('Vistara', 'UK404', 'Bangalore', 'Mumbai', CURRENT_DATE + INTERVAL '2 days' + TIME '18:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '19:45:00', 110.00, 140),
('IndiGo', 'IG206', 'Bangalore', 'Delhi', CURRENT_DATE + INTERVAL '3 days' + TIME '09:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '11:45:00', 150.00, 170),
('SpiceJet', 'SJ307', 'Mumbai', 'Kolkata', CURRENT_DATE + INTERVAL '1 day' + TIME '07:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '09:30:00', 140.00, 150),
('Vistara', 'UK408', 'Kolkata', 'Mumbai', CURRENT_DATE + INTERVAL '2 days' + TIME '15:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '17:30:00', 140.00, 160),
('Air India', 'AI109', 'Delhi', 'Chennai', CURRENT_DATE + INTERVAL '1 day' + TIME '06:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '08:45:00', 160.00, 180),
('IndiGo', 'IG210', 'Chennai', 'Delhi', CURRENT_DATE + INTERVAL '3 days' + TIME '19:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '21:45:00', 160.00, 170),
('SpiceJet', 'SJ311', 'Mumbai', 'Hyderabad', CURRENT_DATE + INTERVAL '1 day' + TIME '12:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '13:30:00', 100.00, 140),
('Vistara', 'UK412', 'Hyderabad', 'Mumbai', CURRENT_DATE + INTERVAL '2 days' + TIME '16:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '17:30:00', 100.00, 150),
('Air India', 'AI113', 'Delhi', 'Pune', CURRENT_DATE + INTERVAL '1 day' + TIME '10:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '12:15:00', 130.00, 120),
('IndiGo', 'IG214', 'Pune', 'Delhi', CURRENT_DATE + INTERVAL '3 days' + TIME '13:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '15:15:00', 130.00, 130),
('SpiceJet', 'SJ315', 'Mumbai', 'Ahmedabad', CURRENT_DATE + INTERVAL '1 day' + TIME '08:30:00', CURRENT_DATE + INTERVAL '1 day' + TIME '09:45:00', 90.00, 140),
('Vistara', 'UK416', 'Ahmedabad', 'Mumbai', CURRENT_DATE + INTERVAL '2 days' + TIME '17:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '18:15:00', 90.00, 150),
('Air India', 'AI117', 'Delhi', 'Jaipur', CURRENT_DATE + INTERVAL '1 day' + TIME '07:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '08:15:00', 80.00, 100),
('IndiGo', 'IG218', 'Jaipur', 'Delhi', CURRENT_DATE + INTERVAL '2 days' + TIME '20:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '21:15:00', 80.00, 110),
('SpiceJet', 'SJ319', 'Mumbai', 'Goa', CURRENT_DATE + INTERVAL '1 day' + TIME '14:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '15:30:00', 95.00, 120),
('Vistara', 'UK420', 'Goa', 'Mumbai', CURRENT_DATE + INTERVAL '3 days' + TIME '16:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '17:30:00', 95.00, 130),
('Air India', 'AI121', 'Bangalore', 'Kochi', CURRENT_DATE + INTERVAL '1 day' + TIME '09:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '10:15:00', 85.00, 110),
('IndiGo', 'IG222', 'Kochi', 'Bangalore', CURRENT_DATE + INTERVAL '2 days' + TIME '11:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '12:15:00', 85.00, 120),
-- International Routes
('Air India', 'AI505', 'Delhi', 'Dubai', CURRENT_DATE + INTERVAL '1 day' + TIME '09:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '11:30:00', 280.00, 200),
('Emirates', 'EK606', 'Dubai', 'Delhi', CURRENT_DATE + INTERVAL '2 days' + TIME '14:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '19:30:00', 280.00, 220),
('Air India', 'AI507', 'Mumbai', 'Dubai', CURRENT_DATE + INTERVAL '1 day' + TIME '22:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '00:30:00', 320.00, 250),
('Emirates', 'EK608', 'Dubai', 'Mumbai', CURRENT_DATE + INTERVAL '3 days' + TIME '03:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '08:00:00', 320.00, 240),
('Singapore Airlines', 'SQ707', 'Delhi', 'Singapore', CURRENT_DATE + INTERVAL '1 day' + TIME '03:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '10:30:00', 450.00, 220),
('Singapore Airlines', 'SQ708', 'Singapore', 'Delhi', CURRENT_DATE + INTERVAL '3 days' + TIME '23:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '06:30:00', 450.00, 210),
('British Airways', 'BA808', 'Mumbai', 'London', CURRENT_DATE + INTERVAL '1 day' + TIME '15:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '20:30:00', 650.00, 280),
('British Airways', 'BA809', 'London', 'Mumbai', CURRENT_DATE + INTERVAL '2 days' + TIME '21:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '10:30:00', 650.00, 270),
('Air India', 'AI909', 'Delhi', 'New York', CURRENT_DATE + INTERVAL '1 day' + TIME '01:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '08:30:00', 850.00, 300),
('Air India', 'AI910', 'New York', 'Delhi', CURRENT_DATE + INTERVAL '3 days' + TIME '11:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '10:30:00', 850.00, 290),
('Thai Airways', 'TG101', 'Bangalore', 'Bangkok', CURRENT_DATE + INTERVAL '1 day' + TIME '10:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '14:30:00', 380.00, 190),
('Thai Airways', 'TG102', 'Bangkok', 'Bangalore', CURRENT_DATE + INTERVAL '2 days' + TIME '16:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '18:30:00', 380.00, 180),
('Cathay Pacific', 'CX202', 'Mumbai', 'Hong Kong', CURRENT_DATE + INTERVAL '1 day' + TIME '23:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '07:30:00', 520.00, 240),
('Cathay Pacific', 'CX203', 'Hong Kong', 'Mumbai', CURRENT_DATE + INTERVAL '3 days' + TIME '09:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '14:00:00', 520.00, 230),
('Lufthansa', 'LH303', 'Delhi', 'Paris', CURRENT_DATE + INTERVAL '1 day' + TIME '11:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '17:30:00', 720.00, 260),
('Lufthansa', 'LH304', 'Paris', 'Delhi', CURRENT_DATE + INTERVAL '2 days' + TIME '13:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '01:30:00', 720.00, 250),
('Air India', 'AI801', 'Mumbai', 'Tokyo', CURRENT_DATE + INTERVAL '1 day' + TIME '02:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '14:30:00', 780.00, 280),
('Air India', 'AI802', 'Tokyo', 'Mumbai', CURRENT_DATE + INTERVAL '3 days' + TIME '16:00:00', CURRENT_DATE + INTERVAL '4 days' + TIME '00:30:00', 780.00, 270),
('Qantas', 'QF501', 'Delhi', 'Sydney', CURRENT_DATE + INTERVAL '1 day' + TIME '22:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '18:30:00', 950.00, 300),
('Qantas', 'QF502', 'Sydney', 'Delhi', CURRENT_DATE + INTERVAL '3 days' + TIME '08:00:00', CURRENT_DATE + INTERVAL '3 days' + TIME '20:30:00', 950.00, 290),
-- Additional connecting routes
('IndiGo', 'IG301', 'Pune', 'Jaipur', CURRENT_DATE + INTERVAL '1 day' + TIME '10:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '12:30:00', 140.00, 150),
('SpiceJet', 'SJ401', 'Jaipur', 'Pune', CURRENT_DATE + INTERVAL '2 days' + TIME '15:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '17:30:00', 140.00, 140),
('Air India', 'AI201', 'Chennai', 'Mumbai', CURRENT_DATE + INTERVAL '1 day' + TIME '08:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '10:15:00', 130.00, 160),
('IndiGo', 'IG302', 'Mumbai', 'Chennai', CURRENT_DATE + INTERVAL '2 days' + TIME '16:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '18:15:00', 130.00, 170),
('Vistara', 'UK501', 'Kolkata', 'Bangalore', CURRENT_DATE + INTERVAL '1 day' + TIME '07:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '09:30:00', 150.00, 140),
('SpiceJet', 'SJ501', 'Bangalore', 'Kolkata', CURRENT_DATE + INTERVAL '2 days' + TIME '19:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '21:30:00', 150.00, 150),
('Air India', 'AI301', 'Hyderabad', 'Delhi', CURRENT_DATE + INTERVAL '1 day' + TIME '06:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '08:30:00', 140.00, 160),
('IndiGo', 'IG401', 'Delhi', 'Hyderabad', CURRENT_DATE + INTERVAL '2 days' + TIME '17:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '19:30:00', 140.00, 170),
('Vistara', 'UK601', 'Ahmedabad', 'Bangalore', CURRENT_DATE + INTERVAL '1 day' + TIME '09:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '11:15:00', 130.00, 130),
('SpiceJet', 'SJ601', 'Bangalore', 'Ahmedabad', CURRENT_DATE + INTERVAL '2 days' + TIME '14:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '16:15:00', 130.00, 140),
('Air India', 'AI401', 'Goa', 'Delhi', CURRENT_DATE + INTERVAL '1 day' + TIME '11:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '13:30:00', 160.00, 120),
('IndiGo', 'IG501', 'Delhi', 'Goa', CURRENT_DATE + INTERVAL '2 days' + TIME '08:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '10:30:00', 160.00, 130),
('Vistara', 'UK701', 'Kochi', 'Mumbai', CURRENT_DATE + INTERVAL '1 day' + TIME '13:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '15:15:00', 120.00, 110),
('SpiceJet', 'SJ701', 'Mumbai', 'Kochi', CURRENT_DATE + INTERVAL '2 days' + TIME '10:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '12:15:00', 120.00, 120),
('Air India', 'AI501', 'Jaipur', 'Mumbai', CURRENT_DATE + INTERVAL '1 day' + TIME '12:00:00', CURRENT_DATE + INTERVAL '1 day' + TIME '14:15:00', 130.00, 140),
('IndiGo', 'IG601', 'Mumbai', 'Jaipur', CURRENT_DATE + INTERVAL '2 days' + TIME '18:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '20:15:00', 130.00, 150),
('Vistara', 'UK801', 'Pune', 'Bangalore', CURRENT_DATE + INTERVAL '1 day' + TIME '07:30:00', CURRENT_DATE + INTERVAL '1 day' + TIME '08:45:00', 90.00, 120),
('SpiceJet', 'SJ801', 'Bangalore', 'Pune', CURRENT_DATE + INTERVAL '2 days' + TIME '20:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '21:15:00', 90.00, 130),
('Air India', 'AI601', 'Chennai', 'Bangalore', CURRENT_DATE + INTERVAL '1 day' + TIME '09:30:00', CURRENT_DATE + INTERVAL '1 day' + TIME '10:30:00', 80.00, 140),
('IndiGo', 'IG701', 'Bangalore', 'Chennai', CURRENT_DATE + INTERVAL '2 days' + TIME '21:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '22:00:00', 80.00, 150),
('Vistara', 'UK901', 'Kolkata', 'Delhi', CURRENT_DATE + INTERVAL '1 day' + TIME '06:30:00', CURRENT_DATE + INTERVAL '1 day' + TIME '09:00:00', 140.00, 160),
('SpiceJet', 'SJ901', 'Delhi', 'Kolkata', CURRENT_DATE + INTERVAL '2 days' + TIME '19:30:00', CURRENT_DATE + INTERVAL '2 days' + TIME '22:00:00', 140.00, 170),
('Air India', 'AI701', 'Hyderabad', 'Bangalore', CURRENT_DATE + INTERVAL '1 day' + TIME '08:30:00', CURRENT_DATE + INTERVAL '1 day' + TIME '09:30:00', 70.00, 130),
('IndiGo', 'IG801', 'Bangalore', 'Hyderabad', CURRENT_DATE + INTERVAL '2 days' + TIME '22:00:00', CURRENT_DATE + INTERVAL '2 days' + TIME '23:00:00', 70.00, 140);

-- Insert sample hotels
INSERT INTO hotels (name, location, address, star_rating, price_per_night, available_rooms, amenities) VALUES
-- Indian Hotels
('Taj Mahal Palace', 'Mumbai', 'Apollo Bunder, Colaba, Mumbai', 5, 300.00, 50, ARRAY['WiFi', 'Pool', 'Spa', 'Restaurant', 'Gym']),
('The Leela Palace', 'Delhi', 'Diplomatic Enclave, New Delhi', 5, 280.00, 45, ARRAY['WiFi', 'Pool', 'Spa', 'Restaurant', 'Bar']),
('ITC Gardenia', 'Bangalore', 'Residency Road, Bangalore', 5, 220.00, 60, ARRAY['WiFi', 'Pool', 'Gym', 'Restaurant']),
('The Oberoi', 'Goa', 'Calangute Beach, Goa', 5, 350.00, 40, ARRAY['WiFi', 'Beach Access', 'Pool', 'Spa', 'Restaurant']),
('Hyatt Regency', 'Mumbai', 'Sahar Airport Road, Mumbai', 4, 180.00, 70, ARRAY['WiFi', 'Pool', 'Gym', 'Restaurant']),
('Radisson Blu', 'Delhi', 'Mahipalpur, New Delhi', 4, 150.00, 80, ARRAY['WiFi', 'Pool', 'Restaurant', 'Bar']),
('Marriott Hotel', 'Bangalore', 'Whitefield, Bangalore', 4, 160.00, 65, ARRAY['WiFi', 'Pool', 'Gym', 'Restaurant']),
('ITC Grand Chola', 'Chennai', 'Mount Road, Chennai', 5, 250.00, 55, ARRAY['WiFi', 'Pool', 'Spa', 'Restaurant', 'Gym']),
('Taj Falaknuma', 'Hyderabad', 'Falaknuma, Hyderabad', 5, 320.00, 40, ARRAY['WiFi', 'Pool', 'Spa', 'Restaurant', 'Heritage']),
('JW Marriott', 'Pune', 'Senapati Bapat Road, Pune', 5, 200.00, 60, ARRAY['WiFi', 'Pool', 'Gym', 'Restaurant', 'Bar']),
('Taj Lake Palace', 'Jaipur', 'City Palace Road, Jaipur', 5, 280.00, 35, ARRAY['WiFi', 'Pool', 'Restaurant', 'Heritage']),
('Novotel', 'Kolkata', 'Rajarhat, Kolkata', 4, 140.00, 70, ARRAY['WiFi', 'Pool', 'Restaurant', 'Gym']),
('Holiday Inn', 'Ahmedabad', 'SG Highway, Ahmedabad', 4, 130.00, 75, ARRAY['WiFi', 'Pool', 'Restaurant']),
('Ramada', 'Kochi', 'Marine Drive, Kochi', 4, 150.00, 60, ARRAY['WiFi', 'Pool', 'Restaurant', 'Bar']),
-- International Hotels
('Grand Plaza Hotel', 'London', '123 Oxford Street, London', 5, 250.00, 50, ARRAY['WiFi', 'Pool', 'Gym', 'Restaurant']),
('Tokyo Bay Resort', 'Tokyo', '456 Bay Area, Tokyo', 4, 180.00, 75, ARRAY['WiFi', 'Spa', 'Restaurant']),
('Paris Central Inn', 'Paris', '789 Champs-Élysées, Paris', 4, 200.00, 60, ARRAY['WiFi', 'Breakfast', 'Bar']),
('Burj Al Arab', 'Dubai', 'Jumeirah Beach, Dubai', 5, 500.00, 30, ARRAY['WiFi', 'Beach Access', 'Pool', 'Spa', 'Restaurant', 'Butler Service']),
('Marina Bay Sands', 'Singapore', 'Marina Bay, Singapore', 5, 380.00, 55, ARRAY['WiFi', 'Infinity Pool', 'Casino', 'Restaurant', 'Spa']),
('The Plaza', 'New York', 'Fifth Avenue, New York', 5, 450.00, 45, ARRAY['WiFi', 'Spa', 'Restaurant', 'Bar', 'Gym']),
('Shangri-La', 'Hong Kong', 'Kowloon, Hong Kong', 5, 350.00, 50, ARRAY['WiFi', 'Pool', 'Spa', 'Restaurant']),
('Hilton', 'Bangkok', 'Sukhumvit, Bangkok', 4, 160.00, 80, ARRAY['WiFi', 'Pool', 'Restaurant', 'Gym']),
('Sheraton', 'Sydney', 'Darling Harbour, Sydney', 4, 220.00, 65, ARRAY['WiFi', 'Pool', 'Restaurant', 'Bar']),
('Intercontinental', 'Toronto', 'Front Street, Toronto', 4, 200.00, 70, ARRAY['WiFi', 'Pool', 'Restaurant', 'Gym']),
('Marriott', 'Amsterdam', 'Leidseplein, Amsterdam', 4, 180.00, 60, ARRAY['WiFi', 'Restaurant', 'Bar']),
('W Hotel', 'Barcelona', 'Barceloneta Beach, Barcelona', 5, 280.00, 50, ARRAY['WiFi', 'Beach Access', 'Pool', 'Restaurant', 'Bar']),
('Hotel Artemide', 'Rome', 'Via Nazionale, Rome', 4, 170.00, 55, ARRAY['WiFi', 'Restaurant', 'Bar', 'Spa']),
('Hilton', 'Los Angeles', 'Downtown LA, Los Angeles', 4, 190.00, 75, ARRAY['WiFi', 'Pool', 'Gym', 'Restaurant']);
