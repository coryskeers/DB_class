USE db_cskeers;

DROP TABLE IF EXISTS drivers;
-- table for storing uber drivers
CREATE TABLE drivers (
	driver_id INT NOT NULL,
	driver_license VARCHAR(32),
	driver_name VARCHAR(100),
	driver_address VARCHAR(50),
	driver_phone VARCAR(10),
	driver_photo
	PRIMARY KEY (driver_id)
);

DROP TABLE IF EXISTS cars;
-- table for storing uber drivers' cars
CREATE TABLE cars (
	car_plate VARCHAR(12)
	driver_id INT,
	car_make
	car_model			**********
	car_year
	PRIMARY KEY (car_plate),
	FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS payment_accounts;
-- table for storing uber drivers' payment account info
CREATE TABLE payment_accounts (
	bank_account_number INT NOT NULL,
	bank_routing_number VARCHAR(9),
	driver_ssn VARCHAR(9),
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
	payment_status ENUM
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
)

DROP TABLE IF EXISTS driver_ratings;
-- table for storing driver ratings info
CREATE TABLE driver_ratings (
	driver_id INT,
	time DATETIME,
	driver_rate FLOAT,
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
	date DATETIME,
	trip_distance FLOAT,
	pickup_location VARCHAR(32),
	dropoff_location VARCHAR(32),
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
	customer_name VARCHAR(100),
	customer_address VARCHAR(50),
	customer_phone VARCHAR(10),
	customer_photo
	PRIMARY KEY (customer_id)
);

DROP TABLE IF EXISTS credit_cards;
-- table for holding customer payment (credit card) information
CREATE TABLE credit_cards (
	customer_id INT,
	card_number VARCHAR(12),
	card_expiration VARCHAR(5),
	card_ccv VARCHAR(3),
	PRIMARY KEY (card_number),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS customer_ratings;
-- table for holding customer rating information
CREATE TABLE customer_ratings (
	customer_id INT,
	time DATETIME,
	customer_rate FLOAT,
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


-- and add some simple data down here