-- 수민
-- 극장 테이블 (THEATER)
create table theater (
    id number generated always as identity primary key,
    name varchar2(255) not null,    --극장 이름
    location varchar2(255) not null --극장 지역
);

-- 테이블 목록
select * from tab;

-- 테이블 삭제
DROP TABLE theater CASCADE CONSTRAINTS;

--데이터 삽입
insert into theater (name, location) values ('강남', '서울');
insert into theater (name, location) values ('마포구', '서울');
insert into theater (name, location) values ('강변', '경기');

--데이터 검색
select * from theater;

-- db 저장
commit;

--------------------------------------------------------------------------------------------------

-- 영화 테이블 (MOVIE)
create table movie (
    id number generated always as identity primary key,
    title varchar2(255) not null,   --영화제목
    genre varchar2(100),            --영화장르
    rating varchar2(10),            --영화등급
    price number not null           --영화가격
);

-- 테이블 목록
select * from tab;

-- 테이블 삭제
DROP TABLE movie CASCADE CONSTRAINTS;

--데이터 삽입
insert into movie (title, GENRE, RATING, PRICE) values ('미키17', 'SF', '15', 12000);
insert into movie (title, GENRE, RATING, PRICE) values  ('침범', '스릴러', '15', 10000);
insert into movie (title, GENRE, RATING, PRICE) values  ('화이트버드', '드라마', '12', 11000);

--데이터 검색
select * from movie;

-- db 저장
commit;

---------------------------------------------------------------------------------------------------

-- 영화 상영 테이블 (SCREENING)
create table screening (
    id number generated always as identity primary key,
    movie_id number not null,       --상영되는 영화의 ID를 저장
    theater_id number not null,     --영화를 상영하는 극장의 ID를 저장
    screen_time timestamp not null, --해당 영화의 상영 날짜 및 시간을 저장
    foreign key (movie_id) references movie(id),
    foreign key (theater_id) references theater(id)
);
-- 테이블 목록
select * from tab;

-- 테이블 삭제
DROP TABLE movie CASCADE CONSTRAINTS;

