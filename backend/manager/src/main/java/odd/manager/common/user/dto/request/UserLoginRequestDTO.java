package odd.manager.common.user.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;

@Getter
public class UserLoginRequestDTO {

    @NotBlank
    private String email;

    @NotBlank
    private String password;
}
