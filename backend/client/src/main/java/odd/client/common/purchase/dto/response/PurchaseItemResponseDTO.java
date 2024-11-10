package odd.client.common.purchase.dto.response;

import lombok.Getter;
import lombok.Setter;
import odd.client.common.item.dto.response.ItemResponseDTO;


@Getter
@Setter
public class PurchaseItemResponseDTO extends ItemResponseDTO {
    private int count;
}
