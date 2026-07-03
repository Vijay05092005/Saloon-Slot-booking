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
        <a href="#journey">Journey</a>
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
        <div class="hero-badges">
            <span>Same-day appointments</span>
            <span>Premium products</span>
            <span>Expert stylists</span>
        </div>
    </div>
    <div class="hero-panel">
        <p class="panel-kicker">Live Studio Mood</p>
        <h3>Today at Salon Lumina</h3>
        <p>Walk-ins welcome for grooming and hair services.</p>
        <div class="panel-grid">
            <div class="panel-item">
                <strong>9:00 AM</strong>
                <span>Doors open with express styling slots.</span>
            </div>
            <div class="panel-item">
                <strong>2:00 PM</strong>
                <span>Facial and spa sessions at peak demand.</span>
            </div>
            <div class="panel-item">
                <strong>7:30 PM</strong>
                <span>Evening refresh packages and beard care.</span>
            </div>
        </div>
    </div>
</section>

<section class="marquee-strip" aria-label="Salon highlights">
    <div class="marquee-track">
        <span>Signature hair rituals</span>
        <span>Skin glow treatments</span>
        <span>Relaxing spa therapies</span>
        <span>Bridal beauty artistry</span>
        <span>Men's premium grooming</span>
        <span>Signature hair rituals</span>
        <span>Skin glow treatments</span>
        <span>Relaxing spa therapies</span>
    </div>
</section>

<section id="about" class="section about">
    <p class="section-chip">About Us</p>
    <h2>Luxury Care With Modern Standards</h2>
    <p>Luxury Salon & Spa is your trusted beauty destination for precision hair styling, skin rituals, spa therapies, and complete grooming services. We focus on consistent quality, hygiene, and personalized care.</p>
    <div class="about-grid">
        <article class="about-card">
            <span>Atmosphere</span>
            <h3>Designed to slow the day down</h3>
            <p>Warm lighting, curated music, and thoughtful service create a premium visit from entry to finish.</p>
        </article>
        <article class="about-card">
            <span>Consultation</span>
            <h3>Looks tailored to real people</h3>
            <p>Every appointment starts with a style conversation so the final result suits your routine and goals.</p>
        </article>
    </div>
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

<section id="journey" class="section journey">
    <p class="section-chip">Guest Journey</p>
    <h2>From First Click To Final Reveal</h2>
    <div class="journey-grid">
        <article class="journey-card">
            <span class="journey-step">01</span>
            <h3>Discover</h3>
            <p>Browse services, see the studio feel, and understand what fits your style goals.</p>
        </article>
        <article class="journey-card">
            <span class="journey-step">02</span>
            <h3>Book</h3>
            <p>Move into the app to login, register, and reserve your visit in a smooth flow.</p>
        </article>
        <article class="journey-card">
            <span class="journey-step">03</span>
            <h3>Glow</h3>
            <p>Enjoy a polished salon experience delivered with premium products and precise care.</p>
        </article>
    </div>
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

<section class="section testimonials">
    <p class="section-chip">Guest Voices</p>
    <h2>Small Details, Big Confidence</h2>
    <div class="testimonial-grid">
        <article class="testimonial-card">
            <p>"The team understood exactly the look I wanted and made the whole visit feel special."</p>
            <span>Priya, Bridal Client</span>
        </article>
        <article class="testimonial-card">
            <p>"Clean, calm, and consistent. My grooming appointments are always smooth and on time."</p>
            <span>Arjun, Regular Member</span>
        </article>
        <article class="testimonial-card">
            <p>"The atmosphere feels premium, but the service is still warm and personal."</p>
            <span>Nisha, Skin Care Client</span>
        </article>
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
