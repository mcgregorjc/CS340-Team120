-- #############################
-- Reset
-- #############################
DROP PROCEDURE IF EXISTS sp_ResetDatabase;



CREATE PROCEDURE sp_ResetDatabase
Drop TABLE IF EXISTS Constellations;
Drop TABLE IF EXISTS Stars;
Drop TABLE IF EXISTS Shows;
Drop TABLE IF EXISTS Customers;
Drop TABLE IF EXISTS Show_Stars;
Drop TABLE IF EXISTS Show_Constellations;
Drop TABLE IF EXISTS Show_Customers;



--
-- Entity tables: Constellations, Stars, Shows, Customers
--
CREATE OR REPLACE TABLE Constellations (
    constellation_id int AUTO_INCREMENT,
    name CHAR(100) NOT NULL,
    northern_hemisphere BIT,
    PRIMARY KEY (constellation_id)
);

-- temperature in kelvin, radius in solar radius, spectral class in O-B-A-F-G-K-M (hot to cold)
CREATE OR REPLACE TABLE Stars (
    star_id int AUTO_INCREMENT,
    constellation_id int NULL,
    proper_name VARCHAR(50) NULL,
    temperature DECIMAL(10, 0) NOT NULL,
    radius DECIMAL(20, 0) NULL,
    color CHAR(50) NULL,
    spectral_class CHAR(1) NOT NULL,
    PRIMARY KEY (star_id),
    FOREIGN KEY (constellation_id) REFERENCES Constellations(constellation_id)
);

-- Date in "year-month-day hour:minute:second" format
CREATE OR REPLACE TABLE Shows (
    show_id int AUTO_INCREMENT,
    title VARCHAR(500) NULL,
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (show_id)
);

CREATE OR REPLACE TABLE Customers (
    customer_id int AUTO_INCREMENT,
    name VARCHAR(500) NOT NULL,
    phone_number VARCHAR(15) NULL,
    email VARCHAR(500) NOT NULL,
    PRIMARY KEY (customer_id)
);

--
-- Intersection tables: Show_Stars, Show_Constellations, Show_Customers
--
CREATE OR REPLACE TABLE Show_Stars (
    star_id int NOT NULL,
    show_id int NOT NULL,
    FOREIGN KEY (star_id) REFERENCES Stars(star_id),
    FOREIGN KEY (show_id) REFERENCES Shows(show_id)
);

CREATE OR REPLACE TABLE Show_Constellations (
    constellation_id int NOT NULL,
    show_id int NOT NULL,
    FOREIGN KEY (constellation_id) REFERENCES Constellations(constellation_id),
    FOREIGN KEY (show_id) REFERENCES Shows(show_id)
);

CREATE OR REPLACE TABLE Show_Customers (
    customer_id int NOT NULL,
    show_id int NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (show_id) REFERENCES Shows(show_id)
);

--
-- Sample Data
--

-- Constellations Source: https://www.go-astronomy.com/constellations.htm
INSERT INTO Constellations (name, northern_hemisphere) VALUES
("Andromeda", 1),
("Antlia", 0),
("Apus", 0),
("Aquarius", 0),
("Aquila", 1),
("Ara", 0),
("Aries", 1),
("Auriga", 1),
("Boötes", 1),
("Caelum", 0),
("Ursa Major", 1),
("Ursa Minor", 1);


INSERT INTO Stars (constellation_id, proper_name, temperature, radius, color, spectral_class) VALUES
((SELECT constellation_id FROM Constellations WHERE name = "Ursa Major"), "Dubhe", 4650, 26.85, "Orange", "K"),
((SELECT constellation_id FROM Constellations WHERE name = "Ursa Major"), "Merak", 9700, 2.81, "Blue-White", "A"),
((SELECT constellation_id FROM Constellations WHERE name = "Ursa Major"), "Phecda", 6751, 3.38, "White", "A"),
((SELECT constellation_id FROM Constellations WHERE name = "Ursa Major"), "Megrez", 6909, 2.51, "White", "A"),
(NULL, "Sun", 5772, 1, "White", "G");

INSERT INTO Shows (title, date) VALUES
("The Big Dipper", "2025-07-13 20:00:00"),
("Astrology Night", "2025-08-13 20:00:00"),
("Venture into the Cosmos", NULL);

INSERT INTO Customers (name, phone_number, email) VALUES
("Henry Thistle", "8080298251", "Thistle@gmail.com"),
("Sad Happy", NULL, "Confused@outlook.com"),
("Wanda Cosmo", "5412345667", "FortniteGamer@yahoo.com");

