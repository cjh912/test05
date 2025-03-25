package com.example.TF.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.TF.entity.*;
import com.example.TF.repository.*;

import jakarta.transaction.Transactional;

@Service
public class BookingService {

    @Autowired
    BookingRepository bookingRepository;

    @Autowired
    MovieRepository movieRepository;

    @Autowired
    ScreeningRepository screeningRepository;

    @Autowired
    TheaterRepository theaterRepository;

    @Autowired
    Movie_MemberRepository movieMemberRepository;

    @Autowired
    Seat_service seatService;

    // 모든 영화 조회
    public List<Movie> getAllMovies() {
        return movieRepository.findAll();
    }

    // 모든 극장 조회
    public List<Theater> getAllTheaters() {
        return theaterRepository.findAll();
    }

    // 영화, 극장, 날짜에 맞는 상영 정보 조회
    public List<Screening> getScreeningsByMovieAndTheater(Long movieId, Long theaterId, String dateString) {
        String formattedDate = LocalDate.parse(dateString, DateTimeFormatter.ofPattern("yyyy-MM-dd")).toString();
        return screeningRepository.findByMovieAndTheaterAndDate(movieId, theaterId, formattedDate);
    }

    // 상영 정보 조회
    public Screening findScreeningById(Long screeningId) {
        return screeningRepository.findById(screeningId).orElse(null);
    }

    // 예매 저장
    @Transactional
    public Booking reserveSeat(Long screeningId, String seatNumbers, String userId) {
        Screening screening = findScreeningById(screeningId);
        if (screening == null) throw new RuntimeException("상영 정보 없음");

        int moviePrice = screening.getMovie().getPrice();
        int seatCount = seatNumbers.split(",").length;
        int totalPrice = moviePrice * seatCount;

        Booking booking = new Booking();
        booking.setScreening(screening);
        booking.setSeatNumber(seatNumbers);
        booking.setUserId(userId);
        booking.setPrice(totalPrice);
        booking.setPaymentStatus("pending");
        booking.setOrderId(generateOrderId().trim());
        booking.setMovieTitle(screening.getMovie().getTitle());

        Booking savedBooking = bookingRepository.save(booking);

        // ✅ 예매한 좌석의 구매 상태 업데이트
        int screenNum = 1; // ⚠️ 추후 실제 screen_num과 매핑 필요
        int theaterCode = screening.getTheater().getId().intValue(); // theater_code 매핑

        List<int[]> seatPositions = parseSeatPositions(seatNumbers); // "A1,B2" → [[0,0], [1,1]]
        seatService.markSeatsAsPurchased(screenNum, theaterCode, seatPositions);

        return savedBooking;
    }

    // orderId 생성
    private String generateOrderId() {
        return "ORD-" + UUID.randomUUID().toString().substring(0, 8);
    }

    // 예매 ID로 조회
    public Booking findBookingById(Long bookingId) {
        return bookingRepository.findById(bookingId).orElse(null);
    }

    // orderId로 조회
    public Booking findByOrderId(String orderId) {
        return bookingRepository.findByOrderIdIgnoreCase(orderId);
    }

    // 상영별 예매 좌석
    public List<Booking> getBookedSeats(Long screeningId) {
        return bookingRepository.findByScreeningId(screeningId);
    }

    // ✅ 결제 완료 시 상태 업데이트 + 포인트 적립
    public void updateBookingStatus(Long bookingId, String paymentKey) {
        Optional<Booking> optionalBooking = bookingRepository.findById(bookingId);
        if (optionalBooking.isPresent()) {
            Booking booking = optionalBooking.get();
            booking.setPaymentStatus("PAID");
            booking.setPaymentKey(paymentKey);
            bookingRepository.save(booking);

            String memberId = String.valueOf(booking.getUserId());
            Optional<Movie_Member> optionalMember = movieMemberRepository.findById(memberId);
            if (optionalMember.isPresent()) {
                Movie_Member member = optionalMember.get();
                int earnedPoints = (int)(booking.getPrice() * 0.05);
                int currentPoints = Optional.ofNullable(member.getPoint()).orElse(0);
                member.setPoint(currentPoints + earnedPoints);
                movieMemberRepository.save(member);
                System.out.println("✅ 포인트 적립 완료: " + earnedPoints + "점");
            } else {
                System.out.println("⚠️ 회원정보 없음 (ID: " + memberId + ")");
            }
        }
    }

    // ✅ 좌석 문자열을 [x, y] 좌표 리스트로 변환 ("A1,B2" → [[0,0], [1,1]])
    public List<int[]> parseSeatPositions(String seatNumbers) {
        List<int[]> result = new ArrayList<>();
        for (String seat : seatNumbers.split(",")) {
            char rowChar = seat.charAt(0);           // A ~ Z
            int y = rowChar - 'A';                   // Y index
            int x = Integer.parseInt(seat.substring(1)) - 1; // X index (0부터 시작)
            result.add(new int[]{x, y});
        }
        return result;
    }

    // 결제 금액 계산 (좌석 수 * 영화 가격)
    public int calculateTotalPrice(Long screeningId, String seats) {
        Screening screening = findScreeningById(screeningId);
        if (screening == null) throw new RuntimeException("상영 정보 없음");
        int seatCount = seats.split(",").length;
        return seatCount * screening.getMovie().getPrice();
    }

    // ✅ 예매 저장 (내부에서 사용)
    public Booking saveBooking(Booking booking) {
        booking.setMovieTitle(booking.getScreening().getMovie().getTitle());
        return bookingRepository.save(booking);
    }
}
