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
	-- PRIMARY KEY (bank_account_number), What if two drivers share the same account?
	FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS payments;
-- table for storing payment delivery/processing info
CREATE TABLE payments (
	payment_id INT NOT NULL,
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
	payment_id INT NOT NULL,
	PRIMARY KEY (trip_id),
	FOREIGN KEY (payment_id) REFERENCES payments(payment_id)
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
	report_description TEXT,
	PRIMARY KEY (report_id),
	FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
);

-- Turn foreign key checks back on after tables have been created.
SET FOREIGN_KEY_CHECKS = 1;
-- and add some simple data down here

INSERT INTO drivers (driver_id,driver_license,driver_fname,driver_lname,driver_address,driver_phone)
	VALUES 
		(123,'1C1125','Mickey','Mouse','123 Mouseketeer Lane','3195555555'),
		(245,'1C2500','Minnie','Mouse','123 Mouseketeer Lane','3195555556'),
		(522,'09B222','Spider','Man','2001 Space St Apt 42','5156294658');

INSERT INTO cars (car_plate,driver_id,car_make,car_model,car_year)
	VALUES
		('123ILUV',123,'Ford','Escape',2016),
		('123MIC',123,'Ford','Tempo',1989),
		('MINNIEME',245,'Kia','Optima',2018),
		('SPIDEY',522,'Chevrolet','Cobalt',2006);

INSERT INTO payment_accounts (bank_account_number,bank_routing_number,driver_ssn,driver_id)
	VALUES
		('0123456789','000777555','555667777',123),
		('0123456789','000777555','555667778',245),
		('9876543210','555777000','065778888',522);

INSERT INTO payments (payment_id,payment_amount,payment_tip,payment_status)
	VALUES
		(1111,15.62,5.00,'PROCESSED'),
		(2222,12.50,0.00,'PENDING'),
		(3333,62.00,50.00,'ERROR'),
		(4444,22.00,2.00,'PROCESSED');

-- Don't need this table if we can tie both customer and driver to a trip, and payment to that trip
INSERT INTO driver_customer_payments (payment_id,driver_id,customer_id)
	VALUES
		(1111,123,321),
		(2222,123,654),
		(3333,245,654),
		(4444,522,321);
		
INSERT INTO driver_ratings (driver_id,time,driver_rate,driver_comments)
	VALUES
		(123,'12/08/2019',3.0,'Mickey was a great driver, but a little flirtatious for my tastes.'),
		(245,'11/02/2019',5.0,'Fantastic service. Super long drive, great conversation to kill the time.'),
		(522,'11/13/2019',2.0,'Weird guy. Creepy mask.');

INSERT INTO regions (zipcode,state,city)
	VALUES
		('52246','IA','Iowa City'),
		('52403','IA','Cedar Rapids');

INSERT INTO trips (trip_id,trip_distance,pickup_location_lat,pickup_location_long,dropoff_location_lat,dropoff_location_long,trip_price)
	VALUES
		(1122,'12/08/2019',5.2,32.411,-32.411,33.411,-32.411,1111),
		(1133,'12/09/2019',2.0,32.1,-32.1,33.1,-32.1,2222),
		(1144,'11/02/2019',20.0,35.1,-32.111,30.2,-33.1,3333),
		(1155,'11/13/2019',4.0,32.1,-32.1,34.1,-32.1,4444);

INSERT INTO driver_customer_trips (trip_id,customer_id,driver_id)
	VALUES
		(1122,321,123),
		(1133,654,123),
		(1144,654,245),
		(1155,321,522);

INSERT INTO customers (customer_id,customer_fname,customer_lname,customer_address,customer_phone)
	VALUES
		(321,'Bob','Roarman','12 14th Avenue','1112223333'),
		(654,'Jane','Doe','13 D Ave','9998887777');

INSERT INTO credit_cards (customer_id,card_number,card_expiration,card_ccv)
	VALUES
		(321,'123456789012','03/23','000'),
		(654,'210987654321','02/22','982');

INSERT INTO customer_ratings (customer_id,time,customer_rate,customer_comments)
	VALUES
		(321,'12/08/2019',2.0,'Spilled something all over my backseat.'),
		(654,'12/09/2019',5.0,'Great conversation.'),
		(321,'11/13/2019',5.0,'Fun ride. Considerate passenger.');

INSERT INTO accidents (accident_id,time,accident_description)
	VALUES
		(123456,'12/08/2019','Fender bender while pulling out of a parking lot. Drivers exchanged contact info. No injuries, no significant damage to either vehicle.'),
		(654321,'11/13/2019','Driver ran a red light, turned into oncoming traffic wrong way on a one way. No collision, no injury. Three police citations.');

INSERT INTO reports (report_id,trip_id,report_description)
	VALUES
		(11,1122,'Customer complaint that the driver was verbally inappropriate.'),
		(22,1155,'Customer requested to "never ride with that weirdo again." No specifics provided.');
