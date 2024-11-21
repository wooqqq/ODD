package odd.client.common.notification.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
@Schema(description = "로그인 결과 DTO")
public class NotificationListResponseDTO {

    @Schema(description = "성공 여부")
    private boolean success;

    @Schema(description = "메시지")
    private String message;

    @Schema(description = "알림 리스트")
    private List<NotificationResponseDTO> notificationList;
}
