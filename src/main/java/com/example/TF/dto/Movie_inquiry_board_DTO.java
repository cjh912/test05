package com.example.TF.dto;

import java.util.Date;

import com.example.TF.entity.Movie_inquiry_board;

import lombok.Data;

@Data
public class Movie_inquiry_board_DTO {
    private int seq;                   		// 문의 코드
    private String inquiry_id;   	   		// 문의 ID
    private String inquiry_type;		    // 문의 유형
    private String inquiry_stat;		    // 상태
    private String subject;			        // 제목
    private String content;			        // 내용
    private String image1;                  // 문의 첨부 자료
    private Date logtime;		            // 문의 날짜
    
    public Movie_inquiry_board toEntity() {
    	return new Movie_inquiry_board(seq, inquiry_id, inquiry_type, inquiry_stat, subject, content, image1, logtime);
    }
}
