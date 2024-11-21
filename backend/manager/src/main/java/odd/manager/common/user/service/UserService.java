package odd.manager.common.user.service;

import odd.manager.common.user.dto.request.UserLoginRequestDTO;
import odd.manager.common.user.dto.response.UserLoginResponseDTO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Value("${admin.account.id}")
    private String adminAccountId;

    @Value("${admin.account.password}")
    private String adminAccountPassword;

    public UserLoginResponseDTO login(UserLoginRequestDTO requestDTO) {
        if (!adminAccountId.equals(requestDTO.getId()) || !adminAccountPassword.equals(requestDTO.getPassword()))
            return new UserLoginResponseDTO(false, "존재하지 않는 관리자 계정입니다.");

        return new UserLoginResponseDTO(true, "관리자 계정 로그인에 성공했습니다.");
    }
}
