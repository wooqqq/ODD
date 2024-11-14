package odd.manager.common.user.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;

@Getter
public class UserLoginRequestDTO {

    @NotBlank
    private String id;

    @NotBlank
    private String password;
}
