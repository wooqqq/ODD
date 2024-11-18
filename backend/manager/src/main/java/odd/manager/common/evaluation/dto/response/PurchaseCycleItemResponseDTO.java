package odd.manager.common.evaluation.dto.response;

import lombok.Data;

import java.util.List;

@Data
public class PurchaseCycleItemResponseDTO {
    private String id;
    private String itemName;
    private String recommendationDate;
    private List<String> purchaseDates;
}
