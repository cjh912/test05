package com.example.TF.entity;

import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Movie_inquiry_board {
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE,
	generator = "MOVIE_INQUIRY_BOARD_SEQUENCE_GENERATOR")
	@SequenceGenerator(name = "MOVIE_INQUIRY_BOARD_SEQUENCE_GENERATOR",
	sequenceName = "seq_movie_inquiry_board", initialValue = 1, allocationSize = 1)
    private int seq;                   		// 문의 코드
    private String inquiry_id;   	   		// 문의 ID
    private String inquiry_type;		    // 문의 유형
    private String inquiry_stat;		    // 상태
    private String subject;			        // 제목
    private String content;			        // 내용
    private String image1;                  // 문의 첨부 자료
    @Temporal(TemporalType.DATE)
    private Date logtime;		            // 문의 날짜
}
