USE db_cskeers;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS drivers;
-- drivers
create table drivers (
	driver_id INT NOT NULL,
	driver_license INT NOT NULL,
	driver_name VARCHAR(32),
	driver_address VARCHAR(32),
	driver_phone VARCHAR(32),
	PRIMARY KEY(driver_id, driver_license)
);

DROP TABLE IF EXISTS cars;
-- cars
create table cars (
	plate_number VARCHAR(8),
	driver_id INT,
	make VARCHAR(32),
	car_year INT,
	PRIMARY KEY (plate_number, driver_id)
);

DROP TABLE IF EXISTS payment_accounts;
--  payment account
create table payment_accounts (
	bank_account_number INT,
	routing_number INT,
	ssn INT,
	driver_id INT,
	PRIMARY KEY (bank_account_number),
	FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS payments;
-- payments
create table payments (
	payment_id INT,
	payment_date DATE,
	payment_time TIME,
	payment_amount FLOAT,
	payment_tip FLOAT,
	payment_tax FLOAT,
	payment_status CHAR(2),
	PRIMARY KEY (payment_id)
);

DROP TABLE IF EXISTS driver_customer_payments;
-- driver customer payments
create table driver_customer_payments (
	payment_id INT,
	driver_id INT,
	customer_id INT,
	PRIMARY KEY (payment_id),
	FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE,
	FOREIGN KEY (payment_id) REFERENCES payments(payment_id) ON DELETE CASCADE,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS driver_ratings;
--  driver rating
create table driver_ratings (
	driver_id INT,
	rating_date DATE,
	rating_time TIME,
	rate FLOAT,
	rating_comments TEXT,
	PRIMARY KEY (rating_date, rating_time),
	FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS regions;
--  regions
create table regions (
	region_zipcode INT,
	region_state VARCHAR(32),
	region_city VARCHAR(32),
	PRIMARY KEY (region_zipcode, region_state, region_city)
);

DROP TABLE IF EXISTS trips;
--  trips
create table trips (
	trip_id INT,
	trip_date DATE,
	trip_time TIME,
	trip_distance FLOAT,
	pickup_location VARCHAR(128),
	dropoff_location VARCHAR(128),
	payment_id INT,
	PRIMARY KEY (trip_id, trip_date, trip_time)
);

DROP TABLE IF EXISTS driver_customer_trips;
--  driver_customer_trip
create table driver_customer_trips (
	trip_id INT,
	customer_id INT,
	driver_id INT,
	PRIMARY KEY (trip_id),
	FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE,
	FOREIGN KEY (trip_id) REFERENCES trips(trip_id) ON DELETE CASCADE,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS customers;
--  customers
create table customers (
	customer_id INT,
	customer_name VARCHAR(32),
	customer_address VARCHAR(128),
	customer_phone INT,
	PRIMARY KEY (customer_id)
);

DROP TABLE IF EXISTS credit_cards;
--  credit cards
create table credit_cards (
	customer_id INT,
	card_number INT,
	card_expiration VARCHAR(32),
	card_code INT,
	PRIMARY KEY (card_number),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS customer_ratings;
--  customer rating
create table customer_ratings (
	customer_id INT,
	cr_date DATE,
	cr_time TIME,
	cr_rate FLOAT,
	cr_description TEXT,
	PRIMARY KEY (customer_id, cr_date, cr_time)
);

DROP TABLE IF EXISTS accidents;
--  accidents
create table accidents (
	accident_id INT,
	accident_date DATE,
	accident_time TIME,
	accident_description TEXT,
	PRIMARY KEY (accident_id, accident_date, accident_time)
);

DROP TABLE IF EXISTS reports;
--  report
create table reports (
	report_id INT,
	trip_id INT,
	report_date DATE,
	report_time TIME,
	report_description TEXT,
	PRIMARY KEY (report_id)
);



-- next, add some simple sample data
INSERT INTO reports (report_id, trip_id, report_date, report_time, report_description) VALUES
(783, 440, '2019-09-21', '13:43:41', "Something happened"),
(784, 441, '2019-09-22', '13:43:42', "Something else happened");

INSERT INTO accidents (accident_id, accident_date, accident_time, accident_description) VALUES
(253, '2019-09-01', '06:43:41', "Something accidentally happened"),
(254, '2019-09-02', '07:43:41', "Something else accidentally happened");

INSERT INTO customer_ratings (customer_id, cr_date, cr_time, cr_rate, cr_description) VALUES
(345, '2019-10-02', '07:45:41', 4.5, "twas good"),
(346, '2019-11-02', '07:45:41', 1.2, "twas bad");

INSERT INTO credit_cards (customer_id, card_number, card_expiration, card_code) VALUES
(345, 876458720, "9/21", 540),(346, 382750947, "3/34", 984);

INSERT INTO customers (customer_id, customer_name, customer_address, customer_phone) VALUES
(345, "Mickey Mouse", "1283 N Disney Lane", 74365208),
(346, "Minnie Mouse", "829 S Disney Lane", 98423750);

INSERT INTO driver_customer_trips (trip_id, customer_id, driver_id) VALUES
(440,345,1234567),(441,346,1234568);

INSERT INTO trips (trip_id, trip_date, trip_time, trip_distance, pickup_location, dropoff_location, payment_id) VALUES
(839, '2019-11-02', '07:45:41', 93.2, "address here","other address here", 120),
(840, '2019-12-02', '07:49:41', 93.2, "address 3 here","other other address here", 121);

INSERT INTO regions (region_zipcode, region_state, region_city) VALUES
(23989, "ia", "iowa city"),(23875, "wi", "madison");

INSERT INTO driver_ratings (driver_id, rating_date, rating_time, rate, rating_comments) VALUES
(930, '2019-11-02', '07:45:41', 3, "twas ok"),
(931, '2019-11-03', '07:45:49', 3.5, "twas fine");

INSERT INTO driver_customer_payments (payment_id, driver_id, customer_id) VALUES
(293, 1234567, 345),(843, 888, 346), (333, 1234568 ,345);

-- drivers
INSERT INTO drivers (driver_id, driver_license, driver_name, driver_address, driver_phone)
VALUES (1234567, 123, 'Spider Man', '1234 Superhero Lane', '123-321-1234');

INSERT INTO drivers (driver_id, driver_license, driver_name, driver_address, driver_phone)
VALUES (1234568, 234, 'Ant Man', '1235 Superhero Lane', '123-123-1234');

INSERT INTO drivers (driver_id, driver_license, driver_name, driver_address, driver_phone)
VALUES (1234569, 345, 'Bird Man', '1244 Superhero Lane', '123-321-8888');

-- cars
INSERT INTO cars (plate_number, driver_id, make, car_year )
VALUES ('1234567', 1234567, 'Batcar', 2015);

INSERT INTO cars (plate_number, driver_id, make, car_year )
VALUES ('7654321', 1234568, 'Batcar', 2017);

INSERT INTO cars (plate_number, driver_id, make, car_year )
VALUES ('0000000', 1234569, 'Batcar', 2001);


-- payment_account
INSERT INTO payment_accounts (bank_account_number, routing_number, ssn, driver_id)
VALUES (1, 101, 591034, 1234567);

INSERT INTO payment_accounts (bank_account_number, routing_number, ssn, driver_id)
VALUES (2, 101, 427111, 1234568);

INSERT INTO payment_accounts (bank_account_number, routing_number, ssn, driver_id)
VALUES (3, 101, 814111, 1234569);

-- payments
INSERT INTO payments (payment_id, payment_date, payment_time, payment_amount, payment_tip, payment_tax, payment_status)
VALUES (293, '2008-11-11', '09:30:00', 5.03, 1.25, 0.75, 1);

INSERT INTO payments (payment_id, payment_date, payment_time, payment_amount, payment_tip, payment_tax, payment_status)
VALUES (843, '2019-11-11', '13:30:00', 15, 4.25, 0.85, 1);

INSERT INTO payments (payment_id, payment_date, payment_time, payment_amount, payment_tip, payment_tax, payment_status)
VALUES (333, '2019-04-04', '13:30:00', 40.80, 8.20, 4.25, 2);

SET FOREIGN_KEY_CHECKS = 1;
