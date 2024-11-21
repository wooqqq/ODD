package odd.client.common.user.controller;

import jakarta.validation.Valid;
import odd.client.common.user.dto.request.EmailRequestDTO;
import odd.client.common.user.dto.request.LoginRequestDTO;
import odd.client.common.user.dto.request.RegisterRequestDTO;
import odd.client.common.user.dto.response.LoginResponseDTO;
import odd.client.common.user.dto.response.RegisterResponseDTO;
import odd.client.common.user.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth/user")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDTO> login(@Valid @RequestBody LoginRequestDTO loginRequestDTO) {
        LoginResponseDTO response = authService.login(loginRequestDTO);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/logout")
    public ResponseEntity<String> logout() {
        return ResponseEntity.ok("로그아웃 성공");
    }

    @PostMapping("/signup")
    public ResponseEntity<RegisterResponseDTO> register(@Valid @RequestBody RegisterRequestDTO registerRequestDTO) {
        RegisterResponseDTO response = authService.register(registerRequestDTO);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/duplication")
    public ResponseEntity<Boolean> checkEmailDuplication(@Valid @RequestBody EmailRequestDTO emailRequestDTO) {
        boolean isDuplicate = authService.checkEmailDuplication(emailRequestDTO.getEmail());
        return ResponseEntity.ok(isDuplicate);
    }

}
