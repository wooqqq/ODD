package odd.client.common.user.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;

@Getter
public class GsUserRegisterRequestDTO {

    @NotNull
    @Schema(description = "프로젝트 내 사용자 ID")
    private Long userId;

    @NotBlank
    @Schema(description = "GS 데이터 내 사용자 ID")
    private String gsUserId;
}
