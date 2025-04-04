require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const showRoutes = require('./routes/shows');
const authRoutes = require('./routes/auth'); // Nouvelle route d'authentification

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware pour forcer les réponses JSON
app.use((req, res, next) => {
  res.setHeader('Content-Type', 'application/json');
  next();
});

// Middlewares de base
app.use(cors());
app.use(bodyParser.json());

// Routes statiques
app.use('/uploads', express.static('uploads'));

// Routes API
app.use('/auth', authRoutes); // Ajout des routes d'authentification
app.use('/shows', showRoutes);

// Gestion des erreurs 404
app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found' });
});

// Middleware de gestion d'erreurs global
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});