package com.example.TF.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.example.TF.dto.Movie_reviewDTO;
import com.example.TF.entity.Movie_review;
import com.example.TF.repository.Movie_reviewRepository;

@Repository
public class Movie_reviewDAO {
	@Autowired
	Movie_reviewRepository movie_reviewRepository;
	
	// 목록 보기
	public List<Movie_review> review_list(int startNum, int endNum){
		return movie_reviewRepository.findByStartnumAndEndnum_logtime(startNum, endNum);
	}
	
	// 전체 리뷰수 조회
	public int getreviewcount() {
		return (int)movie_reviewRepository.count();
	}
	
	// 리뷰저장
	public Movie_review insertreview(Movie_reviewDTO dto) {
		return movie_reviewRepository.save(dto.toEntity());
	}
	
}