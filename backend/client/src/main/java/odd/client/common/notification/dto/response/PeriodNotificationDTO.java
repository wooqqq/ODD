package odd.client.common.notification.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import odd.client.common.item.model.Item;
import odd.client.common.item.model.Platform;

import java.util.HashMap;
import java.util.Map;

@Getter
@Builder
@AllArgsConstructor
public class PeriodNotificationDTO {

    private Long userId;

    private String title;

    private String body;

    private Map<String, String> data;

    public static PeriodNotificationDTO createResponseDTO(Long userId, String userName, Item item) {
        String title = "GS더프레시";
        String body = String.format("%s 님! %s 필요하지 않으세요?", userName, item.getBdItemNm());

        Map<String, String> data = new HashMap<>();
        data.put("itemId", item.getId());
        data.put("platform", Platform.GSFRESH.getDescription());

        return PeriodNotificationDTO.builder()
                .userId(userId)
                .title(title)
                .body(body)
                .data(data)
                .build();
    }
}
