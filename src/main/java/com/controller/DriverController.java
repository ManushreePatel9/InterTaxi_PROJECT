package com.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.entity.BookRideEntity;
import com.entity.BookedRidesEntity;
import com.entity.UsersEntity;
import com.repository.RideRepo; // Correct Repository for BookRideEntity
import com.repository.BookedRidesRepo;
import com.repository.UsersRepo;
import com.service.RideMatchingService;
import com.service.RideMatchingService.MatchedRideDetail;

import jakarta.servlet.http.HttpSession;

@Controller
public class DriverController {

    // FIXED: Changed type from BookedRidesRepo to RideRepo
    @Autowired
    private RideRepo rideRepo;

    @Autowired
    private BookedRidesRepo bookedRidesRepo;

    @Autowired
    private UsersRepo userRepo;

    @Autowired
    private RideMatchingService rideMatchingService;

    @GetMapping("/driverDashboard")
    public String driverDashboard(Model model) {

        List<BookRideEntity> allRides = rideRepo.findAll();

        List<BookRideEntity> unmatchedRides = new ArrayList<>();
        Map<Integer, List<MatchedRideDetail>> matchedRidesMap = new HashMap<>();
        Map<Integer, BookRideEntity> forwardRideEntityMap = new HashMap<>();
        Map<Integer, String> unmatchedKmMap = new HashMap<>();
        Map<Integer, String> unmatchedFareMap = new HashMap<>();
        Map<Integer, String> unmatchedTimeMap = new HashMap<>();

        for (BookRideEntity ride : allRides) {
            
            // Only process rides which are pending
            if (!"PENDING".equalsIgnoreCase(ride.getStatus()) && !"pending".equalsIgnoreCase(ride.getStatus())) {
                continue;
            }

            List<MatchedRideDetail> matches = rideMatchingService.getMatchedRides(ride.getRequestId());

            if (matches != null && !matches.isEmpty()) {
                matchedRidesMap.put(ride.getRequestId(), matches);
                forwardRideEntityMap.put(ride.getRequestId(), ride);
            } else {
                unmatchedRides.add(ride);

                double km = rideMatchingService.calculateDistanceInKm(
                        ride.getPickupLat(), ride.getPickupLng(),
                        ride.getDropLat(), ride.getDropLng()
                );
                double roundedKm = Math.round(km * 100.0) / 100.0;
                long travelMins = Math.max(30, (long) roundedKm);
                float fare = Math.round(roundedKm * 12.0f);

                unmatchedKmMap.put(ride.getRequestId(), roundedKm + " KM");
                unmatchedFareMap.put(ride.getRequestId(), "₹" + fare);
                unmatchedTimeMap.put(ride.getRequestId(), rideMatchingService.formatMinsToHoursMins(travelMins));
            }
        }

        model.addAttribute("unmatchedRides", unmatchedRides);
        model.addAttribute("matchedRidesMap", matchedRidesMap);
        model.addAttribute("forwardRideEntityMap", forwardRideEntityMap);
        model.addAttribute("unmatchedKmMap", unmatchedKmMap);
        model.addAttribute("unmatchedFareMap", unmatchedFareMap);
        model.addAttribute("unmatchedTimeMap", unmatchedTimeMap);

        return "DriverDashboard";
    }

    // 1. MATCHED PAIR BOOKING POST ACTION
    @PostMapping("/acceptMatchedRide")
    public String acceptMatchedRide(
            @RequestParam("forwardRequestId") Integer forwardRequestId,
            @RequestParam("selectedReturnRequestId") Integer returnRequestId,
            @RequestParam("totalFare") Float totalFare,
            HttpSession session) {

        Integer driverId = (session.getAttribute("driverId") != null) ? (Integer) session.getAttribute("driverId") : 1;
        UsersEntity driver = userRepo.findById(driverId).orElse(null);

        BookRideEntity forwardRide = rideRepo.findById(forwardRequestId).orElse(null);
        BookRideEntity returnRide = rideRepo.findById(returnRequestId).orElse(null);

        if (driver != null && forwardRide != null && returnRide != null) {
            
            BookedRidesEntity booking = new BookedRidesEntity();
            booking.setDriver(driver);              // Driver FK
            booking.setForwardRide(forwardRide);    // Forward Ride FK
            booking.setReturnRide(returnRide);      // Return Ride FK
            booking.setBookingType("MATCHED_PAIR");
            booking.setTotalFare(totalFare);
            booking.setStatus("CONFIRMED");

            bookedRidesRepo.save(booking);

            // Update statuses to BOOKED in rideRequests table
            forwardRide.setStatus("BOOKED");
            rideRepo.save(forwardRide);

            returnRide.setStatus("BOOKED");
            rideRepo.save(returnRide);
        }

        return "redirect:/driverDashboard";
    }

    // 2. SINGLE RIDE BOOKING POST ACTION
    @PostMapping("/acceptSingleRide")
    public String acceptSingleRide(
            @RequestParam("requestId") Integer requestId,
            HttpSession session) {

        Integer driverId = (session.getAttribute("driverId") != null) ? (Integer) session.getAttribute("driverId") : 1;
        UsersEntity driver = userRepo.findById(driverId).orElse(null);

        BookRideEntity ride = rideRepo.findById(requestId).orElse(null);

        if (driver != null && ride != null) {
            
            double km = rideMatchingService.calculateDistanceInKm(
                    ride.getPickupLat(), ride.getPickupLng(),
                    ride.getDropLat(), ride.getDropLng()
            );
            float singleFare = Math.round(km * 12.0f);

            BookedRidesEntity booking = new BookedRidesEntity();
            booking.setDriver(driver);              // Driver FK
            booking.setForwardRide(ride);           // Forward Ride FK
            booking.setReturnRide(null);            // NULL for single trip
            booking.setBookingType("SINGLE_TRIP");
            booking.setTotalFare(singleFare);
            booking.setStatus("CONFIRMED");

            bookedRidesRepo.save(booking);

            // Update status in rideRequests table
            ride.setStatus("BOOKED");
            rideRepo.save(ride);
        }

        return "redirect:/driverDashboard";
    }
}