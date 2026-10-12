package com.service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.entity.BookRideEntity;
import com.repository.RideRepo;

@Service
public class RideMatchingService {

    @Autowired
    private RideRepo rideRepo;

    private static final float RATE_PER_KM = 12.0f; // Standard Rate: ₹12 per KM
    private static final float MATCHED_DISCOUNT_PERCENTAGE = 0.20f; // 20% Discount on Return Ride for Matched Pair

    // Record Definition with Formatted Time strings
    public record MatchedRideDetail(
        BookRideEntity returnRide,
        float requestId,
        float forwardKM,
        float returnKM,
        float minsToReachDestination,
        float waitingTimeInMins,
        String formattedWaitingTime,       // e.g., "1 Hour 59 Mins" or "45 Mins"
        String formattedTravelTime,        // e.g., "13 Hours 1 Min"
        float forwardFare,                 // Full standard fare
        float returnFareOriginal,          // Without discount fare
        float returnFareDiscounted,        // Discounted return fare
        float totalEarnings                // forwardFare + returnFareDiscounted
    ) {}

    public List<MatchedRideDetail> getMatchedRides(Integer forwardRequestId) {

        BookRideEntity forwardRide = rideRepo.findById(forwardRequestId).orElse(null);
        if (forwardRide == null) {
            return new ArrayList<>();
        }

        // Forward Distance & Minutes
        float forwardRideKM = (float) calculateDistanceInKm(
                forwardRide.getPickupLat(), forwardRide.getPickupLng(),
                forwardRide.getDropLat(), forwardRide.getDropLng()
        );

        float minsToReachDestination = forwardRideKM; // 1 KM = 1 Min rule
        if (minsToReachDestination < 30.0f) {
            minsToReachDestination = 30.0f;
        }

        LocalDateTime forwardReachTime = forwardRide.getTravelDateTime().plusMinutes((long) minsToReachDestination);
        float forwardFare = Math.round(forwardRideKM * RATE_PER_KM);

        List<BookRideEntity> rides = rideRepo.findPotentialReturnMatches(forwardRequestId);
        List<MatchedRideDetail> matchedRidesList = new ArrayList<>();

        for (BookRideEntity returnRide : rides) {

            LocalDateTime returnDeparture = returnRide.getTravelDateTime();
            long waitMinutesLong = Duration.between(forwardReachTime, returnDeparture).toMinutes();

            if (waitMinutesLong >= 0 && waitMinutesLong <= 1440) {

                float waitingTimeInMins = (float) waitMinutesLong;

                float returnRideKM = (float) calculateDistanceInKm(
                        returnRide.getPickupLat(), returnRide.getPickupLng(),
                        returnRide.getDropLat(), returnRide.getDropLng()
                );

                // Discounted pricing calculation for return passenger match
                float returnFareOriginal = Math.round(returnRideKM * RATE_PER_KM);
                float returnFareDiscounted = Math.round(returnFareOriginal * (1.0f - MATCHED_DISCOUNT_PERCENTAGE));

                MatchedRideDetail detail = new MatchedRideDetail(
                        returnRide,
                        returnRide.getRequestId(),
                        Math.round(forwardRideKM * 100.0f) / 100.0f,
                        Math.round(returnRideKM * 100.0f) / 100.0f,
                        minsToReachDestination,
                        waitingTimeInMins,
                        formatMinsToHoursMins((long) waitingTimeInMins),
                        formatMinsToHoursMins((long) minsToReachDestination),
                        forwardFare,
                        returnFareOriginal,
                        returnFareDiscounted,
                        forwardFare + returnFareDiscounted
                );

                matchedRidesList.add(detail);
            }
        }

        // Sort by waiting time
        matchedRidesList.sort((r1, r2) -> Float.compare(r1.waitingTimeInMins(), r2.waitingTimeInMins()));

        return matchedRidesList;
    }

    // Distance Calculation Formula (Haversine)
    public double calculateDistanceInKm(Float lat1, Float lon1, Float lat2, Float lon2) {
        if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return 0.0;
        double R = 6371; // Earth radius in KM
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(Math.toRadians(lat1))
                * Math.cos(Math.toRadians(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    // Helper: Convert Minutes to "X Hours Y Mins" format
    public String formatMinsToHoursMins(long totalMinutes) {
        if (totalMinutes < 60) {
            return totalMinutes + " Mins";
        }
        long hours = totalMinutes / 60;
        long mins = totalMinutes % 60;
        if (mins == 0) {
            return hours + " Hours";
        }
        return hours + " Hours " + mins + " Mins";
    }
}