INSERT INTO Show_Stars (show_id, star_id) VALUES
((SELECT show_id FROM Shows WHERE title = "The Big Dipper"), (SELECT star_id FROM Stars WHERE proper_name = "Dubhe")),
((SELECT show_id FROM Shows WHERE title = "The Big Dipper"), (SELECT star_id FROM Stars WHERE proper_name = "Merak")),
((SELECT show_id FROM Shows WHERE title = "The Big Dipper"), (SELECT star_id FROM Stars WHERE proper_name = "Phecda")),
((SELECT show_id FROM Shows WHERE title = "The Big Dipper"), (SELECT star_id FROM Stars WHERE proper_name = "Megrez")),
((SELECT show_id FROM Shows WHERE title = "Venture into the Cosmos"), (SELECT star_id FROM Stars WHERE proper_name = "Megrez"));

INSERT INTO Show_Constellations (show_id, constellation_id) VALUES
((SELECT show_id FROM Shows WHERE title = "The Big Dipper"), (SELECT constellation_id FROM Constellations WHERE name = "Andromeda")),
((SELECT show_id FROM Shows WHERE title = "Astrology Night"), (SELECT constellation_id FROM Constellations WHERE name = "Aquarius")),
((SELECT show_id FROM Shows WHERE title = "Astrology Night"), (SELECT constellation_id FROM Constellations WHERE name = "Aries"));

INSERT INTO Show_Customers (show_id, customer_id) VALUES
((SELECT show_id FROM Shows WHERE title = "The Big Dipper"), (SELECT customer_id FROM Customers WHERE name = "Henry Thistle")),
((SELECT show_id FROM Shows WHERE title = "Astrology Night"), (SELECT customer_id FROM Customers WHERE name = "Sad Happy")),
((SELECT show_id FROM Shows WHERE title = "Astrology Night"), (SELECT customer_id FROM Customers WHERE name = "Wanda Cosmo")),
((SELECT show_id FROM Shows WHERE title = "Venture into the Cosmos"), (SELECT customer_id FROM Customers WHERE name = "Henry Thistle")),
((SELECT show_id FROM Shows WHERE title = "Venture into the Cosmos"), (SELECT customer_id FROM Customers WHERE name = "Wanda Cosmo"));


END//
DELIMITER //

CREATE PROCEDURE sp_CreateCustomer(
    IN p_name VARCHAR(255), 
    IN p_phone_number VARCHAR(15), 
    IN p_email VARCHAR(500), 
    OUT p_customer_id INT)
DELIMITER ;




-- #############################
-- CREATE customer
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateCustomer;

DELIMITER //

CREATE PROCEDURE sp_CreateCustomer(
    IN p_name VARCHAR(255), 
    IN p_phone_number VARCHAR(15), 
    IN p_email VARCHAR(500), 
    OUT p_customer_id INT)


BEGIN
    INSERT INTO Customers (name, phone_number, email) 
    VALUES (p_name, p_phone_number, p_email);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into p_customer_id;
    -- Display the ID of the last inserted person.
    SELECT LAST_INSERT_ID() AS 'new_id';

    -- Example of how to get the ID of the newly created person:
        -- CALL sp_CreatePerson('Theresa', 'Evans', 2, 48, @new_id);
        -- SELECT @new_id AS 'New Person ID';
END //
DELIMITER ;


-- #############################
-- UPDATE customers
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateCustomer;

DELIMITER //

CREATE PROCEDURE sp_UpdateCustomer(
    IN p_customer_id INT, 
    IN p_name VARCHAR(255), 
    IN p_phone_number VARCHAR(15), 
    IN p_email VARCHAR(500)
    )

BEGIN
    UPDATE Customers 
    SET name = p_name, phone_number = p_phone_number, email = p_email 
    WHERE customer_id = p_customer_id; 
END //
DELIMITER ;

-- #############################
-- DELETE customer
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteCustomer;

DELIMITER //

CREATE PROCEDURE sp_DeleteCustomer(IN p_customer_id INT)

BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both bsg_people table and 
        --      intersection table to prevent a data anamoly
        -- This can also be accomplished by using an 'ON DELETE CASCADE' constraint
        --      inside the bsg_cert_people table.
        DELETE FROM Show_Customers WHERE pid = p_customer_id;
        DELETE FROM Customers WHERE id = p_customer_id;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in bsg_people for id: ', p_customer_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;
