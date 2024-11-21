package odd.client.common.notification.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.time.format.DateTimeFormatter;
import java.util.List;

@Getter
@Setter
@ToString
public class PeriodRecommendationDTO {

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @JsonProperty("user_id")
    private String userId;

    @JsonProperty("item_id")
    private String itemId;

    @JsonProperty("item_name")
    private String itemName;

    @JsonProperty("recommendation_date")
    private String recommendationDate;

    @JsonProperty("purchase_dates")
    private List<String> purchaseDates;

}
