package com.example.TF.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.TF.entity.Movie_inquiry_board;

public interface Movie_inquiry_repository extends JpaRepository<Movie_inquiry_board, Integer> {
	
	// 전체 리스트
	@Query(value = "select * from (select rownum rn, tt.* from "
			+ "(select * from movie_inquiry_board order by seq desc) tt) "
			+ "where rn>=:startNum and rn<=:endNum", nativeQuery = true)
	List<Movie_inquiry_board> findByStartnumAndEndnum(@Param("startNum") int startNum,
			@Param("endNum") int endNum);
	
	// 유형별 리스트
	@Query(value = "select * from (select rownum rn, tt.* from "
			+ "(select * from movie_inquiry_board where inquiry_type=:inquiry_type order by seq desc) tt) "
			+ "where rn>=:startNum and rn<=:endNum", nativeQuery = true)
	List<Movie_inquiry_board> findByStartnumAndEndnum_type(
			@Param("inquiry_type") String inquiry_type,
			@Param("startNum") int startNum,
			@Param("endNum") int endNum);
	
	// 상태별 리스트
	@Query(value = "select * from (select rownum rn, tt.* from "
			+ "(select * from movie_inquiry_board where inquiry_stat=:inquiry_stat order by seq desc) tt) "
			+ "where rn>=:startNum and rn<=:endNum", nativeQuery = true)
	List<Movie_inquiry_board> findByStartnumAndEndnum_stat(
			@Param("inquiry_stat") String inquiry_stat,
			@Param("startNum") int startNum,
			@Param("endNum") int endNum);
	
	// 유형별 글수 구하기
	@Query(value = "select count(*) as cnt from "
			+ "movie_inquiry_board where"
			+ " inquiry_type=:inquiry_type", nativeQuery = true)
	int count_type(@Param("inquiry_type") String inquiry_type);
	
	// 상태별 글수 구하기
	@Query(value = "select count(*) as cnt from"
			+ " movie_inquiry_board where"
			+ " inquiry_stat=:inquiry_stat", nativeQuery = true)
	int count_stat(@Param("inquiry_stat") String inquiry_stat);
}
