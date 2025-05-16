-- Populate the Stars, Constellations, Customers, and Shows dropdowns
SELECT star_id, proper_name FROM Stars;
SELECT constellation_id, name FROM Constellations;
SELECT customer_id, name FROM Customers;
SELECT show_id, title FROM Shows;


-- Get a single star/show/customer's data for their Update form
SELECT constellation_id, proper_name, temperature, radius, color, spectral_class FROM Stars WHERE star_id = :star_id_selected_from_browse_star_page;
SELECT title, date FROM Shows WHERE show_id = :show_id_selected_from_browse_show_page;
SELECT name, phone_number, email FROM Customers WHERE customer_id = :customer_id_selected_from_browse_customer_page;


-- Get all star/constellation/customer's data to populate a dropdown for associating with a show  
SELECT star_id, proper_name FROM Stars;
SELECT constellation_id, name FROM Constellations;
SELECT customer_id, name FROM Customers ;


-- Get all show's data to populate a dropdown for associating with a star/constellation/customer
SELECT show_id, title FROM Shows;


-- Get all star/customer/constellations with their current associated shows to list
SELECT star_id, show_id, proper_name, title
FROM Stars 
INNER JOIN Show_Stars ON Stars.star_id = Show_Stars.star_id
INNER JOIN Shows on Shows.show_id = Show_Stars.show_id
ORDER BY title, proper_name;

SELECT constellation_id, show_id, name, title
FROM Constellations 
INNER JOIN Show_Constellations ON Constellations.constellation_id = Show_Constellations.constellation_id
INNER JOIN Shows on Shows.show_id = Show_Constellations.show_id
ORDER BY title, name;

SELECT customer_id, show_id, name, title
FROM Customers
INNER JOIN Show_Customers ON Customers.customer_id = Show_Customers.customer_id
INNER JOIN Shows on Shows.show_id = Show_Customers.customer_id
ORDER BY title, name;



-- Add a Star/Show/Customer
INSERT INTO Stars (constellation_id, proper_name, temperature, radius, color, spectral_class)
VALUES (:constellation_id_Input, :proper_name_Input, :temperature_Input, :radius_Input, :color_Input, :spectral_class_Input);

INSERT INTO Shows (title, date)
VALUES (:title_Input, :date_Input);

INSERT INTO Customers (name, phone_number, email)
VALUES (:name_Input, :phone_number_Input, :email_Input);

-- associate a Star/Constellation/Customer with a Show
INSERT INTO Show_Stars (star_id, show_id) VALUES (:star_id_from_dropdown_Input, :show_id_from_dropdown_Input);
INSERT INTO Show_Constellations (constellation_id, show_id) VALUES (:constellation_id_from_dropdown_Input, :show_id_from_dropdown_Input);
INSERT INTO Show_Customers (customer_id, show_id) VALUES (:customer_id_from_dropdown_Input, :show_id_from_dropdown_Input);

-- update a Star/Show/Customer's data
UPDATE Stars SET constellation_id = :constellation_id_Input, proper_name= :proper_name_Input, temperature = :temperature_Input, radius= :radius_Input,
                    color= :color_Input, spectral_class= :spectral_class_Input WHERE id= :star_id_from_the_update_form;

UPDATE Shows SET title = :title_Input, date= :date_Input WHERE id= :show_id_from_the_update_form;
UPDATE Customers SET name = :name_Input, phone_number= :phone_number_Input, email = :email_Input WHERE id= :customer_id_from_the_update_form;

-- delete a Star/Show/Customer
DELETE FROM Stars WHERE id = :star_id_selected_from_browse_star_page;
DELETE FROM Shows WHERE id = :show_id_selected_from_browse_show_page;
DELETE FROM Customers WHERE id = :customer_id_selected_from_browse_customer_page;

-- dis-associate a Star/Constellation/Customer from a Show
DELETE FROM Show_Stars WHERE star_id = :star_id_selected_from_show_and_star_list AND show_id = :show_id_selected_from_show_and_star_list;
DELETE FROM Show_Constellations WHERE constellation_id = :constellation_id_selected_from_show_and_constellation_list AND show_id = :show_id_selected_from_show_and_constellation_list;
DELETE FROM Show_Customers WHERE customer_id = :customer_id_selected_from_show_and_customer_list AND show_id = :show_id_selected_from_show_and_customer_list;

