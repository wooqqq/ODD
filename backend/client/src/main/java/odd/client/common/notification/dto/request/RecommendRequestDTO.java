package odd.client.common.notification.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;

@Getter
public class RecommendRequestDTO {

    @NotNull
    @Schema(description = "추천을 받을 사용자 ID")
    private Long userId;
}
