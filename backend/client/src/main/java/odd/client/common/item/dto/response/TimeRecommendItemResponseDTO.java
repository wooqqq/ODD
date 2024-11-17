package odd.client.common.item.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class TimeRecommendItemResponseDTO {

    @JsonProperty("user_id")
    private String userId;

    @JsonProperty("item_id")
    private String itemId;

    @JsonProperty("item_name")
    private String itemName;

    @JsonProperty("purchase_count")
    private int purchaseCount;

}
