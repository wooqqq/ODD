package odd.manager.common.Evaluation.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;

@Getter
public class UserLoginRequestDTO {

    @NotBlank
    private String id;

    @NotBlank
    private String password;
}