--데이터 삽입
INSERT INTO SCREENING (MOVIE_ID, THEATER_ID, SCREEN_TIME) VALUES (1, 1, TO_DATE('2025-03-15 14:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO SCREENING (MOVIE_ID, THEATER_ID, SCREEN_TIME) VALUES (2, 2, TO_DATE('2025-03-16 16:30:00', 'YYYY-MM-DD HH24:MI:SS'));

--데이터 검색
select * from screening;

SELECT * FROM screening WHERE id = 1;

-- db 저장
commit;

---------------------------------------------------------
-- 예매 테이블 (BOOKING)
create table booking (
    id number generated always as identity primary key,  
    screening_id number not null,                   --예매된 영화의 상영 ID를 저장
    seat_number varchar2(10) not null,              --예매된 좌석 번호를 저장
    user_id number NOT NULL,                        --예매한 사용자의 ID를 저장
    payment_status varchar2(20) default 'pending',  --결제 상태(예: pending, paid, canceled)를 저장
    price number not null,                          --해당 예매의 결제 금액을 저장
    foreign key (SCREENING_ID) references screening(id)
);

-- 데이터 삽입 예시
INSERT INTO booking (screening_id, seat_number, user_id, price) 
VALUES (1, 'A1', 1001, 12000);

--user_id 삭제
ALTER TABLE booking DROP COLUMN user_id;
--user_id 추가
ALTER TABLE booking ADD user_id varchar2(255);
--영화 이름 추가
ALTER TABLE booking ADD movie_title VARCHAR2(255);

--데이터 검색
select * from booking;
select * from movie_member;

-- db 저장
commit;

---------------------------------------------------------------------------------------

CREATE TABLE purchase_history (
    purchase_seq number primary key,            -- 구매내역 고유번호
    user_id varchar2(50) not null,              -- 구매한 사용자 아이디
    product_seq number not null,                -- 구매한 상품 seq (기존 상품테이블 참조)
    product_name varchar2(100) not null,        -- 상품명 (구매 당시 이름)
    product_price number not null,              -- 상품 가격 (구매 당시 가격)
    purchase_qty number not null,               -- 구매 수량
    total_price number not null,                -- 총 결제 금액 (price * qty)
    purchase_date date default sysdate,         -- 구매 날짜
    payment_status varchar2(30) default '결제완료', -- 결제 상태 (결제완료, 취소, 환불 등) 
    FOREIGN KEY(product_seq) REFERENCES movie_store_board(seq)
);

-- 테이블 목록
select * from tab;

--데이터 검색
select * from purchase_history;
-- 수민

--------------------------------------------------------------------------------
-- 동건
-- 답글정보 --
create table movie_review (
    reviewcode number not null,              -- 리뷰 코드 (PK) 
    moviecode number not null,           -- 영화코드 (FK, movie_info.moviecode)
    user_id varchar2(30) not null,       -- 회원 ID (FK, movie_member.id)
    review_comment varchar2(1000) not null,     -- 리뷰 내용
    rating number not null check (rating between 1 and 10), -- 별점 (1~10)
    logtime date default sysdate         -- 작성일
); 
drop table movie_review purge;
-- 시퀀스 객체 생성
create sequence seq_movie_review NOCACHE NOCYCLE;
-- 시퀀스 객체 삭제
drop sequence seq_movie_review;
-- 시퀀스 목록
select * from user_sequences;

-- FK 추가(영화연결)
alter table movie_review add constraint fk_movie_review foreign key (moviecode) references movie_info(moviecode);
-- 회원과 연결
alter table movie_review add constraint fk_movie_review_user foreign key (user_id) references movie_member(id);

-- 데이터 추가
insert into movie_review values(seq_movie_review.nextval, 1, 'hong', '그지같아요', 5, sysdate);
insert into movie_review values(seq_movie_review.nextval, 1, 'test3800', '내인생 최고영화', 10, sysdate);
delete movie_review where user_id='test3800';
-- 데이터 검색
select * from movie_review;

-- 리뷰순
select * from (select rownum rn, tt.* from 
(select * from movie_review order by logtime desc) tt)
where rn>=1 and rn<=4;

commit;
-- 지훈 -- 
--- 영화 사진 목록 -----------------------------
create table movie_info_stillcut (
    movie_stillcut_code number not null,
    moviecode number not null,
    stillcut_name varchar2(255) not null,
    stillcut_src varchar2(255) not null,
    FOREIGN KEY (moviecode) REFERENCES movie_info(moviecode)     
);
-- 테이블 구조
desc movie_info_stillcut;
-- 테이블 삭제
drop table movie_info_stillcut purge;

-- 쓰기
insert into movie_info_stillcut values (seq_movie_info_stillcut.nextval, 1, '짤1', 'lion.jpg'); 
-- 보기
select * from movie_info_stillcut;
-- 특정영화
select count(*) as cnt from movie_info_stillcut where moviecode=9;
--
select * from (select rownum rn, tt.* from 
(select * from movie_info_stillcut where moviecode=9 order by movie_stillcut_code desc) tt) 
where rn>=1 and rn<=6;
-- 수정
update movie_info_stillcut set moviecode=9 where moviecode=1;
            
-- 시퀀스 객체 생성
create sequence seq_movie_info_stillcut nocache nocycle;
-- 시퀀스 객체 삭제
drop sequence seq_movie_info_stillcut;
-- 시퀀스 목록
select * from user_sequences;
--
commit;
-- 지훈 -- 

--- 영화정보 ------------------------------
create table movie_info (
    moviecode number not null,              -- 영화코드
    poster1 varchar2(1000) not null,        -- 영화포스터
    country varchar2(100) not null,         -- 제작국가
    title varchar2(100) not null,           -- 영화명
    synopsis varchar2(1000) not null,       -- 영화 줄거리
    releasedate date not null,              -- 영화개봉일
    runningtime number not null,            -- 영화 재생시간
    agerating number not null,              -- 영화상영등급
    genre varchar2(100) not null,           -- 장르
    director varchar2(100) not null,        -- 감독
    actors varchar2(1000) not null,         -- 출연진
    yesterday number not null,              -- 전일 관객수
    total number not null,                  -- 누적 관객수
    trailer varchar2(255)                   -- 트레일러 주소
);
ALTER TABLE movie_info 
ADD CONSTRAINT pk_movie_info PRIMARY KEY (moviecode);
-- 테이블 삭제
drop table movie_info purge;
-- 테이블 목록 확인
select * from tab;

desc movie_info;

-- 시퀀스 객체 생성
create sequence seq_movie_info nocache nocycle;
-- 시퀀스 객체 삭제
drop sequence seq_movie_info;
-- 시퀀스 목록
select * from user_sequences;


-- 데이터 저장
insert into movie_info values (seq_movie_info.nextval, 'titan.jpg', '일본', '진격의거인', '어쩌구저쩌구',
TO_DATE('2025-03-20', 'YYYY-MM-DD'), 148, 12, '애니메이션', '홍길동', '미카사, 아르민, 에렌', 20312, 286640,
'https://www.youtube.com/embed/xUqO0wcTLZQ?si=BC65Rr3Fnqddj_3R');
insert into movie_info values (seq_movie_info.nextval, 'verse.jpg', '한국', '승부', '불꽃튀는 바둑대전이 시작된다',
TO_DATE('2025-03-26', 'YYYY-MM-DD'), 122, 15, '드라마', '몰러유', '이병헌, 유아인', 0, 0,
'https://www.youtube.com/embed/J8qqMLZPPTo?si=QvULiW4s5LqfqhdF');
insert into movie_info values (seq_movie_info.nextval, '3day.jpg', '한국', '3일', '어머니 주희의 죽음을 마주하게된 태하',
TO_DATE('2025-03-19', 'YYYY-MM-DD'), 27, 15, '드라마', '김순수', '유승호, 김동욱', 123, 247,
'https://www.youtube.com/embed/0GIYLPmHJOw?si=lFGj8fnHhzERTrK_');
insert into movie_info values (seq_movie_info.nextval, 'invade.jpg', '한국', '침범', '나랑 엄마는 못 가겠네요.',
TO_DATE('2025-03-12', 'YYYY-MM-DD'), 112, 15, '미스터리', '김여정, 이정찬', '곽선영, 기소유', 12312, 66059,
'https://www.youtube.com/embed/ft0jB8dHYKc?si=p2_x69ja39siDwhA');
insert into movie_info values (seq_movie_info.nextval, 'invade.jpg', '미국', '미키17', '당신은 몇 번째 미키입니까?',
TO_DATE('2025-02-28', 'YYYY-MM-DD'), 137, 15, '드라마', '봉준호', '로버트 패틴슨, 나오이 아키에', 32312, 2665746,
'https://www.youtube.com/embed/MFXWhpcuIg4?si=s9b-ijTwA8ibWqsQ');
insert into movie_info values (seq_movie_info.nextval, 'snowwhite.jpg', '미국', '백설공주', '눈보라가 몰아치던 겨울밤 태어난 백설공주',
TO_DATE('2025-03-19', 'YYYY-MM-DD'), 109, 12, '판타지', '마크 웹', '레이첼 지글러, 갤 가돗', 12352, 23123,
'https://www.youtube.com/embed/9aAUvdtBg1w?si=6fuoUFSFf0EYwO0z');
insert into movie_info values (seq_movie_info.nextval, 'hungry.jpg', '일본', '고독한 미식가', '우리들의 밥친구이자 프로 혼밥러',
TO_DATE('2025-03-19', 'YYYY-MM-DD'), 110, 12, '드라마', '마츠시게 유타카', '마츠시케 유카타', 7536, 14021, 
'https://www.youtube.com/embed/ioB9CY-vqWM?si=1xrs7yIV2oZmj-sJ');
insert into movie_info values (seq_movie_info.nextval, 'exorcism.jpg', '한국', '퇴마록', '삼백이 반으로 나뉘고, 다섯이 모자랄 때 불씨가 하늘을 모두 태우리라',
TO_DATE('2025-02-21', 'YYYY-MM-DD'), 85, 12, '애니메이션', '김동철', '최한, 남도형, 정유정', 6736, 441263, 
'https://www.youtube.com/embed/BlxdE3B_c2Q?si=Qpd8KV2DC5Tmm6e9');
-- 데이터 개수 확인
select count(*) as cnt from movie_info;
-- 장르별 데이터 개수
select count(*) as cnt from movie_info where genre='드라마';
-- 나라별 데이터 개수
-- 데이터 검색
select * from movie_info;
select * from movie_info where moviecode=1;
select * from movie_info order by moviecode desc;

-- 장르별 검색
select count(*) as cnt from movie_info where genre = '드라마';
-- 국내 검색
select count(*) as cnt from movie_info where country = '한국';
-- 해외 검색
select count(*) as cnt from movie_info where country not like '한국';

-- 영화번호순 인덱스 뷰
select * from (select rownum rn, tt.* from 
(select * from movie_info order by moviecode desc) tt)
where rn>=1 and rn<=4;

-- 장르별 박스오피스순 인덱스 뷰
select * from (select rownum rn, tt.* from 
(select * from movie_info where genre ='드라마' order by yesterday desc) tt)
where rn>=1 and rn<=4;

-- 국내 박스오피스순 인덱스 뷰
select * from (select rownum rn, tt.* from 
(select * from movie_info where country ='한국' order by yesterday desc) tt)
where rn>=1 and rn<=4;

-- 해외 박스오피스순 인덱스 뷰
select * from (select rownum rn, tt.* from 
(select * from movie_info where country not like '한국' order by yesterday desc) tt)
where rn>=1 and rn<=4;

-- 개봉일 순 인덱스 뷰
select * from (select rownum rn, tt.* from 
(select * from movie_info order by releasedate desc) tt)
where rn>=1 and rn<=4;

-- 전일관객순(박스오피스) 인덱스 뷰
select * from (select rownum rn, tt.* from 
(select * from movie_info order by yesterday desc) tt)
where rn>=1 and rn<=4;

-- 누적관객순 인덱스뷰
select * from (select rownum rn, tt.* from 
(select * from movie_info order by total desc) tt)
where rn>=1 and rn<=4;

-- 현재 상영작
select * from (
    select rownum rn, tt.* from (
        select * from movie_info 
        where releasedate <= sysdate
        order by releasedate desc
    ) tt
)
where rn >= 1 and rn <= 4;

-- 상영 예정작
select * from (
    select rownum rn, tt.* from (
        select * from movie_info 
        where releasedate > sysdate
        order by releasedate asc
    ) tt
)
where rn >= 1 and rn <= 4;

-- 업데이트
update movie_info set poster1 = 'micky17.jpg' where title='미키17';

-- 데이터 삭제
delete movie_info where moviecode=3;

commit;


--- 사용자기준 1:1문의 ---

create table movie_question_board (
    seq number not null,                         -- 문의 코드
    question_id varchar2(40) not null,           -- 문의 ID
    question_type varchar2(50) not null,         -- 문의 유형
    question_stat varchar2(40) not null,         -- 답변 상태
    subject varchar2(255) not null,              -- 제목
    question_content varchar2(4000) not null,    -- 문의내용
    answer_content varchar2(4000),               -- 답변내용
    image1 varchar2(200),                        -- 문의 첨부 자료
    logtime date default sysdate                 -- 문의 날짜
);
-- null 허용
alter table movie_question_board 
modify answer_content null;


-- 테이블 삭제
drop table movie_question_board purge;
-- 테이블 목록 확인
select * from tab;

desc movie_question_board;

-- 시퀀스 객체 생성
create sequence seq_movie_question_board nocache nocycle;
-- 시퀀스 객체 삭제
drop sequence seq_movie_question_board;
-- 시퀀스 목록
select * from user_sequences;

-- 데이터 저장
insert into movie_question_board values (seq_movie_question_board.nextval, 'hong', '[영화정보문의]',
'미답변', '미키17', '재밌나요?', null, 'mickey17.jpg', sysdate);
insert into movie_question_board values (seq_movie_question_board.nextval, 'test3800', '[포인트문의]',
'미답변', '포인트', '1200언제쌓나요', null, null, sysdate);
-- 데이터 개수 확인
select count(*) as cnt from movie_question_board;
-- 개별 데이터 개수 확인
select count(*) as cnt from movie_question_board where question_id='hong';

-- 데이터 검색
select * from movie_question_board;
select * from movie_question_board where seq=1;
select * from movie_question_board order by seq desc;

-- 특정 아이디로 내용 확인
select * from movie_question_board where question_id='hong';

-- 데이터 삭제
delete movie_question_board where seq=16;

-- 인덱스뷰
-- => 행번호 기준으로 데이터를 잘라서 가져오기
select * from (select rownum rn, tt.* from 
(select * from movie_question_board order by seq desc) tt)
where rn>=1 and rn<=5;

-- 개인별 인덱스 뷰
select * from (select rownum rn, tt.* from 
(select * from movie_question_board where question_id ='hong' order by seq desc) tt)
where rn>=1 and rn<=5;

-- 수정
-- 답변상태 수정
update movie_question_board set question_stat = '답변완료' where answer_content is not null;
update movie_question_board set question_stat = '미답변' where answer_content is null;

-- db 저장
commit;

---- 자주 찾는 질문 ---
create table movie_user_qna_board (
    seq number not null,                
    section varchar2(100) not null,
    subject varchar2(255) not null,
    content varchar2(4000) not null,
    logtime date default sysdate
);

-- 테이블 삭제
drop table movie_user_qna_board purge;
-- 테이블 목록 확인
select * from tab;
-- 테이블 구조
desc movie_user_qna_board;

-- 시퀀스 객체 생성
create sequence seq_movie_user_qna_board nocache nocycle;
-- 시퀀스 객체 삭제
drop sequence seq_movie_user_qna_board;
-- 시퀀스 조회
select * from user_sequences;
-- 다음 시퀀스값 확인 : 조회할 때마다 값이 증가됨
select seq_movie_user_qna_board.nextval from dual;
-- 현재 시퀀스값 확인
select seq_movie_user_qna_board.currval from dual;

-- 데이터 저장 : insert
insert into movie_user_qna_board values (seq_movie_user_qna_board.nextval, '[예매관람권]', '예매는 어떻게 하는건가요?', '냉무', sysdate);
insert into movie_user_qna_board values (seq_movie_user_qna_board.nextval, '[영화관이용]', '팝콘은 맛있나요?', '냉무', sysdate);
insert into movie_user_qna_board values (seq_movie_user_qna_board.nextval, '[홈페이지]', '회원 탈퇴는 어디서 하나요?', '냉무', sysdate);
-- 저장된 데이터 개수 확인
select count(*) as cnt from movie_user_qna_board;
-- 항목별
select count(*) as cnt from movie_user_qna_board where section='[홈페이지]';

-- 인덱스뷰
-- => 행번호 기준으로 데이터를 잘라서 가져오기
select * from (select rownum rn, tt.* from 
(select * from movie_user_qna_board order by seq desc) tt)
where rn>=1 and rn<=5;

-- 항목별 인덱스뷰
select * from (select rownum rn, tt.* from 
(select * from movie_user_qna_board where section='[홈페이지]' order by seq desc) tt)
where rn>=1 and rn<=5;

-- 전체 데이터 내림차순 정렬
select * from movie_user_qna_board order by seq desc;
-- 전체 데이터를 내림차순 정렬해서 가져온 값 + 행 번호 추가
select rownum rn, tt.* from 
(select * from movie_user_qna_board order by seq desc) tt;

-- 1) seq 기준 내림차순 정렬
select * from movie_user_qna_board order by seq desc;
-- 2) seq 기준 내림차순 정렬 결과에 별명 tt를 붙이고
--    그 값을 기준으로 rownum(행번호)와 검색 결과를 보여주기
select rownum rn, tt.* from 
(select * from movie_user_qna_board order by seq desc) tt;

