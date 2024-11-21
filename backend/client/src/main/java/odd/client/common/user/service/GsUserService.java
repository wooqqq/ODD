package odd.client.common.user.service;

import lombok.RequiredArgsConstructor;
import odd.client.common.user.dto.request.GsUserRegisterRequestDTO;
import odd.client.common.user.dto.response.GsUserRegisterResponseDTO;
import odd.client.common.user.dto.response.RegisterResponseDTO;
import odd.client.common.user.model.GsUser;
import odd.client.common.user.model.User;
import odd.client.common.user.repository.GsUserRepository;
import odd.client.common.user.repository.UserRepository;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class GsUserService {

    private final UserRepository userRepository;
    private final GsUserRepository gsUserRepository;

    public GsUserRegisterResponseDTO createGsUser(GsUserRegisterRequestDTO requestDTO) {
        User user = userRepository.findById(requestDTO.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        GsUser gsUser = GsUser.builder()
                .user(user)
                .gsUserId(requestDTO.getGsUserId())
                .build();

        gsUserRepository.save(gsUser);

        return new GsUserRegisterResponseDTO(true, "GS 사용자 등록이 성공적으로 완료되었습니다.");
    }
}
