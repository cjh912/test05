package com.example.TF.service;

//import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TF.dao.Movie_MemberDAO;
import com.example.TF.dao.Movie_admin_board_DAO;
import com.example.TF.dao.Movie_inquiry_board_DAO;
import com.example.TF.dao.Movie_notice_board_DAO;
import com.example.TF.dao.Movie_qna_board_DAO;
import com.example.TF.dao.Movie_store_board_DAO;
import com.example.TF.dao.Movie_theater_DAO;
import com.example.TF.dao.Movie_theater_screen_DAO;
import com.example.TF.dao.Movie_user_qna_board_DAO;
import com.example.TF.dto.Movie_MemberDTO;
import com.example.TF.entity.Movie_Member;
import com.example.TF.entity.Movie_admin_board;
import com.example.TF.entity.Movie_inquiry_board;
import com.example.TF.entity.Movie_notice_board;
import com.example.TF.entity.Movie_qna_board;
import com.example.TF.entity.Movie_store_board;
import com.example.TF.entity.Movie_theater;
import com.example.TF.entity.Movie_theater_screen;
import com.example.TF.entity.Movie_user_qna_board;

@Service
public class Movie_service {
	
	// 공지 게시판
	@Autowired
	Movie_admin_board_DAO admin_dao;
	
	// 자주찾는질문
	@Autowired
	Movie_qna_board_DAO qna_dao;
	
	// 스토어
	@Autowired
	Movie_store_board_DAO store_dao;
	
	// 회원
	@Autowired
	Movie_MemberDAO member_dao;
	
	// 문의
	@Autowired
	Movie_inquiry_board_DAO inquiry_dao;
	
	// 공지(회원)
	@Autowired
	Movie_notice_board_DAO notice_dao;
	
	// 자주찾는질문(회원)
	@Autowired
	Movie_user_qna_board_DAO user_qna_dao;
	
	// 극장
	@Autowired
	Movie_theater_DAO theater_dao;
	
	// 상영관
	@Autowired
	Movie_theater_screen_DAO screen_dao;
	
	// 공지
	
	// 목록 보기
	public List<Movie_admin_board> admin_board_list(int startNum, int endNum) {
		return admin_dao.admin_board_list(startNum, endNum);
	}
	
	// 총글수
	public int admin_get_count() {
		return admin_dao.get_count();
	}
	
	// 글쓰기
	public Movie_admin_board admin_board_write(Movie_admin_board board) {
		return admin_dao.admin_board_write(board);
	}
	
	// 상세보기 
	public Movie_admin_board admin_board_view(int seq) {
		return admin_dao.admin_board_view(seq);
	}
	
	// 글 수정
	public int admin_board_modify(Movie_admin_board board) {
		return admin_dao.admin_board_modify(board);
	}
	
	// 글 삭제
	public int admin_board_delete(int seq) {
		return admin_dao.admin_board_delete(seq);
	}
	
	// qna
	
	// 전체 목록 보기
	public List<Movie_qna_board> qna_list(int startNum, int endNum) {
		return qna_dao.qna_list(startNum, endNum);
	}
	
	// 총글수
	public int qna_get_count() {
		return qna_dao.get_count();
	}
	
	// 항목별 글수
	public int qna_get_count_section(String section) {
		return qna_dao.get_count_section(section);
	}
	
	// 개별 목록 보기
	public List<Movie_qna_board> qna_list_section(String section, int startNum, int endNum) {
		return qna_dao.qna_list_section(section, startNum, endNum);
	}
	
	// 글쓰기
	public Movie_qna_board qna_board_write(Movie_qna_board board) {
		return qna_dao.qna_board_write(board);
	}
	
	// 글 보기
	public Movie_qna_board qna_board_view(int seq) {
		return qna_dao.qna_board_view(seq);
	}
	
	// 글 수정
	public int qna_board_modify(Movie_qna_board board) {
		return qna_dao.qna_board_modify(board);
	}
	
	// 글 삭제
	public int qna_board_delete(int seq) {
		return qna_dao.qna_board_delete(seq);
	}
	
	// 스토어
	
	// 글쓰기
	public Movie_store_board store_board_write(Movie_store_board board) {
		return store_dao.store_board_write(board);
	}
	
	// 목록
	public List<Movie_store_board> store_board_list(int startNum, int endNum) {
		return store_dao.store_board_list(startNum, endNum);
	}
	
	// 총글수
	public int store_get_count() {
		return store_dao.get_count();
	}
	
	// 상세보기
	public Movie_store_board store_board_view(int seq) {
		return store_dao.store_board_view(seq);
	}
	
	// 수정
	public int store_board_modify(Movie_store_board board) {
		return store_dao.store_board_modify(board);
	}
	
	// 삭제
	public int store_board_delete(int seq) {
		return store_dao.store_board_delete(seq);
	}
	
	// 로그인 & 회원
	
