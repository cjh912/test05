package com.example.TF.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;


import com.example.TF.service.Seat_service;

@Controller
public class Screen_seat_controller {

	@Autowired
	private Seat_service screenService;
	
	
}