-- 전체 내용 확인
select * from movie_user_qna_board;
-- 특정 글번호로 내용 확인
select * from movie_user_qna_board where section='[영화관이용]';

-- db 저장
commit;


------- 공지글관련 테이블 ------
create table movie_notice_board (
    seq number not null,                
    section varchar2(100) not null,
    subject varchar2(255) not null,
    content varchar2(4000) not null,
    logtime date default sysdate
);

-- 테이블 삭제
drop table movie_notice_board purge;
-- 테이블 목록 확인
select * from tab;

-- 시퀀스 객체 생성
create sequence seq_movie_notice_board nocache nocycle;
-- 시퀀스 객체 삭제
drop sequence seq_movie_notice_board;
-- 시퀀스 조회
select * from user_sequences;
-- 다음 시퀀스값 확인 : 조회할 때마다 값이 증가됨
select seq_movie_notice_board.nextval from dual;
-- 현재 시퀀스값 확인
select seq_movie_notice_board.currval from dual;

-- 데이터 저장 : insert
insert into movie_notice_board values (seq_movie_notice_board.nextval, '[극장]', '내일은 웃으리...', '내용', sysdate);
insert into movie_notice_board values (seq_movie_notice_board.nextval, '[뉴스]', '오늘도 웃으리...', '내용', sysdate);
-- 저장된 데이터 개수 확인
select count(*) as cnt from movie_notice_board;

