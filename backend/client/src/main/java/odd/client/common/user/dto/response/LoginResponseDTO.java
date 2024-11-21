package odd.client.common.user.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "로그인 결과 DTO")
public class LoginResponseDTO {

    @Schema(description = "성공 여부")
    private boolean success;

    @Schema(description = "JWT 액세스 토큰")
    private String accessToken;

    @Schema(description = "JWT 리프레시 토큰")
    private String refreshToken;

    @Schema(description = "메시지")
    private String message;

    @Schema(description = "사용자 ID")
    private Long userId;
}

