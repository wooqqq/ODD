package odd.client.common.user.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Data
@Schema(description = "회원가입 결과 DTO")
@AllArgsConstructor
public class RegisterResponseDTO {

    @Schema(description = "성공 여부")
    private boolean success;

    @Schema(description = "메시지")
    private String message;
}