-- 인덱스뷰
-- => 행번호 기준으로 데이터를 잘라서 가져오기
select * from (select rownum rn, tt.* from 
(select * from movie_notice_board order by seq desc) tt)
where rn>=1 and rn<=5;

-- 
select seq, id, name, subject, content, hit, to_char(logtime, 'YYYY.MM.DD') as logtime from 
(select rownum rn, tt.* from 
(select * from movie_notice_board order by seq desc) tt)
where rn>=1 and rn<=5;

-- 전체 데이터 내림차순 정렬
select * from movie_notice_board order by seq desc;
-- 전체 데이터를 내림차순 정렬해서 가져온 값 + 행 번호 추가
select rownum rn, tt.* from 
(select * from movie_notice_board order by seq desc) tt;

-- 1) seq 기준 내림차순 정렬
select * from movie_notice_board order by seq desc;
-- 2) seq 기준 내림차순 정렬 결과에 별명 tt를 붙이고
--    그 값을 기준으로 rownum(행번호)와 검색 결과를 보여주기
select rownum rn, tt.* from 
(select * from movie_notice_board order by seq desc) tt;

-- 전체 내용 확인
select * from movie_notice_board;
-- 특정 글번호로 내용 확인
select * from movie_notice_board where seq=1;

-- 조회수 증가
select * from movieboard where seq=60;
update movieboard set hit = hit+1 where seq=60;

