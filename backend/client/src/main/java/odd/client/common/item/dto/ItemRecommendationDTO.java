package odd.client.common.item.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ItemRecommendationDTO {

    @JsonProperty("item_id")
    private String itemId;

    @JsonProperty("item_name")
    private String itemName;

    @JsonProperty("recommendation_date")
    private String recommendationDate;

    @JsonProperty("purchase_dates")
    private List<String> purchaseDates;

}
