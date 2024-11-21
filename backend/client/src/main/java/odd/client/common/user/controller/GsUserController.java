package odd.client.common.user.controller;

import lombok.RequiredArgsConstructor;
import odd.client.common.user.dto.request.GsUserRegisterRequestDTO;
import odd.client.common.user.dto.response.GsUserRegisterResponseDTO;
import odd.client.common.user.service.GsUserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/gs-user")
@RequiredArgsConstructor
public class GsUserController {

    private final GsUserService gsUserService;

    @PostMapping("/create")
    public ResponseEntity<?> registerGsUser(@RequestBody GsUserRegisterRequestDTO requestDTO) {
        GsUserRegisterResponseDTO response = gsUserService.createGsUser(requestDTO);

        return ResponseEntity.ok(response);
    }
}
