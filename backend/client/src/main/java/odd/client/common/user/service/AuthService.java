package odd.client.common.user.service;

import lombok.RequiredArgsConstructor;
import odd.client.common.notification.service.FcmTokenService;
import odd.client.common.user.dto.request.LoginRequestDTO;
import odd.client.common.user.dto.request.RegisterRequestDTO;
import odd.client.common.user.dto.response.LoginResponseDTO;
import odd.client.common.user.dto.response.RegisterResponseDTO;
import odd.client.common.user.model.User;
import odd.client.common.user.repository.UserRepository;
import odd.client.global.util.JwtUtil;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final FcmTokenService fcmTokenService;

    @Transactional
    public RegisterResponseDTO register(RegisterRequestDTO registerRequestDTO) {

        User user = new User();
        user.setEmail(registerRequestDTO.getEmail());
        user.setPassword(passwordEncoder.encode(registerRequestDTO.getPassword()));
        user.setNickname(registerRequestDTO.getNickname());
        user.setBirthday(registerRequestDTO.getBirthday());
        user.setGender(registerRequestDTO.getGender());
        user.setPoints(500000L);
        user.setFavoriteCategories(registerRequestDTO.getFavoriteCategories());

        userRepository.save(user);

        return new RegisterResponseDTO(true, "회원가입이 성공적으로 완료되었습니다.");
    }

    public LoginResponseDTO login(LoginRequestDTO loginRequestDTO) {
        User user = userRepository.findByEmail(loginRequestDTO.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("이메일 또는 비밀번호가 잘못되었습니다."));

        if (!passwordEncoder.matches(loginRequestDTO.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("이메일 또는 비밀번호가 잘못되었습니다.");
        }

        String accessToken = jwtUtil.generateToken(user.getEmail(), user.getId());
        String refreshToken = jwtUtil.generateRefreshToken(user.getEmail());

        // Redis 에 FCM 토큰 저장
        fcmTokenService.saveFcmToken(user.getId(), loginRequestDTO.getFcmToken());

        return new LoginResponseDTO(true, accessToken, refreshToken, "로그인 성공", user.getId());
    }

    public boolean checkEmailDuplication(String email) {
        // 로그 추가로 이메일 확인
        System.out.println("Checking email for duplication: " + email);
        boolean isDuplicate = userRepository.existsByEmail(email);
        System.out.println("Email duplication result: " + isDuplicate);
        return isDuplicate;
    }

}
