Simulated South African Airport Database (MySQL)

This project simulates a modern South African airport database system using MySQL. It includes realistic entities like Airports, Flights, Passengers, Airlines, Baggage, Customs, and Staff Assignments.

📦 ER Diagram
I will add the ERD very soon

📂 Features
- Multi-airport, multi-terminal architecture
- Full flight and passenger management
- Airline and staff assignment tracking
- Baggage and customs clearance monitoring
- Sample queries for analytics

🛠 Technologies
- MySQL 8+
- SQL (DDL & DML)
- ERD tool: Lucidcharts/ Microsoft word

🧪 Sample Queries
```sql
-- All flights from Johannesburg to Cape Town
SELECT f.flight_number, a1.name AS departure, a2.name AS arrival, f.departure_time, f.arrival_time
FROM flights f
JOIN airports a1 ON f.departure_airport_id = a1.airport_id
JOIN airports a2 ON f.arrival_airport_id = a2.airport_id
WHERE a1.iata_code = 'JNB' AND a2.iata_code = 'CPT';

-- Total baggage weight per flight
SELECT f.flight_number, SUM(b.weight_kg) AS total_weight
FROM baggage b
JOIN tickets t ON b.ticket_id = t.ticket_id
JOIN flights f ON t.flight_id = f.flight_id
GROUP BY f.flight_number;