-- db 저장
commit;
----- 회원 -----
create table movie_member(
    id varchar2(30) primary key, -- unique, not null
    name varchar2(30) not null,
    pwd varchar2(30) not null,
    gender varchar2(5),
    email1 varchar2(20),
    email2 varchar2(20),
    tel1 varchar2(10),
    tel2 varchar2(10),
    tel3 varchar2(10),
    addr varchar2(100),
    grade varchar2(10),
    vippoint number,
    point number,
    logtime date
);

-- 테이블 구조 확인
desc movie_member;

-- 테이블 삭제
drop table movie_member purge;

-- 테이블 목록보기
select * from tab;

-- 데이터 추가 (insert)
insert into movie_member values('hong', '홍길동', '1234', 'm', 'hong', 'naver.com', '010', '1234', '5678', '서울시 동작구', 'basic', 0, 0, sysdate);
insert into movie_member values('test3800', '테스트3800', '1234', 'm', 'test3800', 'naver.com', '010', '3800', '3800', '테스시 테스구', 'vip', 3800, 3800, sysdate);
insert into movie_member values('god', '만수르', '1234', 'm', 'god', 'naver.com', '010', '7777', '7777', '영국 맨시티', 'vip', 7777, 7777, sysdate);
-- 데이터 검색 (select)
select * from movie_member;
select count(*) from movie_member where id= 'test';
select * from movie_member where id = 'god';
-- 로그인 확인
select * from movie_member where id = 'hong' and pwd ='1234';
-- 데이터 수정 (update)
update movie_member set tel2 = '2345' where id = 'hong';
update movie_member set grade = 'vvip' where id = 'god';
update movie_member set vippoint = 7777 where id = 'god';
update movie_member set point = 7777 where id = 'god';
update movie_member set logtime = sysdate where id = 'god';
update movie_member set grade = 'vip', vippoint = 3800, point = 3800 where id ='test3800';

-- 문제 데이터 수정
update movie_member set name='홍길동', pwd='1234', gender='m', 
email1='hong', email2='naver.com',
tel1='010', tel2='2345', tel3='5678', 
addr='경기도 수원시' where id='hong';

-- 데이터 삭제 (delete)
delete movie_member where id = 'hong';

-- db 저장
commit;
-- 동건

--------------------------------------------------------------------------------
-- 상영관 좌석 정보 테이블
create table screen_seat (
    id number not null,                 -- 고유 ID, 자동증가
    screen_num number not null,                -- 상영관 코드
    theater_code number not null,       -- 극장 코드
    x_index number,                     -- 좌석 가로 
    y_index number,                     -- 좌석 세로 
    seat_code number,                   -- 좌석분류 코드
    purchase varchar2(20)               -- 구매 여부
);
-- 테이블 삭제
drop table screen_seat purge;
-- 테이블 목록 확인
select * from tab;

desc screen_seat;

-- 시퀀스 객체 생성
create sequence screen_seat_id nocache nocycle;
-- 시퀀스 객체 삭제
drop sequence screen_seat_id;
-- 시퀀스 목록
select * from user_sequences;

-- 데이터 저장
insert into screen_seat values (screen_seat_id.nextval, 1, 34, 1, 
1, 1, 'N');

-- 데이터 개수 확인
select count(*) as cnt from screen_seat;

-- 데이터 검색
select * from screen_seat;
select * from screen_seat where screen_num=1 and theater_code=34 order by y_index, x_index;
select * from screen_seat where screen_num=9 and theater_code=34 and x_index=23 and y_index=1;
select * from screen_seat order by seq desc;

-- 데이터 삭제
delete from screen_seat where screen_num=1 and theater_code=34;
delete screen_seat where screen_num=11 and theater_code=34 and x_index=1 and y_index=2;
-- 데이터 다시 추가
insert into screen_seat values (screen_seat_id.nextval, 11, 34, 1, 2, 1, 'n');

-- db 저장
commit;

-- 인덱스뷰
-- => 행번호 기준으로 데이터를 잘라서 가져오기
select * from (select rownum rn, tt.* from 
(select * from screen_seat order by seq desc) tt)
where rn>=1 and rn<=5;

-- 상영관 좌석정보 가져오기
-- => 행번호 기준으로 데이터를 잘라서 가져오기
select * from (select rownum rn, tt.* from 
(select * from screen_seat ) tt) where screen_num=9 and theater_code=34;

-- 수정
update screen_seat set seat_code=2 where seq=1;
--
update movie_theater_screen set screen_image1='theater1.png' where seq=1;

--------------------------------------------------------------------------------
-- 상영관 정보 테이블
create table movie_theater_screen (
    id number not null,                 -- 고유 ID, 자동증가
    screen_num number not null,         -- 상영관 코드
    theater_code number not null,       -- 극장 코드    
    screen_name varchar2(50),           -- 상영관명
    screen_cost number,                 -- 기본비용
    screen_image1 varchar2(100),        -- 상영관 사진 주소
    x_index number,                     -- 가로 정보  
    y_index number,                     -- 세로 정보
    aisle varchar2(100)                 -- 통로 위치
);
-- 테이블 삭제
drop table movie_theater_screen purge;
-- 테이블 목록 확인
select * from tab;

