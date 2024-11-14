require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

app.post('/api/register', async (req, res) => {
  try {
    const { username, email, password, dietary_preference } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);
    
    const result = await pool.query(
      'INSERT INTO user_info (username, email, password, dietary_preference) VALUES ($1, $2, $3, $4) RETURNING user_id',
      [username, email, hashedPassword, dietary_preference]
    );
    
    res.json({ success: true, user_id: result.rows[0].user_id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/recipes', async (req, res) => {
  try {
    const { user_id, title, cook_time, description, public_or_private } = req.body;

    const result = await pool.query(
      'INSERT INTO recipes (user_id, title, cook_time, description, public_or_private) VALUES ($1, $2, $3, $4, $5) RETURNING recipe_id',
      [user_id, title, cook_time, description, public_or_private]
    );

    res.json({ success: true, recipe_id: result.rows[0].recipe_id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/recipes/public', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT r.*, u.username FROM recipes r JOIN user_info u ON r.user_id = u.user_id WHERE public_or_private = true ORDER BY created_at DESC'
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
