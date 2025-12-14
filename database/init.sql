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

-- Insert sample flights
INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats) VALUES
('Air India', 'AI101', 'Mumbai', 'Delhi', '2024-03-15 08:00:00', '2024-03-15 10:30:00', 120.00, 150),
('IndiGo', 'IG202', 'Delhi', 'Bangalore', '2024-03-15 11:00:00', '2024-03-15 13:45:00', 150.00, 180),
('SpiceJet', 'SJ303', 'Bangalore', 'Mumbai', '2024-03-16 06:30:00', '2024-03-16 08:15:00', 110.00, 160),
('Vistara', 'UK404', 'Mumbai', 'Goa', '2024-03-16 14:00:00', '2024-03-16 15:30:00', 95.00, 120),
('Air India', 'AI505', 'Delhi', 'Dubai', '2024-03-17 09:00:00', '2024-03-17 11:30:00', 280.00, 200),
('Emirates', 'EK606', 'Mumbai', 'Dubai', '2024-03-17 22:00:00', '2024-03-18 00:30:00', 320.00, 250),
('Singapore Airlines', 'SQ707', 'Delhi', 'Singapore', '2024-03-18 03:00:00', '2024-03-18 10:30:00', 450.00, 220),
('British Airways', 'BA808', 'Mumbai', 'London', '2024-03-18 15:00:00', '2024-03-18 20:30:00', 650.00, 280),
('Air India', 'AI909', 'Delhi', 'New York', '2024-03-19 01:00:00', '2024-03-19 08:30:00', 850.00, 300),
('Thai Airways', 'TG101', 'Bangalore', 'Bangkok', '2024-03-19 10:00:00', '2024-03-19 14:30:00', 380.00, 190),
('Cathay Pacific', 'CX202', 'Mumbai', 'Hong Kong', '2024-03-20 23:00:00', '2024-03-21 07:30:00', 520.00, 240),
('Lufthansa', 'LH303', 'Delhi', 'Paris', '2024-03-20 11:00:00', '2024-03-20 17:30:00', 720.00, 260);

-- Insert sample hotels
INSERT INTO hotels (name, location, address, star_rating, price_per_night, available_rooms, amenities) VALUES
('Taj Mahal Palace', 'Mumbai', 'Apollo Bunder, Colaba, Mumbai', 5, 300.00, 50, ARRAY['WiFi', 'Pool', 'Spa', 'Restaurant', 'Gym']),
('The Leela Palace', 'Delhi', 'Diplomatic Enclave, New Delhi', 5, 280.00, 45, ARRAY['WiFi', 'Pool', 'Spa', 'Restaurant', 'Bar']),
('ITC Gardenia', 'Bangalore', 'Residency Road, Bangalore', 5, 220.00, 60, ARRAY['WiFi', 'Pool', 'Gym', 'Restaurant']),
('The Oberoi', 'Goa', 'Calangute Beach, Goa', 5, 350.00, 40, ARRAY['WiFi', 'Beach Access', 'Pool', 'Spa', 'Restaurant']),
('Hyatt Regency', 'Mumbai', 'Sahar Airport Road, Mumbai', 4, 180.00, 70, ARRAY['WiFi', 'Pool', 'Gym', 'Restaurant']),
('Radisson Blu', 'Delhi', 'Mahipalpur, New Delhi', 4, 150.00, 80, ARRAY['WiFi', 'Pool', 'Restaurant', 'Bar']),
('Marriott Hotel', 'Bangalore', 'Whitefield, Bangalore', 4, 160.00, 65, ARRAY['WiFi', 'Pool', 'Gym', 'Restaurant']),
('Grand Plaza Hotel', 'London', '123 Oxford Street, London', 5, 250.00, 50, ARRAY['WiFi', 'Pool', 'Gym', 'Restaurant']),
('Tokyo Bay Resort', 'Tokyo', '456 Bay Area, Tokyo', 4, 180.00, 75, ARRAY['WiFi', 'Spa', 'Restaurant']),
('Paris Central Inn', 'Paris', '789 Champs-Élysées, Paris', 4, 200.00, 60, ARRAY['WiFi', 'Breakfast', 'Bar']),
('Burj Al Arab', 'Dubai', 'Jumeirah Beach, Dubai', 5, 500.00, 30, ARRAY['WiFi', 'Beach Access', 'Pool', 'Spa', 'Restaurant', 'Butler Service']),
('Marina Bay Sands', 'Singapore', 'Marina Bay, Singapore', 5, 380.00, 55, ARRAY['WiFi', 'Infinity Pool', 'Casino', 'Restaurant', 'Spa']);
