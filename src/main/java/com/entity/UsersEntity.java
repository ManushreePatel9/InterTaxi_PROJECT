package com.entity;

import java.time.LocalDateTime;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

@Entity
@Getter
@Setter

@Table(name="users")
@FieldDefaults(level = AccessLevel.PRIVATE)

public class UsersEntity {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY) // auto increment PK
	Integer userId;
	String fullName;
	
	@Column(unique = true, nullable = false)
	String email;
	
	String phoneNumber;
	String password;
	String role;
	LocalDateTime createdAt;
	@PrePersist
	void onCreate() {
		createdAt = LocalDateTime.now();
	}
	
	@OneToMany(mappedBy = "user")
    List<BookRideEntity> rideRequests;
}
