package odd.client.common.evaluation.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class PurchaseCycleItemResponseDTO {
    private String itemId;
    private String itemName;
    private String recommendationDate;
    private List<String> purchaseDates;
}
