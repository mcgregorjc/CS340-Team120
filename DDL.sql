/*
    Assignment: Project Step 2 Draft
    Authors: William Brennan and Mcgregor Cooper
    Date: 2025-05-01

    Description: This is an SQL file containing the entities, relationships, and data
    based on the Project Step 1 assignment. The file is a mockup for a database
    constructed for use for an observatory.
*/

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

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
/* Not Needed Currently
("Camelopardalis", 1),
("Cancer", 1),
("Canes Venatici", 1),
("Canis Major", 0),
("Canis Minor", 1),
("Capricornus", 0),
("Carina", 0),
("Cassiopeia", 1),
("Centaurus", 0),
("Cepheus", 1),
("Cetus", 0),
("Chamaeleon", 0),
("Circinus", 0),
("Columba", 0),
("Coma Berenices", 1),
("Corona Australis", 0),
("Corona Borealis", 1),
("Corvus", 0),
("Crater", 0),
("Crux", 0),
("Cygnus", 1),
("Delphinus", 1),
("Dorado", 0),
("Draco", 1),
("Equuleus", 1),
("Eridanus", 0),
("Fornax", 0),
("Gemini", 0),
("Grus", 0),
("Hercules", 1),
("Horologium", 0),
("Hydra", 0),
("Hydrus", 0),
("Indus", 0),
("Lacerta", 1),
("Leo", 1),
("Leo Minor", 1),
("Lepus", 0),
("Libra", 0),
("Lupus", 0),
("Lynx", 1),
("Lyra", 1),
("Mensa", 0),
("Microscopium", 0),
("Monoceros", 1),
("Musca", 0),
("Norma", 0),
("Octans", 0),
("Ophiuchus", 0),
("Orion", 1),
("Pavo", 0),
("Pegasus", 1),
("Perseus", 1),
("Phoenix", 0),
("Pictor", 0),
("Pisces", 1),
("Piscis Austrinus", 0),
("Puppis", 0),
("Pyxis", 0),
("Reticulum", 0),
("Sagitta", 1),
("Sagittarius", 0),
("Scorpius", 0),
("Sculptor", 0),
("Scutum", 0),
("Serpens", 1),
("Sextans", 0),
("Taurus", 1),
("Telescopium", 0),
("Triangulum", 1),
("Triangulum Australe", 0),
("Tucana", 0),
("Ursa Major", 1),
("Ursa Minor", 1),
("Vela", 0),
("Virgo", 0),
("Volans", 0),
("Vulpecula", 1);
*/

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

SET FOREIGN_KEY_CHECKS=1;
COMMIT;
