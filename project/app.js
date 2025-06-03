// ########################################
// ########## SETUP

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 5876;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// ########################################
// ########## ROUTE HANDLERS

// READ ROUTES
app.get('/', async function (req, res) {
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/Constellations', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we use select to show the table names of the Constellations table names
        const query1 = `SELECT Constellations.constellation_id, Constellations.name, Constellations.northern_hemisphere \
            FROM Constellations`;
        const [Constellations] = await db.query(query1);

        // Render the Constellations.hbs file, and also send the renderer
        //  an object that contains our Constellations information
        res.render('Constellations', { Constellations: Constellations});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }

});

app.get('/Stars', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we select table names of stars table 
        const query1 = `SELECT Stars.star_id, Stars.constellation_id, Stars.proper_name, Stars.temperature, \
            Stars.radius, Stars.color, Stars.spectral_class FROM Stars`;
        //const query2 = 'SELECT * FROM stars;';
        const [Stars] = await db.query(query1);
        //const [Stars] = await db.query(query2);

        const query2 = `SELECT Constellations.constellation_id, Constellations.name FROM Constellations`;
        const [Constellations] = await db.query(query2);

        // Render the Stars.hbs file, and also send the renderer
        //  an object that contains our Stars information
        res.render('Stars', { Stars: Stars, Constellations: Constellations});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/Shows', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we use select to display the table names of the Shows table
        const query1 = `SELECT Shows.show_id, Shows.title, Shows.date FROM Shows`;
        const [Shows] = await db.query(query1);

        // Render the Shows.hbs file, and also send the renderer
        //  an object that contains our Shows information
        res.render('Shows', { Shows: Shows});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }

});

app.get('/Customers', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, select is used to get the table names of the Customers table 
        const query1 = `SELECT Customers.customer_id, Customers.name, Customers.phone_number, Customers.email\
            FROM Customers`;
        const [Customers] = await db.query(query1);


        // Render the Customers.hbs file, and also send the renderer
        //  an object that contains our Customers information
        res.render('Customers', { Customers: Customers});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/Show_Customers', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we use select to display the names of Show_Customers
        const query1 = `SELECT Show_Customers.show_id, Show_Customers.customer_id FROM Show_Customers`;
        const [Show_Customers] = await db.query(query1);

        // Render the Show_Customers.hbs file, and also send the renderer
        //  an object that contains our Show_Customers information
        res.render('Show_Customers', { Show_Customers: Show_Customers});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/Show_Constellations', async function (req, res) {
    try {
        // Create and execute our queries
        // In query1, we use select to display the names of Show_Constellations
        const query1 = `SELECT Show_Constellations.show_id, Show_Constellations.constellation_id FROM Show_Constellations`;
        const [Show_Constellations] = await db.query(query1);

        // Render the Show_Constellations.hbs file, and also send the renderer
        //  an object that contains our Show_Constellations information
        res.render('Show_Constellations', { Show_Constellations: Show_Constellations});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/Show_Stars', async function (req, res) { 
    try {
        // Create and execute our queries
        // In query1, we use select to display the names of the Show_Stars
        const query1 = `SELECT Show_Stars.show_id, Show_Stars.star_id FROM Show_Stars`;
        const [Show_Stars] = await db.query(query1);


        // Render the Show_Stars.hbs file, and also send the renderer
        //  an object that contains our Show_Stars information
        res.render('Show_Stars', { Show_Stars: Show_Stars});
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// Reset ROUTE

app.post('/ResetDatabase', async (req, res, next) => {
    try{
      await db.execute('CALL sp_Reset_Database();');
      res.render("home");
    } catch(err){
      next(err);
    }
  });


// CREATE ROUTES
app.post('/Constellations/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;


        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateConstellations(?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_constellation_name,
            data.create_constellation_northern_hemisphere,
        ]);

        console.log(`CREATE Constellation. ID: ${rows.new_id} ` +
            `Name: ${data.create_Constellation_name}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/Constellations');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.post('/Stars/create', async function (req, res) {
    try {
        let data = req.body;
        const query1 = `CALL sp_CreateStars(?, ?, ?, ?, ?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_star_proper_name,
            data.create_star_temperature,
            data.create_star_radius,
            data.create_star_color,
            data.create_star_spectral_class,
        ]);

        console.log(`CREATE Star. ID: ${rows.new_id} ` +
            `Name: ${data.create_Star_proper_name}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/Stars');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.post('/Shows/create', async function (req, res) {
    try {
        let data = req.body;
        const query1 = `CALL sp_CreateShows(?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_show_title,
            data.create_show_date,
        ]);

        console.log(`CREATE Show. ID: ${rows.new_id} ` +
            `Title: ${data.create_Show_title}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/Shows');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.post('/Customers/create', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;


        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateCustomer(?, ?, ?, @new_id);`;

        // Store ID of last inserted row
        const [[[rows]]] = await db.query(query1, [
            data.create_customer_name,
            data.create_customer_phone_number,
            data.create_customer_email,
        ]);

        console.log(`CREATE Customer. ID: ${rows.new_id} ` +
            `Name: ${data.create_customer_name}`
        );

        // Redirect the user to the updated webpage
        res.redirect('/Customers');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// UPDATE ROUTES
app.post('/Customers/update', async function (req, res) {
    try {
        // Parse frontend form information
        const data = req.body;


        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = 'CALL sp_UpdateCustomer(?, ?, ?, ?);';
        const query2 = 'SELECT name FROM Customers WHERE customer_id = ?;';
        await db.query(query1, [
            data.update_customer_id,
            data.update_customer_name,
            data.update_customer_phone_number,
            data.update_customer_email,
        ]);
        const [[row]] = await db.query(query2, [data.update_customer_id]);

        console.log(`UPDATE Customer. ID: ${data.update_customer_id} ` +
            `Name: ${row.name}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/Customers');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// DELETE ROUTES
app.post('/Customers/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_DeleteCustomer(?);`;
        await db.query(query1, [data.delete_customer_id]);

        console.log(`DELETE Customer. ID: ${data.delete_customer_id} ` +
            `Name: ${data.delete_customer_name}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/Customers');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});
