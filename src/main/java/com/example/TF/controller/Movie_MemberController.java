package com.example.TF.controller;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.TF.dto.Movie_MemberDTO;
import com.example.TF.entity.Movie_Member;
import com.example.TF.service.Movie_service;

import jakarta.servlet.http.HttpSession;

@Controller
public class Movie_MemberController {
	
	@Autowired
	Movie_service service;
	
	@GetMapping("/customerServiceMain")
	public String customerServiceMain(Model model, HttpSession session) {
		
		// 2. 데이터 공유
		model.addAttribute("req2", "none");
		
		// 3. view 파일명 리턴
		return "/main/customerServiceMain";
		
	}	
	
	
	@GetMapping("/mypageMain")	// mypage가기
	public String mypage(Model model, Movie_MemberDTO dto, HttpSession session) {
		// 1. 데이터 처리
		String id = (String)session.getAttribute("memId");
		// 회원정보 읽기
		Movie_Member member = service.member_getMember(id);
		// 2. 데이터 공유
		model.addAttribute("member", member);
		model.addAttribute("req", "none");
		return "/main/mypageMain";
	}	
	
	// http://localhost:8080/main
	@GetMapping("/main")	// 메인가기
	public String index() {
		return "/main/main";
	}
	
	// http://localhost:8080/member/loginForm
	@GetMapping("/member/loginForm")	// 로그인폼
	public String loginForm() {
		return "/member/loginForm";
	}
	
	@PostMapping("/member/login")
	public String login(Movie_MemberDTO dto, HttpSession session) {
		// db
		Movie_Member member = service.member_login(dto.getId(), dto.getPwd());
		// 2. 데이터 공유
		// 3. view 파일명 리턴
		if(member != null) { // 로그인 성공
			session.setAttribute("memId", member.getId());
			session.setAttribute("memName", member.getName());
			session.setAttribute("loggedIn", true); // ✅ 추가: 로그인 상태 저장 (수민)
			return "/member/loginOK";	// /member/loginOK.html
		} else {			// 로그인 실패
			return "/member/loginFail";	// /member/loginFail.html(수민)
		} 
	}
	
	@GetMapping("/member/logout")
	public String logout(HttpSession session) {
		// 1. 데이터 처리
		session.removeAttribute("memId");
		session.removeAttribute("memName");
		session.removeAttribute("loggedIn"); // ✅ 추가 (수민)
		// 2. 데이터 공유
		// 3. view 파일명 리턴
		return "/member/logout"; // /member/logout.html
	}
	
	@GetMapping("/member/writeForm")
	public String writeForm() {
		// 1. 데이터 처리
		// 2. 데이터 공유
		// 3. view 파일명 리턴
		return "/member/writeForm"; // /member/writeForm.html
	}
	
	@PostMapping("/member/write")
	public String write(Movie_MemberDTO dto, Model model) {
		// 1. 데이터 처리
		dto.setLogtime(new Date());
		// db
		Movie_Member member = service.member_write(dto);
		// 2. 데이터 공유
		model.addAttribute("member",member);
		// 3. view 파일명 리턴
		return "/member/write"; // /member/write.html
	}
	
	@GetMapping("/member/checkId")
	public String checkId(@RequestParam("id") String id, Model model) {
		// 1. 데이터 처리
		// db
		boolean result = service.member_isExistId(id);
		// 2. 데이터 공유
		model.addAttribute("id", id);
		model.addAttribute("result", result);
		// 3. view 파일명 리턴
		return "/member/checkId"; // /member/checkId
	}
	
	@GetMapping("/member/modifyForm")
	public String modifyForm(HttpSession session, Model model) {
		// 1. 데이터 처리
		String id = (String)session.getAttribute("memId");
		// 회원정보 읽기
		Movie_Member member = service.member_getMember(id);
		// 2. 데이터 공유
		model.addAttribute("member", member);
		model.addAttribute("req", "/member/modifyForm");
		// 3. view 파일명 리턴
		return "/main/mypageMain"; 
	}
	
	@PostMapping("/member/modify")
	public String modify(Movie_MemberDTO dto, Model model) {
		// 1. 데이터 처리		
		// db
		boolean result = service.member_modify(dto);
		System.out.println("result = "+ result);
		// 2. 데이터 공유
		model.addAttribute("result", result);
		// 3. view 파일명 리턴
		return "/member/modify"; // /member/modify.html
	}	
}