	// 로그인
	public Movie_Member member_login(String id, String pwd) {
		return member_dao.login(id, pwd); 
	}
	
	// 회원정보 저장
	public Movie_Member member_write(Movie_MemberDTO dto) {
		return member_dao.write(dto);
	}
	
	// id 중복검사
	public boolean member_isExistId(String id) {
		return member_dao.isExistId(id);
	}
	
	// 1명의 회원정보읽기
	public Movie_Member member_getMember(String id) {
		return member_dao.getMember(id);
	}
	
	// 수정하기
	public boolean member_modify(Movie_MemberDTO dto) {
		return member_dao.modify(dto);
	}
	
	// 문의내역 관리
	
	// 목록 보기
	public List<Movie_inquiry_board> inquiry_list(int startNum, int endNum) {
		return inquiry_dao.inquiry_list(startNum, endNum);
	}
	
	// 총글수
	public int inquiry_get_count() {
		return inquiry_dao.get_count();
	}
	
	// 유형별 목록 보기
	public List<Movie_inquiry_board> inquiry_list_type(String inquiry_type,
			int startNum, int endNum) {
		return inquiry_dao.inquiry_list_type(inquiry_type, startNum, endNum);
	}
	
	// 유형별 글수
	public int inquiry_get_count_type(String inquiry_type) {
		return inquiry_dao.get_count_type(inquiry_type);
	}
	
	// 상태별 목록
	public List<Movie_inquiry_board> inquiry_list_stat(String inquiry_stat,
			int startNum, int endNum) {
		return inquiry_dao.inquiry_list_stat(inquiry_stat, startNum, endNum);
	}
	
	// 상태별 글수
	public int get_count_stat(String inquiry_stat) {
		return inquiry_dao.get_count_stat(inquiry_stat);
	}
	
	////////// 공지 ///////////
	
	// 목록 보기
	public List<Movie_notice_board> notice_board_list(int startNum, int endNum) {
		return notice_dao.notice_board_list(startNum, endNum);
	}
	
	// 총글수
	public int notice_get_count() {
		return notice_dao.get_count();
	}
		
	// 상세보기 
	public Movie_notice_board notice_board_view(int seq) {
		return notice_dao.notice_board_view(seq);
	}	
	
	////////// 자주찾는 질문(회원) /////////
	
	// 전체 목록 보기
	public List<Movie_user_qna_board> user_qna_list(int startNum, int endNum) {
		return user_qna_dao.qna_list(startNum, endNum);
	}
	
	// 총글수
	public int user_qna_get_count() {
		return user_qna_dao.get_count();
	}
	
	// 항목별 글수
	public int user_qna_get_count_section(String section) {
		return user_qna_dao.get_count_section(section);
	}
	
	// 개별 목록 보기
	public List<Movie_user_qna_board> user_qna_list_section(String section, int startNum, int endNum) {
		return user_qna_dao.qna_list_section(section, startNum, endNum);
	}
	
	// 글 보기
	public Movie_user_qna_board user_qna_board_view(int seq) {
		return user_qna_dao.qna_board_view(seq);
	}
	
	// 극장 관리
	
	// 글쓰기
	public Movie_theater theater_write(Movie_theater theater) {
		return theater_dao.theater_write(theater);
	}
	
	// 목록
	public List<Movie_theater> theater_list(int startNum, int endNum) {
		return theater_dao.theater_list(startNum, endNum);
	}
	
	// 총글수
	public int theater_get_count() {
		return theater_dao.get_count();
	}
	
	// 상세보기
	public Movie_theater theater_view(int seq) {
		return theater_dao.theater_view(seq);
	}
	
	// 삭제
	public int theater_delete(int seq) {
		// 1. 기존 데이터 가져오기
		return theater_dao.theater_delete(seq);
	}
	
	// 수정
	public int theater_modify(Movie_theater theater) {
		return theater_dao.theater_modify(theater);
	}
	
	// 상영관 관리
	
	// 글쓰기
	public int screen_write(Movie_theater_screen screen) {
		return screen_dao.screen_write(screen);
	}
	
	// 목록

	public List<Movie_theater_screen> screen_list(
			int theater_code, int startNum, int endNum) {
		return screen_dao.screen_list(theater_code, startNum, endNum);
	}
	
	public List<Movie_theater_screen> screen_list_test(
			int startNum, int endNum) {
		return screen_dao.screen_list_test(startNum, endNum);
	}	
	
	// 총글수
	public int screen_get_count() {
		return screen_dao.get_count();
	}
	
	// 상세보기
	public Movie_theater_screen screen_view(int screen_num, int theater_code) {
		return screen_dao.screen_view(screen_num, theater_code);
	}
	
	// 수정
	public int screen_modify(Movie_theater_screen screen) {
		return screen_dao.screen_modify(screen);
	}
	
	// 삭제
	public int screen_delete(int screen_num, int theater_code) {
		return screen_dao.screen_delete(screen_num, theater_code);
	}	
}
