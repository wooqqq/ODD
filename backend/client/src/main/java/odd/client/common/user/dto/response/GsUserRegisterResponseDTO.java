package odd.client.common.user.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@Schema(description = "GS 사용자 연결 성공 여부")
@AllArgsConstructor
public class GsUserRegisterResponseDTO {

    @Schema(description = "성공 여부")
    private boolean success;

    @Schema(description = "메시지")
    private String message;
}