desc movie_theater_screen;

-- 시퀀스 객체 생성
create sequence id_movie_theater_screen nocache nocycle;
-- 시퀀스 객체 삭제
drop sequence id_movie_theater_screen;
-- 시퀀스 목록
select * from user_sequences;

-- 데이터 저장
insert into movie_theater_screen values (id_movie_theater_screen.nextval, 1, 34, '1관', 
10000, 'theater1.png', 10, 10, '3,7');
insert into movie_theater_screen values (id_movie_theater_screen.nextval, 2, 34, '2관', 
10000, 'theater1.png', 10, 10, '3,7');
insert into movie_theater_screen values (id_movie_theater_screen.nextval, 3, 34, '3관', 
10000, 'theater1.png', 10, 10, '3,7');
insert into movie_theater_screen values (id_movie_theater_screen.nextval, 5, 34, '5관', 
10000, 'theater1.png', 10, 10, '3,7');

-- 데이터 개수 확인
select count(*) as cnt from movie_theater_screen;

-- 데이터 검색
select * from movie_theater_screen;
select * from movie_theater_screen where screen_num=1 and theater_code=34;
select * from movie_theater_screen where theater_code=1;
select * from movie_theater_screen order by seq desc;

-- 데이터 삭제
delete movie_theater_screen where id=2;

-- db 저장
commit;

-- 인덱스뷰
-- => 행번호 기준으로 데이터를 잘라서 가져오기
select * from (select rownum rn, tt.* from 
(select * from movie_theater_screen where theater_code=34 order by screen_num desc) tt)
where rn>=1 and rn<=5;

-- 수정
update movie_theater_screen set screen_name='노량' where seq=1;
--
update movie_theater_screen set screen_image1='theater1.png' where seq=1;

--------------------------------------------------------------------------------
-- 극장 관리 테이블 생성
create table movie_theater (
    seq number not null,            -- 극장 코드
    theater_name varchar2(50),      -- 극장명
    theater_image1 varchar2(100),   -- 극장사진
    theater_phone varchar2(100)     -- 극장 연락처
);

-- 테이블 삭제
drop table movie_theater purge;
-- 테이블 목록 확인
select * from tab;

desc movie_theater;

-- 시퀀스 객체 생성
create sequence seq_movie_theater nocache nocycle;
-- 시퀀스 객체 삭제
drop sequence seq_movie_theater;
-- 시퀀스 목록
select * from user_sequences;

-- 데이터 저장
insert into movie_theater values (seq_movie_theater.nextval, '노량진', 'theater1.png', 
'01045854716');

-- 데이터 개수 확인
select count(*) as cnt from movie_theater;

-- 데이터 검색
select * from movie_theater;
select * from movie_theater where seq=1;
select * from movie_theater order by seq desc;

-- 데이터 삭제
delete movie_theater where seq=16;

-- db 저장
commit;

-- 인덱스뷰
-- => 행번호 기준으로 데이터를 잘라서 가져오기
select * from (select rownum rn, tt.* from 
(select * from movie_theater order by seq desc) tt)
where rn>=1 and rn<=5;


-- 수정
update movie_theater set theater_name='노량' where seq=1;
--
update movie_theater set theater_image1='theater1.png' where seq=29;
--------------------------------------------------------------------------------
-- 문의내역 관리 테이블 생성
create table movie_inquiry_board (
    seq number not null,                    -- 문의 코드
    inquiry_id varchar2(40) not null,       -- 문의 ID
    inquiry_type varchar2(50) not null,     -- 문의 유형
    inquiry_stat varchar2(40) not null,     -- 상태
    subject varchar2(255) not null,         -- 제목
    content varchar2(4000) not null,        -- 내용
    image1 varchar2(200),                   -- 문의 첨부 자료
    logtime date default sysdate            -- 문의 날짜
);
-- 테이블 삭제
drop table movie_inquiry_board purge;
-- 테이블 목록 확인
select * from tab;

desc movie_inquiry_board;

-- 시퀀스 객체 생성
create sequence seq_movie_inquiry_board nocache nocycle;
-- 시퀀스 객체 삭제
drop sequence seq_movie_inquiry_board;
-- 시퀀스 목록
select * from user_sequences;

-- 데이터 저장
insert into movie_inquiry_board values (seq_movie_inquiry_board.nextval, 'hong', '[홈페이지]',
'[답변 미완료]', '오늘은', '웃으리', 'cupra.jpg', sysdate);
insert into movie_inquiry_board values (seq_movie_inquiry_board.nextval, 'hong', '[이벤트]',
'[답변 미완료]', '오늘은', '웃으리', 'cupra.jpg', sysdate);
insert into movie_inquiry_board values (seq_movie_inquiry_board.nextval, 'hong', '[영화관이용]',
'[답변 미완료]', '오늘은', '웃으리', 'cupra.jpg', sysdate);

-- 데이터 개수 확인
select count(*) as cnt from movie_inquiry_board;

-- 데이터 검색
select * from movie_inquiry_board;
select * from movie_inquiry_board where seq=1;
select * from movie_inquiry_board order by seq desc;

-- 데이터 삭제
delete movie_inquiry_board where seq=16;

-- db 저장
commit;

