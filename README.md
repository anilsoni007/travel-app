# Travel Booking System

A full-stack travel booking application with flight and hotel booking capabilities.

## Architecture

- **Frontend**: React application with routing and API integration
- **Backend**: Node.js/Express REST API with JWT authentication
- **Database**: PostgreSQL with relational schema

## Features

- User registration and authentication
- Flight search and booking
- Hotel search and booking
- Payment processing (dummy)
- Booking management and history
- Responsive UI

## Quick Start with Docker Compose

1. Start all services:
```bash
docker-compose up --build
```

2. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5000
   - Database: localhost:5432

3. Stop services:
```bash
docker-compose down
```

## Manual Setup

### Backend Setup
```bash
cd backend
npm install
npm start
```

### Frontend Setup
```bash
cd frontend
npm install
npm start
```

### Database Setup
Create PostgreSQL database and run init.sql script from database folder.

## API Endpoints

- POST /api/auth/register - Register new user
- POST /api/auth/login - Login user
- GET /api/flights/search - Search flights
- GET /api/hotels/search - Search hotels
- POST /api/bookings - Create booking
- GET /api/bookings - Get user bookings
- POST /api/payments - Process payment

## Default Credentials

Register a new account or use the application to create users.

## Sample Data

The database is pre-populated with sample flights and hotels for testing.
