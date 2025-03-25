package com.example.TF.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class ResourceConfiguration implements WebMvcConfigurer {
	@Value("${project.upload.path}")
	private String uploadpath;
	
	@Value("${project.upload.movie_poster.path}")
	private String movie_posteruploadpath;
	
	@Value("${project.upload.movie.path}")
	private String movieuploadpath;
	
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/storage/**")
		.addResourceLocations("file:///" + uploadpath + "/");

		// http://localhost:8080/storage/cupra.jpg
		registry.addResourceHandler("/movie_poster/**")
				.addResourceLocations("file:///" + movie_posteruploadpath + "/");//마지막 / 생략하지마		
	
		registry.addResourceHandler("/movie/**")
		.addResourceLocations("file:///" + movieuploadpath + "/");//마지막 / 생략하지마
		//"file:///D:/JDG/spring_boot/workspace/static/movie/"	

	}
}
