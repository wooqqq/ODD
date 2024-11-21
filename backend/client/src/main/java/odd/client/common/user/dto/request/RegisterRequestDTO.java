package odd.client.common.user.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
@Schema(description = "회원가입 요청 DTO")
public class RegisterRequestDTO {

    @NotBlank
    @Email
    @Schema(description = "인증할 이메일")
    private String email;

    @NotBlank
    @Size(min = 4, max = 20, message = "비밀번호는 최소 4자 이상이어야 합니다.")
    @Schema(description = "로그인 시 사용될 비밀번호")
    private String password;

    @NotBlank
    @Size(min = 4, max = 20, message = "비밀번호 확인은 최소 4자 이상이어야 합니다.")
    @Schema(description = "비밀번호 확인")
    private String confirmPassword;

    @NotBlank
    @Size(min = 2, max = 20)
    @Schema(description = "닉네임")
    private String nickname;

    @NotBlank
    @Schema(description = "성별", allowableValues = {"M", "W"})
    private String gender;

    @NotNull
    @Schema(description = "생년월일 (형식: YYYY-MM-DD)")
    private LocalDate birthday;

    @NotEmpty(message = "Favorite categories cannot be empty")
    @Size(min = 3, max = 3, message = "선호 카테고리는 3개를 선택해야 합니다.")
    @Schema(description = "선호 카테고리 (3개 필수 선택)")
    private List<String> favoriteCategories;
}
