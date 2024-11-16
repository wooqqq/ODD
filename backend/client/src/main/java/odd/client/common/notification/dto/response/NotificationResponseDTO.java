package odd.client.common.notification.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class NotificationResponseDTO {

    private String itemId;

    private String platform;

    private String content;

    private String date;
}