-- 인덱스뷰
-- => 행번호 기준으로 데이터를 잘라서 가져오기
select * from (select rownum rn, tt.* from 
(select * from movie_inquiry_board order by seq desc) tt)
where rn>=1 and rn<=5;
-- 유형별 인덱스뷰
select * from (select rownum rn, tt.* from 
(select * from movie_inquiry_board where inquiry_type='[이벤트]' order by seq desc) tt)
where rn>=1 and rn<=5;
-- 상태별 인덱스뷰
select * from (select rownum rn, tt.* from 
(select * from movie_inquiry_board where inquiry_stat='[답변 미완료]' order by seq desc) tt)
where rn>=1 and rn<=5;

-- 유형별 글수
select count(*) as cnt from movie_inquiry_board where inquiry_type='[홈페이지]';
-- 상태별 글수
select count(*) as cnt from movie_inquiry_board where inquiry_stat='[답변 미완료]';

-- 수정
update movie_inquiry_board set inquiry_id='hong', subject='내일은' where seq=1;
--

--------------------------------------------------------------------------------
-- 스토어 관리 테이블 생성
create table movie_store_board (
    seq number not null,                    -- 글 번호
    imageid varchar2(30) not null,          -- 상품코드
    imagename varchar2(40) not null,        -- 상품명
    imageprice number not null,             -- 단가
    imageqty number not null,               -- 개수
    imagecontent varchar2(4000) not null,   -- 내용
    image1 varchar2(200),                   -- 파일이름
    logtime date default sysdate            -- 작성일
);
-- 테이블에 primary key 추가
ALTER TABLE movie_store_board 
ADD CONSTRAINT movie_store_board_pk PRIMARY KEY (seq);
-- 확인
desc movie_store_board;
-- 테이블 삭제
drop table movie_store_board purge;
-- 테이블 목록 확인
select * from tab;

desc movie_store_board;

-- 시퀀스 객체 생성
create sequence seq_movie_store_board nocache nocycle;
-- 시퀀스 객체 삭제
drop sequence seq_movie_store_board;
-- 시퀀스 목록
select * from user_sequences;

-- 데이터 저장
insert into movie_store_board values (seq_movie_store_board.nextval, 'img_001', '컵라면',
1000, 10, '맛있는 컵라면', 'cupra.jpg', sysdate);

-- 데이터 개수 확인
select count(*) as cnt from movie_store_board;

-- 데이터 검색
select * from movie_store_board;
select * from movie_store_board where seq=1;
select * from movie_store_board order by seq desc;

-- 데이터 삭제
delete movie_store_board where seq=16;

-- 컬럼 삭제
alter table movie_store_board drop column image_price;
alter table movie_store_board drop column image_qty;
alter table movie_store_board drop column image_content;
alter table movie_store_board drop column image_name;
alter table movie_store_board drop column image_id;

-- db 저장
commit;

-- 인덱스뷰
-- => 행번호 기준으로 데이터를 잘라서 가져오기
select * from (select rownum rn, tt.* from 
(select * from movie_store_board order by seq desc) tt)
where rn>=1 and rn<=5;

-- 수정
update movie_store_board set imageid='img_001', imagename='컵라면', 
imageprice=1500, imageqty=5, imagecontent='맛있당', 
image1='cupra.jpg' where seq=1;
--
update movie_store_board set imagename='당신의 이상적인 히로인' where seq=104;

--------------------------------------------------------------------------------
-- 자주 찾는 질문글 관련 테이블 생성
create table movie_qna_board (
    seq number not null,                
    section varchar2(100) not null,
    subject varchar2(255) not null,
    content varchar2(4000) not null,
    logtime date default sysdate
);

-- 테이블 삭제
drop table movie_qna_board purge;
-- 테이블 목록 확인
select * from tab;
-- 테이블 구조
desc movie_qna_board;

-- 시퀀스 객체 생성
create sequence seq_movie_qna_board nocache nocycle;
-- 시퀀스 객체 삭제
drop sequence seq_movie_qna_board;
-- 시퀀스 조회
select * from user_sequences;
-- 다음 시퀀스값 확인 : 조회할 때마다 값이 증가됨
select seq_movie_qna_board.nextval from dual;
-- 현재 시퀀스값 확인
select seq_movie_qna_board.currval from dual;

-- 데이터 저장 : insert
insert into movie_qna_board values (seq_movie_qna_board.nextval, '[예매관람권]', '예매는 어떻게 하는건가요?', '냉무', sysdate);
insert into movie_qna_board values (seq_movie_qna_board.nextval, '[영화관이용]', '팝콘은 맛있나요?', '냉무', sysdate);
insert into movie_qna_board values (seq_movie_qna_board.nextval, '[홈페이지]', '회원 탈퇴는 어디서 하나요?', '냉무', sysdate);
-- 저장된 데이터 개수 확인
select count(*) as cnt from movie_qna_board;
-- 항목별
select count(*) as cnt from movie_qna_board where section='[홈페이지]';

-- 인덱스뷰
-- => 행번호 기준으로 데이터를 잘라서 가져오기
select * from (select rownum rn, tt.* from 
(select * from movie_qna_board order by seq desc) tt)
where rn>=1 and rn<=5;

-- 항목별 인덱스뷰
select * from (select rownum rn, tt.* from 
(select * from movie_qna_board where section='[홈페이지]' order by seq desc) tt)
where rn>=1 and rn<=5;

-- 전체 데이터 내림차순 정렬
select * from movie_qna_board order by seq desc;
-- 전체 데이터를 내림차순 정렬해서 가져온 값 + 행 번호 추가
select rownum rn, tt.* from 
(select * from movie_qna_board order by seq desc) tt;

