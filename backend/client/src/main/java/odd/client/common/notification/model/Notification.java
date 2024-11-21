package odd.client.common.notification.model;

import jakarta.persistence.Id;
import lombok.Builder;
import lombok.Getter;
import odd.client.common.item.model.Platform;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.Map;

@Getter
@Builder
@Document(collection = "notification")
public class Notification {

    @Id
    private String id;

    private Long userId;

    private String content;

    private LocalDateTime createDate;

    private Map<String, String> data;

    @Override
    public String toString() {
        return "Notification [id=" + id + ", userId=" + userId + ", content=" + content
                + ", date=" + createDate + ", data=" + data + "]";
    }
}
