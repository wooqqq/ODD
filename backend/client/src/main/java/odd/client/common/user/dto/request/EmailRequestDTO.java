package odd.client.common.user.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema(description = "이메일 중복 체크 요청 DTO")
public class EmailRequestDTO {

    @NotBlank(message = "이메일은 필수 항목입니다.")
    @Email(message = "올바른 이메일 형식을 입력해 주세요.")
    @Schema(description = "이메일", example = "user@example.com")
    private String email;
}
