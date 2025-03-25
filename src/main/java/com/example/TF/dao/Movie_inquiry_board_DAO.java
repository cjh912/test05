package com.example.TF.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.TF.entity.Movie_inquiry_board;
import com.example.TF.repository.Movie_inquiry_repository;

@Repository
public class Movie_inquiry_board_DAO {
	
	@Autowired
	Movie_inquiry_repository inquiry_repository;
	
	// 목록 보기
	public List<Movie_inquiry_board> inquiry_list(int startNum, int endNum) {
		return inquiry_repository.findByStartnumAndEndnum(startNum, endNum);
	}
	
	// 총글수
	public int get_count() {
		return (int)inquiry_repository.count();
	}
	
	// 유형별 목록 보기
	public List<Movie_inquiry_board> inquiry_list_type(String inquiry_type,
			int startNum, int endNum) {
		return inquiry_repository.findByStartnumAndEndnum_type(inquiry_type, startNum, endNum);
	}
	
	// 유형별 글수
	public int get_count_type(String inquiry_type) {
		return (int)inquiry_repository.count_type(inquiry_type);
	}
	
	// 상태별 목록
	public List<Movie_inquiry_board> inquiry_list_stat(String inquiry_stat,
			int startNum, int endNum) {
		return inquiry_repository.findByStartnumAndEndnum_stat(inquiry_stat, startNum, endNum);
	}
	
	// 상태별 글수
	public int get_count_stat(String inquiry_stat) {
		return (int)inquiry_repository.count_stat(inquiry_stat);
	}
}
