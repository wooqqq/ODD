package odd.client.common.evaluation.dto.response;

import java.util.List;
import lombok.Data;

@Data
public class PurchaseLogResponseDTO {
    private String id;
    private String purchaseDate;
    private List<PurchaseItemDTO> items;

    @Data
    public static class PurchaseItemDTO {
        private String id;
        private String itemName;
        private int count;
    }
}
