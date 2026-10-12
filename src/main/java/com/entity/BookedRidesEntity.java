package com.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

@Entity
@Getter
@Setter
@Table(name = "bookedRides")
@FieldDefaults(level = AccessLevel.PRIVATE)
public class BookedRidesEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int bookingId;

    // Driver FK Mapping
    @ManyToOne
    @JoinColumn(name = "driverId", nullable = false)
    UsersEntity driver;

    // Primary/Forward Ride FK Mapping
    @ManyToOne
    @JoinColumn(name = "forwardRequestId", nullable = false)
    BookRideEntity forwardRide;

    // Matched Return Ride FK Mapping (Single trip me NULL allowed)
    @ManyToOne
    @JoinColumn(name = "returnRequestId", nullable = true)
    BookRideEntity returnRide;

    String bookingType;          // "MATCHED_PAIR" ya "SINGLE_TRIP"
    Float totalFare;             // Total Earnings
    String status = "CONFIRMED"; // Status: CONFIRMED / COMPLETED / CANCELLED
    LocalDateTime bookedAt;

    @PrePersist
    void onCreate() {
        bookedAt = LocalDateTime.now();
    }
}