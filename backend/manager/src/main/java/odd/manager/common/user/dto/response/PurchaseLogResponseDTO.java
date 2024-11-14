package odd.manager.common.user.dto.response;

import lombok.Data;
import java.util.List;

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
