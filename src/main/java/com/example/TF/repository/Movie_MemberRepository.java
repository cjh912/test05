package com.example.TF.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.TF.entity.Movie_Member;

public interface Movie_MemberRepository extends JpaRepository<Movie_Member, String> {
	// 아이디와 비밀번호로 조회
	Movie_Member findByIdAndPwd(String id, String pwd);
}