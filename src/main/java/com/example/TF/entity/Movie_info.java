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


@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
public class Movie_info {
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE,
			generator = "MOVIE_INFO_SEQUENCE_GENERATOR")
	@SequenceGenerator(name = "MOVIE_INFO_SEQUENCE_GENERATOR",
			sequenceName = "seq_movie_info", initialValue = 1,
			allocationSize = 1)
    private int moviecode;
	private String poster1;
	private String country;
    private String title;
    private String synopsis;
    @Temporal(TemporalType.DATE)
    private Date releasedate;
    private int runningtime;
    private int agerating;
    private String genre;
    private String director;
    private String actors;
    private int yesterday;
    private int total;
    private String trailer;
}