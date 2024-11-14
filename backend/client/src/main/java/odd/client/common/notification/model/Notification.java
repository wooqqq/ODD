package odd.client.common.notification.model;

import jakarta.persistence.Id;
import lombok.Builder;
import lombok.Getter;
import org.springframework.data.mongodb.core.mapping.Document;

@Getter
@Builder
@Document(collection = "notification")
public class Notification {

    @Id
    private String id;

    private Long userId;

    private String itemId;

    private String platform;

    private String content;

    private String date;
}
