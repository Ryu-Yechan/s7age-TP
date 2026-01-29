-- 테이블 생성
USE stage;

-- 1. 사용자 기본 정보
CREATE TABLE IF NOT EXISTS user_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    status ENUM('ACTIVE','INACTIVE','LOCKED','DELETED') DEFAULT 'ACTIVE'
);

-- 2. 비밀번호 기반 인증 정보
CREATE TABLE IF NOT EXISTS user_credential (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    last_password_change DATETIME,
    login_attempts INT NOT NULL DEFAULT 0,
    locked_until DATETIME,
    CONSTRAINT uq_user_credential_user UNIQUE (user_id),
    CONSTRAINT fk_user_credential_user FOREIGN KEY (user_id) REFERENCES user_info(id)
);

-- 4. 인증 제공자 정보
CREATE TABLE IF NOT EXISTS auth_provider (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name ENUM('GOOGLE','NAVER','KAKAO','APPLE','GITHUB') UNIQUE NOT NULL,
    authorization_endpoint VARCHAR(500),
    token_endpoint VARCHAR(500),
    userinfo_endpoint VARCHAR(500),
    client_id VARCHAR(255),
    client_secret VARCHAR(255)
);

-- 5. 소셜/외부 로그인 정보
CREATE TABLE IF NOT EXISTS auth_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    provider_id BIGINT NOT NULL,
    external_user_id VARCHAR(255) NOT NULL,
    access_token TEXT,
    refresh_token TEXT,
    scope VARCHAR(255),
    expires_at DATETIME,
    linked_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (provider_id, external_user_id),
    FOREIGN KEY (user_id) REFERENCES user_info(id),
    FOREIGN KEY (provider_id) REFERENCES auth_provider(id)
);

-- 7. 예약된 좌석 테이블
CREATE TABLE IF NOT EXISTS seat (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    kopis_id VARCHAR(255) NOT NULL,
    show_datetime DATETIME NOT NULL,
    round INT NOT NULL,
    seat_number VARCHAR(50) NOT NULL,
    price INT NOT NULL,
    UNIQUE (kopis_id, show_datetime, round, seat_number)
);

-- 8. 공연 테이블
CREATE TABLE IF NOT EXISTS show_detail (
    id BIGINT NOT NULL AUTO_INCREMENT,
    kopis_id VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    place VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    running_time VARCHAR(100),
    age_limit VARCHAR(50),
    genre VARCHAR(50),
    poster_url VARCHAR(500),
    price_info TEXT,
    casting_info TEXT,
    crew_info TEXT,
    schedule_info TEXT,
    intro_image_urls TEXT,
    description TEXT,
    status ENUM('ONGOING', 'SCHEDULED', 'CLOSED', 'CANCELED') NOT NULL DEFAULT 'SCHEDULED',
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id)
);

-- 9. 마이페이지 공연 기록 테이블
CREATE TABLE IF NOT EXISTS user_reservation (
    id BIGINT NOT NULL AUTO_INCREMENT,
    reserve_number VARCHAR(255) NOT NULL UNIQUE,
    user_id BIGINT NOT NULL,
    show_name VARCHAR(255) NOT NULL,
    seat_number VARCHAR(255),
    start_time DATETIME NOT NULL,
    PRIMARY KEY (id)
);