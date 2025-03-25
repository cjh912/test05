package com.example.TF.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.TF.entity.Movie_notice_board;
import com.example.TF.repository.Movie_notice_board_repository;

@Repository
public class Movie_notice_board_DAO {

	@Autowired
	Movie_notice_board_repository notice_repository;
	
	// 목록 보기
	public List<Movie_notice_board> notice_board_list(int startNum, int endNum) {
		return notice_repository.findByStartnumAndEndnum(startNum, endNum);
	}
	
	// 총글수
	public int get_count() {
		return (int)notice_repository.count();
	}
	
	// 상세보기 
	public Movie_notice_board notice_board_view(int seq) {
		return notice_repository.findById(seq).orElse(null);
	}
	
}
