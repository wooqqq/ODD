package odd.client.common.item.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Schema(description = "구매 획수가 포함된 상품 정보 응답 DTO")
public class ItemWithPurchaseCountRseponseDTO extends ItemResponseDTO {
    private int purchaseCount;

}
