package odd.manager.common.user.controller;

import lombok.RequiredArgsConstructor;
import odd.manager.common.user.dto.request.UserLoginRequestDTO;
import odd.manager.common.user.dto.response.UserLoginResponseDTO;
import odd.manager.common.user.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping("/login")
    public ResponseEntity<UserLoginResponseDTO> login(@RequestBody UserLoginRequestDTO requestDTO) {
        UserLoginResponseDTO response = userService.login(requestDTO);

        return ResponseEntity.ok(response);
    }
}
