<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.entity.BookRideEntity" %>
<%@ page import="com.service.RideMatchingService.MatchedRideDetail" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Driver Dashboard - Ride Matcher</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body { background-color: #f3f4f6; font-family: 'Inter', sans-serif; color: #334155; }
        .dashboard-header { background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); color: #ffffff; border-radius: 16px; padding: 24px; margin-bottom: 30px; }
        .ride-group-card { background: #ffffff; border-radius: 16px; border: 1px solid #e2e8f0; margin-bottom: 28px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.03); }
        .forward-banner { background: #f8fafc; border-bottom: 2px solid #e2e8f0; padding: 20px 24px; }
        .badge-forward { background-color: #0284c7; color: white; font-weight: 600; padding: 6px 12px; border-radius: 20px; font-size: 0.8rem; }
        .metric-pill { background-color: #ffffff; border: 1px solid #cbd5e1; border-radius: 10px; padding: 10px 14px; text-align: center; }
        .metric-title { font-size: 0.72rem; text-transform: uppercase; color: #64748b; font-weight: 700; margin-bottom: 2px; }
        .metric-value { font-size: 0.92rem; font-weight: 700; color: #0f172a; }
        .match-option-card { background: #ffffff; border: 2px solid #e0f2fe; border-radius: 12px; padding: 20px; height: 100%; position: relative; cursor: pointer; }
        .match-option-card:hover { border-color: #0284c7; }
        .earning-box-matched { background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 10px; padding: 12px 16px; }
        .earning-box-single { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 12px 16px; }
        .btn-finalize { background-color: #16a34a; color: #ffffff; font-weight: 700; border-radius: 10px; padding: 12px 24px; border: none; }
        .btn-finalize:hover { background-color: #15803d; color: #ffffff; }
    </style>

    <script>
        function updateSelectedMatch(forwardId, returnId, fare) {
            document.getElementById('selectedReturnId_' + forwardId).value = returnId;
            document.getElementById('totalFare_' + forwardId).value = fare;
        }
    </script>
</head>
<body>

<div class="container py-4">

    <div class="dashboard-header d-flex justify-content-between align-items-center">
        <div>
            <h3 class="fw-bold mb-1"><i class="fa-solid fa-route text-info me-2"></i>Driver Ride Matching Engine</h3>
            <p class="mb-0 text-slate-300 small">Select & Finalize high-earning return ride pairs.</p>
        </div>
        <a href="driverDashboard" class="btn btn-sm btn-outline-light rounded-pill px-3"><i class="fa-solid fa-rotate me-1"></i> Refresh</a>
    </div>

    <%
        Map<Integer, List<MatchedRideDetail>> matchedRidesMap = (Map<Integer, List<MatchedRideDetail>>) request.getAttribute("matchedRidesMap");
        Map<Integer, BookRideEntity> forwardRideEntityMap = (Map<Integer, BookRideEntity>) request.getAttribute("forwardRideEntityMap");
        List<BookRideEntity> unmatchedRides = (List<BookRideEntity>) request.getAttribute("unmatchedRides");
        Map<Integer, String> unmatchedKmMap = (Map<Integer, String>) request.getAttribute("unmatchedKmMap");
        Map<Integer, String> unmatchedFareMap = (Map<Integer, String>) request.getAttribute("unmatchedFareMap");
        Map<Integer, String> unmatchedTimeMap = (Map<Integer, String>) request.getAttribute("unmatchedTimeMap");
    %>

    <!-- SECTION 1: MATCHED RETURN RIDES WITH SELECTION -->
    <div class="d-flex align-items-center mb-3">
        <h5 class="fw-bold m-0 text-dark"><i class="fa-solid fa-bolt text-warning me-2"></i>Available Return Match Bundles</h5>
        <span class="badge bg-success ms-2"><%= (matchedRidesMap != null) ? matchedRidesMap.size() : 0 %> Rides Matched</span>
    </div>

    <%
        if (matchedRidesMap != null && !matchedRidesMap.isEmpty()) {
            for (Map.Entry<Integer, List<MatchedRideDetail>> entry : matchedRidesMap.entrySet()) {
                Integer forwardRideId = entry.getKey();
                List<MatchedRideDetail> matches = entry.getValue();

                BookRideEntity forwardEntity = forwardRideEntityMap.get(forwardRideId);
                MatchedRideDetail firstRecord = matches.get(0);
    %>

        <div class="ride-group-card">
            
            <!-- FORWARD RIDE HEADER -->
            <div class="forward-banner">
                <div class="row align-items-center g-3">
                    <div class="col-lg-4">
                        <span class="badge-forward mb-2 d-inline-block">FORWARD RIDE #<%= forwardRideId %></span>
                        <div class="fw-bold text-dark small">
                            <i class="fa-solid fa-circle-dot text-success me-1"></i> Pickup: <%= forwardEntity.getPickupLocation() %>
                        </div>
                        <div class="fw-bold text-dark small mt-1">
                            <i class="fa-solid fa-location-dot text-danger me-1"></i> Drop: <%= forwardEntity.getDropLocation() %>
                        </div>
                    </div>
                    
                    <div class="col-lg-8">
                        <div class="row g-2">
                            <div class="col-6 col-sm-3">
                                <div class="metric-pill">
                                    <div class="metric-title">Forward KM</div>
                                    <div class="metric-value"><%= firstRecord.forwardKM() %> KM</div>
                                </div>
                            </div>
                            <div class="col-6 col-sm-3">
                                <div class="metric-pill">
                                    <div class="metric-title">Est. Travel Time</div>
                                    <div class="metric-value"><%= firstRecord.formattedTravelTime() %></div>
                                </div>
                            </div>
                            <div class="col-6 col-sm-3">
                                <div class="metric-pill">
                                    <div class="metric-title">Departure</div>
                                    <div class="metric-value"><%= forwardEntity.getTravelDateTime() != null ? forwardEntity.getTravelDateTime().toString().replace("T", " ") : "N/A" %></div>
                                </div>
                            </div>
                            <div class="col-6 col-sm-3">
                                <div class="metric-pill" style="border-color: #bbf7d0; background-color: #f0fdf4;">
                                    <div class="metric-title text-success">Forward Fare</div>
                                    <div class="metric-value text-success">₹<%= firstRecord.forwardFare() %></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- MATCH SELECTION FORM -->
            <form action="acceptMatchedRide" method="POST" class="p-4">
                <input type="hidden" name="forwardRequestId" value="<%= forwardRideId %>" />
                <!-- Hidden fields updated via Radio Selection JS -->
                <input type="hidden" id="selectedReturnId_<%= forwardRideId %>" name="selectedReturnRequestId" value="<%= firstRecord.returnRide().getRequestId() %>" />
                <input type="hidden" id="totalFare_<%= forwardRideId %>" name="totalFare" value="<%= firstRecord.totalEarnings() %>" />

                <h6 class="fw-bold text-secondary mb-3 small text-uppercase">
                    <i class="fa-solid fa-hand-pointer me-1"></i> Select Return Ride To Match With #<%= forwardRideId %>:
                </h6>

                <div class="row g-3">
                    <%
                        int count = 0;
                        for (MatchedRideDetail detail : matches) {
                            BookRideEntity returnRide = detail.returnRide();
                            count++;
                            boolean isChecked = (count == 1);
                    %>
                    <div class="col-lg-6">
                        <div class="match-option-card">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" 
                                           name="matchRadio_<%= forwardRideId %>" 
                                           id="radio_<%= returnRide.getRequestId() %>" 
                                           <%= isChecked ? "checked" : "" %> 
                                           onclick="updateSelectedMatch('<%= forwardRideId %>', '<%= returnRide.getRequestId() %>', '<%= detail.totalEarnings() %>')" />
                                    <label class="form-check-label fw-bold text-primary" for="radio_<%= returnRide.getRequestId() %>">
                                        Return Option #<%= returnRide.getRequestId() %>
                                    </label>
                                </div>
                                <span class="badge bg-primary-subtle text-primary fw-semibold">
                                    Wait: <%= detail.formattedWaitingTime() %>
                                </span>
                            </div>

                            <div class="small mb-3 text-secondary ps-4">
                                <div><strong>Return Pickup:</strong> <%= returnRide.getPickupLocation() %></div>
                                <div><strong>Return Drop:</strong> <%= returnRide.getDropLocation() %></div>
                            </div>

                            <div class="row g-2 text-center mb-3">
                                <div class="col-4">
                                    <div class="p-2 border rounded bg-light">
                                        <div class="metric-title">Return KM</div>
                                        <div class="fw-bold text-dark small"><%= detail.returnKM() %> KM</div>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="p-2 border rounded bg-light">
                                        <div class="metric-title">Total KM</div>
                                        <div class="fw-bold text-dark small"><%= (detail.forwardKM() + detail.returnKM()) %> KM</div>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="p-2 border rounded bg-light">
                                        <div class="metric-title">Departure</div>
                                        <div class="fw-bold text-dark small"><%= returnRide.getTravelDateTime() != null ? returnRide.getTravelDateTime().toString().replace("T", " ") : "N/A" %></div>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-2">
                                <div class="col-6">
                                    <div class="earning-box-single">
                                        <div class="metric-title">Single Trip</div>
                                        <div class="fw-bold text-slate-700">₹<%= detail.forwardFare() %></div>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="earning-box-matched">
                                        <div class="metric-title text-success">Matched Fare</div>
                                        <div class="fw-bold text-success">₹<%= detail.totalEarnings() %></div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>

                <div class="mt-4 d-flex justify-content-between align-items-center pt-3 border-top">
                    <div>
                        <span class="text-muted small">Selected pair will be finalized in <code>bookedRides</code> table.</span>
                    </div>
                    <button type="submit" class="btn-finalize">
                        <i class="fa-solid fa-lock me-1"></i> Finalize & Book Selected Match Pair
                    </button>
                </div>

            </form>

        </div>

    <%
            }
        }
    %>

    <!-- SECTION 2: STANDALONE / UNMATCHED RIDES -->
    <div class="d-flex align-items-center mb-3 mt-5">
        <h5 class="fw-bold m-0 text-dark"><i class="fa-solid fa-car me-2 text-secondary"></i>Standalone Single Rides</h5>
        <span class="badge bg-secondary ms-2"><%= (unmatchedRides != null) ? unmatchedRides.size() : 0 %> Pending</span>
    </div>

    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">Request ID</th>
                        <th>Pickup & Drop</th>
                        <th>Est. Distance</th>
                        <th>Est. Travel Time</th>
                        <th>Standard Fare</th>
                        <th>Departure Time</th>
                        <th class="text-end pe-4">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (unmatchedRides != null && !unmatchedRides.isEmpty()) {
                            for (BookRideEntity ride : unmatchedRides) {
                                int id = ride.getRequestId();
                    %>
                    <tr>
                        <td class="ps-4 fw-bold text-primary">#<%= id %></td>
                        <td>
                            <div class="small fw-semibold text-dark"><i class="fa-solid fa-circle-dot text-success me-1"></i> <%= ride.getPickupLocation() %></div>
                            <div class="small text-muted"><i class="fa-solid fa-location-dot text-danger me-1"></i> <%= ride.getDropLocation() %></div>
                        </td>
                        <td class="fw-bold text-dark"><%= unmatchedKmMap.get(id) %></td>
                        <td class="text-muted"><%= unmatchedTimeMap.get(id) %></td>
                        <td class="fw-bold text-success"><%= unmatchedFareMap.get(id) %></td>
                        <td><%= ride.getTravelDateTime() != null ? ride.getTravelDateTime().toString().replace("T", " ") : "N/A" %></td>
                        <td class="text-end pe-4">
                            <form action="acceptSingleRide" method="POST" class="d-inline">
                                <input type="hidden" name="requestId" value="<%= id %>" />
                                <button type="submit" class="btn btn-sm btn-dark px-3 rounded-2">
                                    Accept Single Ride
                                </button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="7" class="text-center py-4 text-muted">No standalone rides available.</td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<a href="viewDriverBookedRides" class="btn btn-sm btn-info text-white rounded-pill px-3 shadow-sm">
    <i class="fa-solid fa-bookmark me-1"></i> My Booked Rides
</a>

</body>
</html>