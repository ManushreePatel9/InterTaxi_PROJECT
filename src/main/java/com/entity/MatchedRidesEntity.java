package com.entity;

import org.springframework.stereotype.Controller;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "matchedRides")
@Getter
@Setter
public class MatchedRidesEntity {
	
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "matchId")
    private Integer matchId;

    // Foreign Key 1: Forward Ride Request (e.g., Ahmedabad -> Mumbai)
    @OneToOne
    @JoinColumn(name = "forwardRideId")
    private BookRideEntity forwardRide;

    // Foreign Key 2: Return Ride Request (e.g., Mumbai -> Ahmedabad)
    @OneToOne
    @JoinColumn(name = "returnRideId")
    private BookRideEntity returnRide;

    // Foreign Key 3: Driver who accepted this combo
    @ManyToOne
    @JoinColumn(name = "driverId", nullable = false)
    private UsersEntity driver;

    @Column(name = "waitTimeHours")
    private Float waitTimeHours;

    @Column(name = "totalFare")
    private Float totalFare;

    @Column(name = "status")
    private String status = "CONFIRMED"; // Default status

    @Column(name = "createdAt")
    private LocalDateTime createdAt;
    
    @PrePersist
    void addTime() {
    	this.createdAt = LocalDateTime.now();
    }
}
