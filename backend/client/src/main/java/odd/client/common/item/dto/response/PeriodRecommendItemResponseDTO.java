package odd.client.common.item.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Getter
@Setter
@ToString
public class PeriodRecommendItemResponseDTO {

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
