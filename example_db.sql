USE db_cskeers;

-- Need to turn off foreign key checks, or change the order or table drops/creations.
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS drivers;
-- table for storing uber drivers
CREATE TABLE drivers (
	driver_id INT NOT NULL,
	driver_license VARCHAR(12), -- state license numbers are 12 characters or fewer, and may contain both alpha and numeric chars
	driver_fname VARCHAR(50),
	driver_lname VARCHAR(50),
	driver_address VARCHAR(50),
	driver_phone VARCHAR(10), -- no hyphens; 10 digit phone number w/area code
	-- driver_photo VARBINARY, -- recommended for images below 256kb
	PRIMARY KEY (driver_id)
);

DROP TABLE IF EXISTS cars;
-- table for storing uber drivers' cars
CREATE TABLE cars (
	car_plate VARCHAR(12) NOT NULL, -- covers various state requirements, as well as both alphanumeric possibilities
	driver_id INT,
	car_make VARCHAR(12),
	car_model VARCHAR(12),
	car_year INT,
	PRIMARY KEY (car_plate),
	FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS payment_accounts;
-- table for storing uber drivers' payment account info
CREATE TABLE payment_accounts (
	bank_account_number VARCHAR(32), -- may start with 0; leave room for different bank standards
	bank_routing_number VARCHAR(9), -- no hyphens; may start with 0
	driver_ssn VARCHAR(9), -- no hyphens; may start with 0
	driver_id INT,
	PRIMARY KEY (bank_account_number),
	FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS payments;
-- table for storing payment delivery/processing info
CREATE TABLE payments (
	payment_id INT NOT NULL,
	time DATETIME,
	payment_amount DECIMAL,
	payment_tip DECIMAL,
	payment_status ENUM ('PENDING', 'PROCESSED', 'ERROR'),
	PRIMARY KEY (payment_id)
);

DROP TABLE IF EXISTS driver_customer_payments;
-- table for storing which customer/driver were involved in a payment
CREATE TABLE driver_customer_payments (
	payment_id INT,
	driver_id INT,
	customer_id INT,
	FOREIGN KEY (payment_id) REFERENCES payments(payment_id),
	FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

DROP TABLE IF EXISTS driver_ratings;
-- table for storing driver ratings info
CREATE TABLE driver_ratings (
	driver_id INT,
	time DATETIME,
	driver_rate DECIMAL,
	driver_comments TEXT,
	PRIMARY KEY (time),
	FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);

DROP TABLE IF EXISTS regions;
-- table for storing region information
CREATE TABLE regions (
	zipcode VARCHAR(5) NOT NULL,
	state VARCHAR(2),
	city VARCHAR(32),
	PRIMARY KEY (zipcode)
);

DROP TABLE IF EXISTS trips;
-- table for holding trip information
CREATE TABLE trips (
	trip_id INT NOT NULL,
	time DATETIME,
	trip_distance DECIMAL,
	pickup_location_lat DECIMAL, -- store locations as lat/long; app-connected with GPS
	pickup_location_long DECIMAL,
	dropoff_location_lat DECIMAL,
	dropoff_location_long DECIMAL,
	trip_price DECIMAL,
	PRIMARY KEY (trip_id)
);

DROP TABLE IF EXISTS driver_customer_trips;
-- table for holding info on which drivers/customers involved in which trips
CREATE TABLE driver_customer_trips (
	trip_id INT,
	customer_id INT,
	driver_id INT,
	FOREIGN KEY (trip_id) REFERENCES trips(trip_id),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
);

DROP TABLE IF EXISTS customers;
-- table for holding info about customers
CREATE TABLE customers (
	customer_id INT NOT NULL,
	customer_fname VARCHAR(50),
	customer_lname VARCHAR(50),
	customer_address VARCHAR(50),
	customer_phone VARCHAR(10),
	-- customer_photo VARBINARY,
	PRIMARY KEY (customer_id)
);

DROP TABLE IF EXISTS credit_cards;
-- table for holding customer payment (credit card) information
CREATE TABLE credit_cards (
	customer_id INT,
	card_number VARCHAR(12), -- 12digit card numbers; leading 0s allowed
	card_expiration VARCHAR(5), -- mm/yy format
	card_ccv VARCHAR(3), -- 3digit ccv, leading 0s allowed
	PRIMARY KEY (card_number),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS customer_ratings;
-- table for holding customer rating information
CREATE TABLE customer_ratings (
	customer_id INT,
	time DATETIME,
	customer_rate DECIMAL,
	customer_comments TEXT,
	PRIMARY KEY (time),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS accidents;
-- table for holding information regarding any accidents
CREATE TABLE accidents (
	accident_id INT NOT NULL,
	time DATETIME,
	accident_description TEXT,
	PRIMARY KEY (accident_id)
);

DROP TABLE IF EXISTS reports;
-- table for holding additional trip/report information
CREATE TABLE reports (
	report_id INT NOT NULL,
	trip_id INT,
	time DATETIME,
	report_description TEXT,
	PRIMARY KEY (report_id),
	FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
);

-- Turn foreign key checks back on after tables have been created.
SET FOREIGN_KEY_CHECKS = 1;
-- and add some simple data down here
