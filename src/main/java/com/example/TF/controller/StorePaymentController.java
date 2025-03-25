package com.example.TF.controller;

import java.util.*;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.TF.dto.PaymentRequest;
import com.example.TF.entity.Movie_Member;
import com.example.TF.entity.Movie_store_board;
import com.example.TF.entity.PurchaseHistory;
import com.example.TF.repository.Movie_MemberRepository;
import com.example.TF.repository.PurchaseHistoryRepository;
import com.example.TF.service.Movie_service;

import jakarta.servlet.http.HttpSession;

@Controller
public class StorePaymentController {

    @Autowired
    Movie_service service;

    @Autowired
    PurchaseHistoryRepository purchaseHistoryRepository;
    
    @Autowired
    Movie_MemberRepository movieMemberRepository; // ✅ 꼭 추가되어야 함

    // ✅ 결제 페이지 이동
    @PostMapping("/pay/payments-store")
    public String storePaymentsPage(@RequestParam("seqList") List<Integer> seqList,
                                    HttpSession session, Model model) {
        String userId = (String) session.getAttribute("memId");

        if (userId == null) {
            return "redirect:/member/loginForm";
        }

        List<Movie_store_board> products = seqList.stream()
                .map(service::store_board_view)
                .collect(Collectors.toList());

        int totalPrice = products.stream()
                .mapToInt(Movie_store_board::getImageprice)
                .sum();

        String orderId = "STORE-" + UUID.randomUUID().toString().substring(0, 8);

        session.setAttribute("store_orderId", orderId);
        session.setAttribute("store_userId", userId);
        session.setAttribute("store_products", products);
        session.setAttribute("store_totalPrice", totalPrice);

        model.addAttribute("orderId", orderId);
        model.addAttribute("totalPrice", totalPrice);

        return "/pay/payments-store";
    }

    // ✅ 결제 성공 처리
    @PostMapping("/confirm-store")
    @ResponseBody
    public ResponseEntity<?> confirmStorePayment(@RequestBody PaymentRequest request, HttpSession session) {
        List<Movie_store_board> products = (List<Movie_store_board>) session.getAttribute("store_products");
        String userId = (String) session.getAttribute("store_userId");

        if (products == null || userId == null) {
            return ResponseEntity.badRequest().body(Collections.singletonMap("status", "fail"));
        }

        int totalPrice = 0;

        for (Movie_store_board product : products) {
            PurchaseHistory history = new PurchaseHistory();
            history.setUserId(userId);
            history.setProductSeq(product.getSeq());
            history.setProductName(product.getImagename());
            history.setProductPrice(product.getImageprice());
            history.setPurchaseQty(1);
            history.setTotalPrice(product.getImageprice());
            history.setPaymentStatus("결제완료");
            history.setPurchaseDate(new Date());
            purchaseHistoryRepository.save(history);

            totalPrice += product.getImageprice(); // ✅ 전체 합산
        }

        // ✅ 포인트 적립 처리
        Optional<Movie_Member> optionalMember = movieMemberRepository.findById(userId);
        if (optionalMember.isPresent()) {
            Movie_Member member = optionalMember.get();
            int currentPoint = Optional.ofNullable(member.getPoint()).orElse(0);
            int earnedPoint = (int) (totalPrice * 0.05); // 5% 적립
            member.setPoint(currentPoint + earnedPoint);
            movieMemberRepository.save(member);

            System.out.println("🎁 포인트 적립 완료! +" + earnedPoint + "p (총: " + member.getPoint() + ")");
        } else {
            System.out.println("⚠️ 포인트 적립 실패: 회원 정보 없음 (id: " + userId + ")");
        }

        // 세션 정리
        session.removeAttribute("store_products");
        session.removeAttribute("store_userId");

        return ResponseEntity.ok(Collections.singletonMap("status", "success"));
    }

    
    
}
