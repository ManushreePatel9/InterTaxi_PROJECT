package com.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;

import com.entity.BookRideEntity;
import com.entity.UsersEntity;
import com.repository.RideRepo;

import jakarta.servlet.http.HttpSession;

@Controller
public class RideController {
	
	@Autowired
	RideRepo rideRepo;
		
	@PostMapping("saveRideRequest")
	public String saveRideRequest(BookRideEntity ride,Model model , HttpSession session) {
		
		UsersEntity user = (UsersEntity) session.getAttribute("user");
		ride.setUser(user);
		ride.setStatus("pending");
		rideRepo.save(ride);
		System.out.println("Ride saved");
		return "";
	}
}
