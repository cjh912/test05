package com.example.TF.dto;

import java.util.Date;

import com.example.TF.entity.Movie_notice_board;

import lombok.Data;

@Data
public class Movie_notice_board_DTO {
    private int seq;             
    private String section;
    private String subject;
    private String content;
    private Date logtime;
    
    public Movie_notice_board toEntity() {
    	return new Movie_notice_board(seq, section, subject, content, logtime);
    }
}
