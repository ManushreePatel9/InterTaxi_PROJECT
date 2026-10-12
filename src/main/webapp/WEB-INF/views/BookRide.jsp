<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.UsersEntity" %>
<%
    // Simple Java Session Check (Without JSTL)
    UsersEntity user = (UsersEntity) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post Ride Request | Intercity Smart Cabs</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --brand-yellow: #FFB703;
            --brand-dark: #1D232A;
            --brand-light: #F8FAFC;
            --card-bg: #FFFFFF;
            --text-dark: #0F172A;
            --text-muted: #64748B;
            --border-color: #E2E8F0;
            --accent-blue: #0284C7;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
            min-height: 100vh;
            padding: 2.5rem 1rem;
            color: var(--text-dark);
            position: relative;
            overflow-x: hidden;
        }

        .bg-glow-1 {
            position: absolute;
            width: 400px;
            height: 400px;
            background: rgba(255, 183, 3, 0.12);
            filter: blur(100px);
            border-radius: 50%;
            top: -5%;
            left: -5%;
            z-index: 0;
        }

        .bg-glow-2 {
            position: absolute;
            width: 350px;
            height: 350px;
            background: rgba(2, 132, 199, 0.12);
            filter: blur(100px);
            border-radius: 50%;
            bottom: -5%;
            right: -5%;
            z-index: 0;
        }

        .ride-container {
            position: relative;
            z-index: 1;
            max-width: 720px;
            margin: 0 auto;
        }

        .glass-card {
            background: var(--card-bg);
            border-radius: 24px;
            padding: 2.5rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.35);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header-box {
            text-align: center;
            margin-bottom: 2rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 1.5rem;
        }

        .brand-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(255, 183, 3, 0.18);
            color: #B45309;
            font-weight: 700;
            font-size: 0.85rem;
            padding: 0.4rem 1rem;
            border-radius: 50px;
            margin-bottom: 0.75rem;
        }

        .form-section-title {
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--brand-dark);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-section-title i {
            color: var(--accent-blue);
        }

        .input-group-custom {
            margin-bottom: 1.25rem;
            position: relative;
        }

        .input-group-custom label {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.4rem;
            display: block;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-icon {
            position: absolute;
            left: 14px;
            color: var(--text-muted);
            font-size: 1.1rem;
            pointer-events: none;
        }

        .form-control-custom {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.75rem;
            font-size: 0.95rem;
            font-weight: 500;
            color: var(--text-dark);
            background-color: var(--brand-light);
            border: 1.5px solid var(--border-color);
            border-radius: 12px;
            transition: all 0.2s ease;
        }

        .form-control-custom:focus {
            background-color: #FFFFFF;
            border-color: var(--brand-dark);
            box-shadow: 0 0 0 4px rgba(29, 35, 42, 0.08);
            outline: none;
        }

        /* Suggestion List Style (Uber/Ola Style) */
        .suggestions-box {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: #FFFFFF;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            max-height: 220px;
            overflow-y: auto;
            z-index: 999;
            display: none;
            margin-top: 4px;
        }

        .suggestion-item {
            padding: 0.75rem 1rem;
            font-size: 0.9rem;
            color: var(--text-dark);
            cursor: pointer;
            border-bottom: 1px solid #F1F5F9;
            display: flex;
            align-items: center;
            gap: 0.6rem;
        }

        .suggestion-item:last-child {
            border-bottom: none;
        }

        .suggestion-item:hover {
            background-color: #F8FAFC;
            color: var(--accent-blue);
        }

        .suggestion-item i {
            color: var(--text-muted);
            font-size: 1rem;
        }

        .smart-info-banner {
            background: #F0F9FF;
            border: 1px solid #BAE6FD;
            border-radius: 14px;
            padding: 0.9rem 1.1rem;
            margin-bottom: 1.5rem;
            display: flex;
            gap: 0.75rem;
            align-items: center;
        }

        .smart-info-banner i {
            font-size: 1.2rem;
            color: var(--accent-blue);
        }

        .btn-submit-ride {
            width: 100%;
            background-color: var(--brand-yellow);
            color: var(--brand-dark);
            font-weight: 800;
            font-size: 1.1rem;
            padding: 0.9rem;
            border-radius: 14px;
            border: none;
            box-shadow: 0 8px 25px rgba(255, 183, 3, 0.4);
            transition: all 0.2s ease-in-out;
            cursor: pointer;
        }

        .btn-submit-ride:hover {
            background-color: #E0A100;
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(255, 183, 3, 0.5);
        }

        .btn-back-dashboard {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: #94A3B8;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .btn-back-dashboard:hover {
            color: #FFFFFF;
        }
    </style>
</head>
<body>

<div class="bg-glow-1"></div>
<div class="bg-glow-2"></div>

<div class="ride-container">

    <a href="passengerDashboard" class="btn-back-dashboard">
        <i class="bi bi-arrow-left"></i> Back to Dashboard
    </a>

    <div class="glass-card">

        <div class="header-box">
            <div class="brand-badge">
                <i class="bi bi-lightning-charge-fill"></i> Smart Return Fare Saver
            </div>
            <h2 class="fw-bold mb-1" style="color: var(--text-dark);">Book Outstation Ride</h2>
            <p class="text-muted mb-0 small">Enter route and timing to calculate instant fare & smart return discounts</p>
        </div>

        <form action="saveRideRequest" method="POST">

            <!-- Route Info Section -->
            <div class="form-section-title">
                <i class="bi bi-geo-alt-fill"></i> Route Details
            </div>

            <div class="row">
                <!-- Pickup Location -->
                <div class="col-md-6">
                    <div class="input-group-custom">
                        <label for="pickupLocation">Pickup Location / City</label>
                        <div class="input-wrapper">
                            <input type="text" class="form-control-custom" id="pickupLocation" name="pickupLocation" placeholder="Type pickup location (e.g. Ahmedabad)" autocomplete="off">
                            <i class="bi bi-geo-alt input-icon"></i>
                        </div>
                        <div id="pickupSuggestions" class="suggestions-box"></div>
                    </div>
                </div>

                <!-- Drop Location -->
                <div class="col-md-6">
                    <div class="input-group-custom">
                        <label for="dropLocation">Drop Location / City</label>
                        <div class="input-wrapper">
                            <input type="text" class="form-control-custom" id="dropLocation" name="dropLocation" placeholder="Type drop location (e.g. Mumbai)" autocomplete="off">
                            <i class="bi bi-pin-map input-icon"></i>
                        </div>
                        <div id="dropSuggestions" class="suggestions-box"></div>
                    </div>
                </div>
            </div>

            <!-- HIDDEN LATITUDE & LONGITUDE INPUTS (AUTO-FILLED BY JS) -->
            <input type="hidden" id="pickupLat" name="pickupLat">
            <input type="hidden" id="pickupLng" name="pickupLng">
            <input type="hidden" id="dropLat" name="dropLat">
            <input type="hidden" id="dropLng" name="dropLng">

            <hr class="my-3" style="border-color: var(--border-color);">

            <!-- Timing & Passengers Section -->
            <div class="form-section-title">
                <i class="bi bi-clock-history"></i> Ride Schedule
            </div>

            <div class="row">
                <!-- Travel Date & Time -->
                <div class="col-md-6">
                    <div class="input-group-custom">
                        <label for="travelDateTime">Departure Date & Time</label>
                        <div class="input-wrapper">
                            <input type="datetime-local" class="form-control-custom" id="travelDateTime" name="travelDateTime">
                            <i class="bi bi-calendar-event input-icon"></i>
                        </div>
                    </div>
                </div>

                <!-- Passenger Count -->
                <div class="col-md-6">
                    <div class="input-group-custom">
                        <label for="passengerCount">Passenger Count / Seats</label>
                        <div class="input-wrapper">
                            <input type="number" class="form-control-custom" id="passengerCount" name="passengerCount" placeholder="e.g. 1, 2 or 4" min="1" max="6">
                            <i class="bi bi-people input-icon"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Smart Matching Info Banner -->
            <div class="smart-info-banner">
                <i class="bi bi-percent"></i>
                <div class="small text-secondary">
                    <strong class="text-dark">Smart Savings Enabled:</strong> Fare and up to 20% return-trip discount will be automatically calculated based on GPS distance!
                </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn-submit-ride mt-2">
                Request Ride & Calculate Fare <i class="bi bi-arrow-right ms-1"></i>
            </button>

        </form>

    </div>
</div>

<a href="viewPassengerBookedRides" class="btn btn-sm btn-primary text-white rounded-pill px-3 shadow-sm">
    <i class="fa-solid fa-car-side me-1"></i> My Booked Rides
</a>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- FREE OPENSTREETMAP AUTO-COMPLETE JAVASCRIPT -->
<script>
    function setupLocationAutocomplete(inputId, suggestionsId, latInputId, lngInputId) {
        const input = document.getElementById(inputId);
        const suggestionsBox = document.getElementById(suggestionsId);
        const latInput = document.getElementById(latInputId);
        const lngInput = document.getElementById(lngInputId);

        let timer;

        input.addEventListener('input', function () {
            clearTimeout(timer);
            const query = input.value.trim();

            if (query.length < 3) {
                suggestionsBox.style.display = 'none';
                return;
            }

            // String Concatenation used to avoid JSP Expression Language collision
            timer = setTimeout(() => {
                fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(query) + '&countrycodes=in&limit=5')
                    .then(response => response.json())
                    .then(data => {
                        suggestionsBox.innerHTML = '';

                        if (data.length === 0) {
                            suggestionsBox.style.display = 'none';
                            return;
                        }

                        data.forEach(item => {
                            const div = document.createElement('div');
                            div.className = 'suggestion-item';
                            div.innerHTML = '<i class="bi bi-geo-alt-fill"></i> ' + item.display_name;

                            div.addEventListener('click', function () {
                                input.value = item.display_name;
                                latInput.value = item.lat;
                                lngInput.value = item.lon;
                                suggestionsBox.style.display = 'none';
                            });

                            suggestionsBox.appendChild(div);
                        });

                        suggestionsBox.style.display = 'block';
                    })
                    .catch(err => console.error("Error fetching location suggestions:", err));
            }, 300);
        });

        // Hide suggestions when clicked outside
        document.addEventListener('click', function (e) {
            if (!input.contains(e.target) && !suggestionsBox.contains(e.target)) {
                suggestionsBox.style.display = 'none';
            }
        });
    }

    // Setup Auto-complete for both Pickup and Drop fields
    setupLocationAutocomplete('pickupLocation', 'pickupSuggestions', 'pickupLat', 'pickupLng');
    setupLocationAutocomplete('dropLocation', 'dropSuggestions', 'dropLat', 'dropLng');
</script>

</body>
</html>