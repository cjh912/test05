package com.example.TF.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.TF.entity.Movie_review;

public interface Movie_reviewRepository extends JpaRepository<Movie_review, Integer>{
	// 전체 리스트
	@Query(value ="select * from (select rownum rn, tt.* from \r\n"
			+ "(select * from movie_review order by logtime desc) tt)\r\n"
			+ "where rn>=:startNum and rn<=:endNum", nativeQuery = true)
	List<Movie_review> findByStartnumAndEndnum_logtime(@Param("startNum") int startNum,
			@Param("endNum") int endNum);
}
