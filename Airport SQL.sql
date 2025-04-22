-- ----------------------------
-- SOUTH AFRICAN AIRPORT SCHEMA (MySQL)
-- ----------------------------

-- 1. AIRPORTS
CREATE TABLE airports (
    airport_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    iata_code CHAR(3),
    icao_code CHAR(4),
    city VARCHAR(50),
    province VARCHAR(50),
    country VARCHAR(50) DEFAULT 'South Africa'
);

-- 2. TERMINALS
CREATE TABLE terminals (
    terminal_id INT AUTO_INCREMENT PRIMARY KEY,
    airport_id INT FOREIGN KEY (airport_id) REFERENCES airports(airport_id),
    terminal_name VARCHAR(50),
    gates INT,
);

-- 3. AIRLINES
CREATE TABLE airlines (
    airline_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    iata_code CHAR(2),
    country_of_origin VARCHAR(50)
);

-- 4. FLIGHTS
CREATE TABLE flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    airline_id INT,
    departure_airport_id INT,
    arrival_airport_id INT,
    terminal_id INT,
    flight_number VARCHAR(10),
    departure_time DATETIME,
    arrival_time DATETIME,
    status VARCHAR(30),
    FOREIGN KEY (airline_id) REFERENCES airlines(airline_id),
    FOREIGN KEY (departure_airport_id) REFERENCES airports(airport_id),
    FOREIGN KEY (arrival_airport_id) REFERENCES airports(airport_id),
    FOREIGN KEY (terminal_id) REFERENCES terminals(terminal_id)
);

-- 5. PASSENGERS
CREATE TABLE passengers (
    passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    passport_number VARCHAR(20),
    nationality VARCHAR(50),
    date_of_birth DATE,
    contact_number VARCHAR(20),
    email VARCHAR(100)
);

-- 6. TICKETS
CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_id INT,
    passenger_id INT,
    seat_number VARCHAR(10),
    ticket_class ENUM('Economy', 'Business', 'First'),
    price DECIMAL(10, 2),
    currency CHAR(3),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id)
);

-- 7. BAGGAGE
CREATE TABLE baggage (
    baggage_id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT,
    weight_kg DECIMAL(5,2),
    is_oversized BOOLEAN,
    status ENUM('Checked In', 'Loaded', 'Missing', 'Delivered'),
    FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id)
);

-- 8. CUSTOMS CLEARANCE
CREATE TABLE customs_clearance (
    clearance_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    cleared BOOLEAN,
    remarks TEXT,
    inspection_time DATETIME,
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

-- 9. STAFF
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    airport_id INT,
    full_name VARCHAR(100),
    role VARCHAR(50),
    department VARCHAR(50),
    contact_number VARCHAR(20),
    email VARCHAR(100),
    shift_time VARCHAR(50),
    FOREIGN KEY (airport_id) REFERENCES airports(airport_id)
);

-- 10. FLIGHT ASSIGNMENTS
CREATE TABLE flight_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_id INT,
    staff_id INT,
    role_on_flight VARCHAR(50),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- ----------------------------
-- SAMPLE INSERTS (Airports, Airlines, Passengers)
-- ----------------------------
INSERT INTO airports (name, iata_code, icao_code, city, province) VALUES
('OR Tambo International Airport', 'JNB', 'FAOR', 'Johannesburg', 'Gauteng'),
('Cape Town International Airport', 'CPT', 'FACT', 'Cape Town', 'Western Cape'),
('King Shaka International Airport', 'DUR', 'FALE', 'Durban', 'KwaZulu-Natal');

INSERT INTO airlines (name, iata_code, country_of_origin) VALUES
('South African Airways', 'SA', 'South Africa'),
('FlySafair', 'FA', 'South Africa'),
('Airlink', '4Z', 'South Africa');

INSERT INTO passengers (first_name, last_name, passport_number, nationality, date_of_birth, contact_number, email) VALUES
('Thabo', 'Mokoena', 'ZA123456', 'South African', '1988-06-15', '+27123456789', 'thabo.mokoena@example.com'),
('Anele', 'Ngcobo', 'ZA987654', 'South African', '1993-04-10', '+27821234567', 'anele.ngcobo@example.com');

-- ----------------------------
-- EXAMPLE QUERIES
-- ----------------------------
-- Get all flights between JNB and CPT
SELECT f.flight_number, a1.name AS departure, a2.name AS arrival, f.departure_time, f.arrival_time
FROM flights f
JOIN airports a1 ON f.departure_airport_id = a1.airport_id
JOIN airports a2 ON f.arrival_airport_id = a2.airport_id
WHERE a1.iata_code = 'JNB' AND a2.iata_code = 'CPT';

-- Count how many flights each airline operates
SELECT al.name, COUNT(*) AS total_flights
FROM flights f
JOIN airlines al ON f.airline_id = al.airline_id
GROUP BY al.name;

-- Total baggage weight for a flight
SELECT f.flight_number, SUM(b.weight_kg) AS total_weight
FROM baggage b
JOIN tickets t ON b.ticket_id = t.ticket_id
JOIN flights f ON t.flight_id = f.flight_id
GROUP BY f.flight_number;

-- Customs clearance status of all passengers on a flight
SELECT p.first_name, p.last_name, cc.cleared, cc.inspection_time
FROM customs_clearance cc
JOIN passengers p ON cc.passenger_id = p.passenger_id
WHERE cc.flight_id = 1;