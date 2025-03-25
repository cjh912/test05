package com.example.TF.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.TF.entity.Movie_notice_board;

public interface Movie_notice_board_repository extends JpaRepository<Movie_notice_board, Integer> {
	@Query(value = "select * from (select rownum rn, tt.* from "
			+ "(select * from movie_notice_board order by seq desc) tt) "
			+ "where rn>=:startNum and rn<=:endNum", nativeQuery = true)
	List<Movie_notice_board> findByStartnumAndEndnum(@Param("startNum") int startNum,
			@Param("endNum") int endNum);
}
