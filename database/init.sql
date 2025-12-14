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

-- Insert sample flights
INSERT INTO flights (airline, flight_number, origin, destination, departure_time, arrival_time, price, available_seats) VALUES
('Air Travel', 'AT101', 'New York', 'London', '2024-03-15 08:00:00', '2024-03-15 20:00:00', 599.99, 150),
('Sky Airlines', 'SK202', 'Los Angeles', 'Tokyo', '2024-03-16 10:30:00', '2024-03-17 14:30:00', 899.99, 200),
('Global Air', 'GA303', 'Chicago', 'Paris', '2024-03-17 14:00:00', '2024-03-18 04:00:00', 749.99, 180);

-- Insert sample hotels
INSERT INTO hotels (name, location, address, star_rating, price_per_night, available_rooms, amenities) VALUES
('Grand Plaza Hotel', 'London', '123 Oxford Street, London', 5, 250.00, 50, ARRAY['WiFi', 'Pool', 'Gym', 'Restaurant']),
('Tokyo Bay Resort', 'Tokyo', '456 Bay Area, Tokyo', 4, 180.00, 75, ARRAY['WiFi', 'Spa', 'Restaurant']),
('Paris Central Inn', 'Paris', '789 Champs-Élysées, Paris', 4, 200.00, 60, ARRAY['WiFi', 'Breakfast', 'Bar']);
