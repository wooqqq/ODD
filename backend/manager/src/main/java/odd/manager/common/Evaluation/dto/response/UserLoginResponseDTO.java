package odd.manager.common.Evaluation.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
@Schema(description = "회원가입 결과 DTO")
public class UserLoginResponseDTO {

    @Schema(description = "성공 여부")
    private boolean success;

    @Schema(description = "메시지")
    private String message;

}
