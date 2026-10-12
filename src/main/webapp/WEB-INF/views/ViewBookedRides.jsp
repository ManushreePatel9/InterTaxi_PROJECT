<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.entity.BookedRidesEntity" %>
<%@ page import="com.entity.BookRideEntity" %>

<%!
    // Standard Rate per KM
    private static final float RATE_PER_KM = 12.0f;
    // 20% Discount for BOTH passengers IF it's a MATCHED pair
    private static final float MATCHED_DISCOUNT_PERCENTAGE = 0.20f; 

    // Haversine Distance Calculation
    private double calculateDistanceInKm(Float lat1, Float lon1, Float lat2, Float lon2) {
        if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) {
            return 0.0;
        }
        double R = 6371.0;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                   Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                   Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booked Rides - Ride Matcher</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body { background-color: #f1f5f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: #334155; }
        .header-box { background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%); color: white; border-radius: 14px; padding: 20px 24px; margin-bottom: 24px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        .booking-card { background: #ffffff; border-radius: 14px; border: 1px solid #e2e8f0; margin-bottom: 22px; box-shadow: 0 4px 12px rgba(0,0,0,0.03); overflow: hidden; }
        .card-header-custom { background: #f8fafc; border-bottom: 1px solid #e2e8f0; padding: 14px 20px; font-weight: 600; }
        
        .badge-type { font-size: 0.75rem; padding: 5px 12px; border-radius: 20px; font-weight: 600; }
        .badge-matched { background-color: #dcfce7; color: #15803d; }
        .badge-single { background-color: #e0f2fe; color: #0369a1; }
        
        .ride-box { background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 14px; }
        .my-trip-box { background-color: #f0fdf4; border: 1.5px solid #86efac; border-radius: 10px; padding: 14px; }
        
        .fare-badge { background-color: #eff6ff; border: 1px solid #bfdbfe; color: #1d4ed8; border-radius: 8px; padding: 4px 10px; font-weight: 600; font-size: 0.85rem; }
        .fare-box { background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 10px; padding: 8px 14px; }
        
        .btn-pay { background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); color: white; border-radius: 24px; padding: 8px 20px; font-weight: 600; font-size: 0.9rem; border: none; transition: all 0.2s ease; }
        .btn-pay:hover { background: linear-gradient(135deg, #1d4ed8 0%, #1e40af 100%); color: white; }
    </style>
</head>
<body>

<div class="container py-4">

    <%
        List<BookedRidesEntity> bookedRides = (List<BookedRidesEntity>) request.getAttribute("bookedRides");
        String userRole = (String) request.getAttribute("userRole");
        String backUrl = (String) request.getAttribute("backUrl");
        Integer loggedInUserId = (Integer) request.getAttribute("loggedInUserId");
        
        if (backUrl == null) backUrl = "passengerDashboard";
        if (loggedInUserId == null) loggedInUserId = -1;
        
        boolean isPassenger = "PASSENGER".equalsIgnoreCase(userRole);
    %>

    <!-- Top Header -->
    <div class="header-box d-flex justify-content-between align-items-center">
        <div>
            <h4 class="fw-bold mb-1">
                <i class="fa-solid fa-car-side text-info me-2"></i>
                <%= isPassenger ? "My Booked Rides" : "Confirmed Passenger Bookings" %>
            </h4>
            <p class="mb-0 text-slate-300 small">
                <%= isPassenger ? "View individual distance-calculated fares and ride details." : "Check pickup locations and collect exact fares calculated per route distance." %>
            </p>
        </div>
        <div>
            <a href="<%= backUrl %>" class="btn btn-sm btn-outline-light rounded-pill px-3">
                <i class="fa-solid fa-arrow-left me-1"></i> Back
            </a>
        </div>
    </div>

    <!-- Rides List -->
    <div class="row">
        <%
            if (bookedRides != null && !bookedRides.isEmpty()) {
                for (BookedRidesEntity b : bookedRides) {
                    
                    BookRideEntity forwardRide = b.getForwardRide();
                    BookRideEntity returnRide = b.getReturnRide();

                    // Single Ride vs Matched Ride Check (Strict Safe Checking)
                    boolean isMatched = "MATCHED_PAIR".equalsIgnoreCase(b.getBookingType()) && returnRide != null;
                    
                    // Safe Passenger Matching Check
                    boolean isReturnPassenger = false;
                    if (isPassenger && returnRide != null && returnRide.getUser() != null) {
                        if (returnRide.getUser().getUserId() != null && returnRide.getUser().getUserId().equals(loggedInUserId)) {
                            isReturnPassenger = true;
                        }
                    }

                    // 1. Calculate KM Distances
                    double forwardKM = 0.0;
                    double returnKM = 0.0;
                    
                    if (forwardRide != null) {
                        forwardKM = calculateDistanceInKm(forwardRide.getPickupLat(), forwardRide.getPickupLng(), forwardRide.getDropLat(), forwardRide.getDropLng());
                    }
                    if (isMatched && returnRide != null) {
                        returnKM = calculateDistanceInKm(returnRide.getPickupLat(), returnRide.getPickupLng(), returnRide.getDropLat(), returnRide.getDropLng());
                    }

                    // 2. Base Fares Calculation
                    double forwardFareOriginal = Math.round(forwardKM * RATE_PER_KM);
                    double returnFareOriginal = Math.round(returnKM * RATE_PER_KM);

                    // 3. Discount Logic: 20% Discount ONLY IF MATCHED
                    double forwardFareFinal = isMatched ? Math.round(forwardFareOriginal * (1.0f - MATCHED_DISCOUNT_PERCENTAGE)) : forwardFareOriginal;
                    double returnFareFinal = isMatched ? Math.round(returnFareOriginal * (1.0f - MATCHED_DISCOUNT_PERCENTAGE)) : returnFareOriginal;
                    
                    // 4. Total Collection for Driver
                    double calculatedTotalCollection = forwardFareFinal + (isMatched ? returnFareFinal : 0.0);
                    
                    // Passenger Payable Amount
                    double myPayableShare = isReturnPassenger ? returnFareFinal : forwardFareFinal;
                    
                    String rideStatus = b.getStatus() != null ? b.getStatus() : "CONFIRMED";
                    boolean isPaid = "PAID".equalsIgnoreCase(rideStatus) || "COMPLETED".equalsIgnoreCase(rideStatus);
        %>
        <div class="col-12">
            <div class="booking-card">
                
                <!-- Card Header -->
                <div class="card-header-custom d-flex justify-content-between align-items-center flex-wrap gap-2">
                    <div>
                        <span class="text-secondary me-2">Booking ID: <strong>#<%= b.getBookingId() %></strong></span>
                        <span class="badge-type <%= isMatched ? "badge-matched" : "badge-single" %> me-2">
                            <%= isMatched ? "🔄 Matched Pair Trip" : "🚗 Single Trip" %>
                        </span>
                        <span class="badge <%= isPaid ? "bg-success" : "bg-warning text-dark" %>">
                            <i class="<%= isPaid ? "fa-solid fa-circle-check" : "fa-solid fa-clock" %> me-1"></i> <%= rideStatus %>
                        </span>
                    </div>

                    <!-- Header Fare Display -->
                    <div class="text-end">
                        <% if (isPassenger) { %>
                            <div class="fare-box d-inline-block text-start">
                                <span class="text-muted small d-block">Your Fare Amount:</span>
                                <span class="text-success fw-bold fs-5">₹<%= String.format("%.2f", myPayableShare) %></span>
                            </div>
                        <% } else { %>
                            <div class="text-end">
                                <span class="text-muted small d-block">Total Collection:</span>
                                <span class="text-success fw-bold fs-5">₹<%= String.format("%.2f", calculatedTotalCollection) %></span>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Card Body -->
                <div class="p-3">
                    <div class="row g-3">
                        
                        <!-- FORWARD / SINGLE RIDE (PASSENGER 1) -->
                        <% if (forwardRide != null) { %>
                        <div class="<%= isMatched ? "col-md-6" : "col-md-12" %>">
                            <div class="<%= (isPassenger && !isReturnPassenger) ? "my-trip-box" : "ride-box" %>">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="fw-bold text-primary mb-0">
                                        <i class="fa-solid fa-location-dot text-danger me-1"></i> 
                                        <%= isMatched ? (isPassenger && !isReturnPassenger ? "Your Requested Trip" : "Forward Trip") : "Passenger Trip Details" %> (#<%= forwardRide.getRequestId() %>)
                                    </h6>
                                    
                                    <span class="fare-badge">
                                        ₹<%= String.format("%.0f", forwardFareFinal) %> (<%= String.format("%.1f", forwardKM) %> KM <%= isMatched ? "- 20% OFF" : "" %>)
                                    </span>
                                </div>
                                
                                <div class="small text-secondary mb-1"><strong>Pickup:</strong> <%= forwardRide.getPickupLocation() %></div>
                                <div class="small text-secondary mb-1"><strong>Drop:</strong> <%= forwardRide.getDropLocation() %></div>
                                <div class="small text-secondary mb-1">
                                    <strong>Passenger:</strong> <%= (forwardRide.getUser() != null && forwardRide.getUser().getFullName() != null) ? forwardRide.getUser().getFullName() : "N/A" %>
                                </div>
                                <div class="small text-secondary">
                                    <strong>Time:</strong> <%= forwardRide.getTravelDateTime() != null ? forwardRide.getTravelDateTime().toString().replace("T", " ") : "N/A" %>
                                </div>
                            </div>
                        </div>
                        <% } %>

                        <!-- RETURN RIDE (PASSENGER 2) - ONLY SHOWN FOR MATCHED TRIP -->
                        <% if (isMatched && returnRide != null) { %>
                        <div class="col-md-6">
                            <div class="<%= (isPassenger && isReturnPassenger) ? "my-trip-box" : "ride-box" %>">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="fw-bold text-success mb-0">
                                        <i class="fa-solid fa-arrows-rotate me-1"></i> 
                                        <%= (isPassenger && isReturnPassenger) ? "Your Requested Trip" : "Return Trip" %> (#<%= returnRide.getRequestId() %>)
                                    </h6>
                                    
                                    <span class="fare-badge">
                                        ₹<%= String.format("%.0f", returnFareFinal) %> (<%= String.format("%.1f", returnKM) %> KM - 20% OFF)
                                    </span>
                                </div>
                                
                                <div class="small text-secondary mb-1"><strong>Pickup:</strong> <%= returnRide.getPickupLocation() %></div>
                                <div class="small text-secondary mb-1"><strong>Drop:</strong> <%= returnRide.getDropLocation() %></div>
                                <div class="small text-secondary mb-1">
                                    <strong>Passenger:</strong> <%= (returnRide.getUser() != null && returnRide.getUser().getFullName() != null) ? returnRide.getUser().getFullName() : "N/A" %>
                                </div>
                                <div class="small text-secondary">
                                    <strong>Time:</strong> <%= returnRide.getTravelDateTime() != null ? returnRide.getTravelDateTime().toString().replace("T", " ") : "N/A" %>
                                </div>
                            </div>
                        </div>
                        <% } %>

                    </div>

                    <!-- Card Footer -->
                    <div class="mt-3 pt-3 border-top d-flex justify-content-between align-items-center flex-wrap gap-2">
                        <div class="text-muted small">
                            <div><strong>Driver:</strong> <%= (b.getDriver() != null && b.getDriver().getFullName() != null) ? b.getDriver().getFullName() : "Assigned" %></div>
                            <div><strong>Booked On:</strong> <%= b.getBookedAt() != null ? b.getBookedAt().toString().replace("T", " ") : "N/A" %></div>
                        </div>

                        <!-- Actions -->
                        <div>
                            <% if (isPassenger) { %>
                                <% if (!isPaid) { %>
                                    <form action="processPayment" method="get" class="d-inline">
                                        <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>" />
                                        <input type="hidden" name="amount" value="<%= myPayableShare %>" />
                                        <button type="submit" class="btn-pay shadow-sm">
                                            <i class="fa-solid fa-credit-card me-1"></i> Pay ₹<%= String.format("%.2f", myPayableShare) %>
                                        </button>
                                    </form>
                                <% } else { %>
                                    <button class="btn btn-sm btn-outline-success rounded-pill px-3" disabled>
                                        <i class="fa-solid fa-circle-check me-1"></i> Paid
                                    </button>
                                <% } %>
                            <% } else { %>
                                <button class="btn btn-sm btn-outline-primary rounded-pill px-3" onclick="alert('Calling passenger...')">
                                    <i class="fa-solid fa-phone me-1"></i> Contact Passenger
                                </button>
                            <% } %>
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div class="col-12 text-center py-5">
            <i class="fa-solid fa-route fa-3x text-muted mb-3"></i>
            <h5 class="text-secondary">No booked rides available</h5>
            <p class="text-muted small">Confirmed bookings will appear here.</p>
        </div>
        <%
            }
        %>
    </div>

</div>

</body>
</html>