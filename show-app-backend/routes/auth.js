const express = require('express');
const router = express.Router();

router.post('/login', (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ error: "Email and password are required" });
    }

    if (email === "admin@example.com" && password === "password123") {
        return res.json({ token: "your_fake_jwt_token" });
    } else {
        return res.status(401).json({ error: "Invalid credentials" });
    }
});

module.exports = router;
