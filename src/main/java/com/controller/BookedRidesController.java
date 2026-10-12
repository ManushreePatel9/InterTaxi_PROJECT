package com.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.entity.BookedRidesEntity;
import com.entity.UsersEntity;
import com.repository.BookedRidesRepo;

import jakarta.servlet.http.HttpSession;

@Controller
public class BookedRidesController {

    @Autowired
    private BookedRidesRepo bookedRidesRepo;

    // 1. Driver Dashboard ke button ke liye controller action
    @GetMapping("/viewDriverBookedRides")
    public String viewDriverBookedRides(HttpSession session, Model model) {

        // Session se logged-in driver ki ID fetch karein (fallback default = 1)
        Integer driverId = (session.getAttribute("driverId") != null) ? (Integer) session.getAttribute("driverId") : 
                          (session.getAttribute("userId") != null) ? (Integer) session.getAttribute("userId") : 1;

        List<BookedRidesEntity> bookedRides = bookedRidesRepo.findBookedRidesForDriver(driverId);

        model.addAttribute("bookedRides", bookedRides);
        model.addAttribute("userRole", "DRIVER");
        model.addAttribute("backUrl", "driverDashboard");

        return "ViewBookedRides";
    }

    // 2. Passenger Dashboard ke button ke liye controller action
    @GetMapping("/viewPassengerBookedRides")
    public String viewPassengerBookedRides(HttpSession session, Model model) {
System.out.println("Passenger booked view rides controller calles");
        // Session se logged-in passenger ki ID fetch karein (fallback default = 1)
//        Integer passengerId = (session.getAttribute("userId") != null) ? (Integer) session.getAttribute("userId") : 1;
		UsersEntity passenger = (UsersEntity) session.getAttribute("user");
		int passengerId = passenger.getUserId();
        System.out.println("LOGGED IN PASSENGER ID ===> " + passengerId);
        List<BookedRidesEntity> bookedRides = bookedRidesRepo.findBookedRidesForPassenger(passengerId);

        model.addAttribute("bookedRides", bookedRides);
        model.addAttribute("userRole", "PASSENGER");
        model.addAttribute("loggedInUserId", passengerId); // PASSING LOGGED IN USER ID TO JSP
        model.addAttribute("backUrl", "passengerDashboard");

        return "ViewBookedRides";
    }
}