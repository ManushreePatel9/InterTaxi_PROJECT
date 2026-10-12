package com.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.entity.UsersEntity;
import com.repository.UsersRepo;

import jakarta.servlet.http.HttpSession;

@Controller
public class SessionController {
	
	@Autowired 
	UsersRepo usersRepo;
	
	@GetMapping("/")
	public String root() {
		return "Signup";
	}
	
	@GetMapping("login")
	public String login() {
		return "Login";
	}

	@PostMapping("addUser")
	public String addUser(UsersEntity user , Model model) {
		System.out.println("Signup controller called");
		try {
			usersRepo.save(user);	
			System.out.println("user add successfully!!");

		}catch(Exception e) {
			model.addAttribute("msg" , "Email already exists");
			return "Signup";
		}
		
		return "Login";
	}
	
	@PostMapping("/login")
	public String login(String email,String password ,HttpSession session) {
		
		Optional<UsersEntity> op = usersRepo.findByEmailAndPassword(email, password);
		
		if(op.isPresent()) {
			System.out.println("Logged in successfully");
			UsersEntity user = op.get();
			session.setAttribute("user", user);

			if(user.getRole().equalsIgnoreCase("passenger") ) {
				
				return "BookRide";
			}else if(user.getRole().equalsIgnoreCase("driver") ) {
				return "redirect:/driverDashboard";
			}else {
				// Admin dashboard
			}
			
		}
		
		return "";
	}
	
	
	
}
