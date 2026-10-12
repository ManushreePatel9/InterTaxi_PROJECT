package com.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import jakarta.servlet.http.HttpSession;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

@Entity
@Getter
@Setter
@Table(name = "rideRequests")
@FieldDefaults(level = AccessLevel.PRIVATE)

public class BookRideEntity {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY) // auto increment PK
	int requestId;
	
	
	//FK
	@ManyToOne
    @JoinColumn(name = "userId")
    UsersEntity user;
	
	
	String pickupLocation;
	String dropLocation;
	
	Float pickupLat;
	Float pickupLng;
	Float dropLat;
	Float dropLng;
	
	LocalDateTime travelDateTime;
	LocalDateTime maxWaitUntil;
	
	Integer passengerCount;
	Float estimatedFare;
	String status = "pending";
	LocalDateTime createdAt;
	
	@PrePersist
	void onCreate() {
		createdAt = LocalDateTime.now();
	}	
	
}
