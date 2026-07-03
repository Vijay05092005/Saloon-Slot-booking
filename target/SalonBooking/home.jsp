<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Salon & Spa</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
</head>
<body>
<header class="header">
    <a class="logo" href="#top">Salon Lumina</a>
    <nav class="nav-links">
        <a href="#about">About</a>
        <a href="#services">Services</a>
        <a href="#why">Why Us</a>
        <a href="#contact">Contact</a>
    </nav>
    <button class="nav-cta" onclick="goToApp('<%= request.getContextPath() %>')">Login / Register</button>
</header>

<section id="top" class="hero">
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <p class="hero-chip">Premium Grooming Studio</p>
        <h1>Crafted Looks, Confident You</h1>
        <p class="hero-subtitle">Salon and spa experiences designed for comfort, precision, and lasting style.</p>
        <div class="hero-actions">
            <button class="hero-btn" onclick="goToApp('<%= request.getContextPath() %>')">Enter Application</button>
            <a class="hero-link" href="#services">Explore Services</a>
        </div>
    </div>
    <div class="hero-panel">
        <h3>Today at Salon Lumina</h3>
        <p>Walk-ins welcome for grooming and hair services.</p>
        <ul>
            <li>Expert stylists and skincare specialists</li>
            <li>Premium international products</li>
            <li>Relaxed ambience with hygienic care</li>
        </ul>
    </div>
</section>

<section id="about" class="section about">
    <p class="section-chip">About Us</p>
    <h2>Luxury Care With Modern Standards</h2>
    <p>Luxury Salon & Spa is your trusted beauty destination for precision hair styling, skin rituals, spa therapies, and complete grooming services. We focus on consistent quality, hygiene, and personalized care.</p>
</section>

<section id="services" class="section services">
    <p class="section-chip">Services</p>
    <h2>Popular Experiences</h2>
    <div class="service-grid">
        <article class="card">
            <h3>Hair Styling</h3>
            <p>Precision cuts, blowouts, and trend-led finishing.</p>
        </article>
        <article class="card">
            <h3>Spa & Massage</h3>
            <p>Body therapies crafted to reset and recharge.</p>
        </article>
        <article class="card">
            <h3>Facial & Skincare</h3>
            <p>Glow-focused facials for all skin types.</p>
        </article>
        <article class="card">
            <h3>Bridal Makeup</h3>
            <p>Elegant occasion-ready looks for your big day.</p>
        </article>
        <article class="card">
            <h3>Men Grooming</h3>
            <p>Beard, hair, and skincare essentials for men.</p>
        </article>
        <article class="card">
            <h3>Hair Treatments</h3>
            <p>Repair, smoothening, and nourishment programs.</p>
        </article>
    </div>
</section>

<section class="stats">
    <article class="stat">
        <h3 class="count" data-target="5000">0</h3>
        <p>Happy Clients</p>
    </article>
    <article class="stat">
        <h3 class="count" data-target="25">0</h3>
        <p>Expert Stylists</p>
    </article>
    <article class="stat">
        <h3 class="count" data-target="10">0</h3>
        <p>Years Experience</p>
    </article>
</section>

<section id="why" class="section why">
    <p class="section-chip">Why Choose Us</p>
    <h2>Trusted By Thousands</h2>
    <div class="why-grid">
        <div class="why-card">Certified and experienced professionals</div>
        <div class="why-card">Premium quality products only</div>
        <div class="why-card">Hygienic and relaxing environment</div>
        <div class="why-card">Affordable packages and memberships</div>
    </div>
</section>

<section class="cta">
    <h2>Ready to Transform Your Look?</h2>
    <p>Step into your personalized salon journey in just one click.</p>
    <button onclick="goToApp('<%= request.getContextPath() %>')">Book Now</button>
</section>

<footer id="contact">
    <p>City Center, India</p>
    <p>+91 98765 43210</p>
    <p>luxurysalon@gmail.com</p>
    <p>&copy; 2026 Luxury Salon & Spa. All Rights Reserved.</p>
</footer>

<script src="<%= request.getContextPath() %>/js/home.js"></script>
</body>
</html>