-- 1) seq 기준 내림차순 정렬
select * from movie_qna_board order by seq desc;
-- 2) seq 기준 내림차순 정렬 결과에 별명 tt를 붙이고
--    그 값을 기준으로 rownum(행번호)와 검색 결과를 보여주기
select rownum rn, tt.* from 
(select * from movie_qna_board order by seq desc) tt;

-- 전체 내용 확인
select * from movie_qna_board;
-- 특정 글번호로 내용 확인
select * from movie_qna_board where section='[영화관이용]';

-- 데이터 수정 : update
update movie_qna_board set subject='내일은', content='크게 웃으리' where seq=1;

-- 데이터 삭제 : delete
delete movie_qna_board where seq=1;

-- db 저장
commit;

--------------------------------------------------------------------------------
-- 테이블 생성
create table movie_member (
    id varchar2(30) primary key,    -- unique, not null
    name varchar2(30) not null,
    pwd varchar2(30) not null,
    gender varchar2(5),
    email1 varchar2(20),
    email2 varchar2(20),
    tel1 varchar2(10),
    tel2 varchar2(10),
    tel3 varchar2(10),
    addr varchar2(100),
    grade varchar2(10),
    mvppoint number,
    point number,
    logtime date
);

-- 테이블 구조 확인
desc movie_member;

-- 테이블 삭제
drop table movie_member purge;

-- 테이블 목록보기
select * from tab;

-- 데이터 추가 (insert)
insert into movie_member values('hong', '홍길동', '1234', 'm', 'hong', 'naver.com', 
'010', '1234', '5678', '서울시 동작구', 'vip', 100, 5000, sysdate);

-- 데이터 검색 (select)
select * from movie_member;
select * from movie_member where id = 'hong';
-- 로그인 확인
select * from movie_member where id='hong' and pwd='1234';

-- 데이터 수정 (update)
update movie_member set tel2='2345' where id='hong';
update movie_member set gender='m' where id='hong';
update movie_member set id='hong' where id='hong2';

-- 데이터 삭제 (delete)
delete movie_member where id='hong';

-- db 저장
commit;

-- 시퀀스 객체 생성
create sequence seq_movieboard nocache nocycle;
-- 시퀀스 객체 삭제
drop sequence seq_movieboard;
-- 시퀀스 조회
select * from user_sequences;
-- 다음 시퀀스값 확인 : 조회할 때마다 값이 증가됨
select seq_movieboard.nextval from dual;
-- 현재 시퀀스값 확인
-- seq_board.currval : 반드시 nextval이 동작된 이후에만 확인 가능
select seq_movieboard.currval from dual;

-- 시퀀스 객체 생성

-- => 1~9 사이에서 2씩 증가
create sequence test increment by 2 
minvalue 1 maxvalue 9 nocache cycle; 
-- 다음 시퀀스값 확인
select test.nextval from dual;

---------------------------------------------------
-- 공지글관련 테이블 생성
create table movie_admin_board (
    seq number not null,                
    section varchar2(100) not null,
    subject varchar2(255) not null,
    content varchar2(4000) not null,
    logtime date default sysdate
);

-- 테이블 삭제
drop table movie_admin_board purge;
-- 테이블 목록 확인
select * from tab;

-- 시퀀스 객체 생성
create sequence seq_movie_admin_board nocache nocycle;
-- 시퀀스 객체 삭제
drop sequence seq_movie_admin_board;
-- 시퀀스 조회
select * from user_sequences;
-- 다음 시퀀스값 확인 : 조회할 때마다 값이 증가됨
select seq_movie_admin_board.nextval from dual;
-- 현재 시퀀스값 확인
select seq_movie_admin_board.currval from dual;

-- 데이터 저장 : insert
insert into movie_admin_board values (seq_movie_admin_board.nextval, '[극장]', '내일은 웃으리...', '내용', sysdate);
-- 저장된 데이터 개수 확인
select count(*) as cnt from movie_admin_board;

-- 인덱스뷰
-- => 행번호 기준으로 데이터를 잘라서 가져오기
select * from (select rownum rn, tt.* from 
(select * from movie_admin_board order by seq desc) tt)
where rn>=1 and rn<=5;

-- 
select seq, id, name, subject, content, hit, to_char(logtime, 'YYYY.MM.DD') as logtime from 
(select rownum rn, tt.* from 
(select * from movie_admin_board order by seq desc) tt)
where rn>=1 and rn<=5;

-- 전체 데이터 내림차순 정렬
select * from movie_admin_board order by seq desc;
-- 전체 데이터를 내림차순 정렬해서 가져온 값 + 행 번호 추가
select rownum rn, tt.* from 
(select * from movie_admin_board order by seq desc) tt;

-- 1) seq 기준 내림차순 정렬
select * from movie_admin_board order by seq desc;
-- 2) seq 기준 내림차순 정렬 결과에 별명 tt를 붙이고
--    그 값을 기준으로 rownum(행번호)와 검색 결과를 보여주기
select rownum rn, tt.* from 
(select * from movie_admin_board order by seq desc) tt;

-- 전체 내용 확인
select * from movie_admin_board;
-- 특정 글번호로 내용 확인
select * from movie_admin_board where seq=1;

-- 데이터 수정 : update
update movie_admin_board set subject='내일은', content='크게 웃으리' where seq=1;

-- 조회수 증가
select * from movieboard where seq=60;
update movieboard set hit = hit+1 where seq=60;

-- 데이터 삭제 : delete
delete movie_admin_board where seq=1;

-- db 저장
commit;