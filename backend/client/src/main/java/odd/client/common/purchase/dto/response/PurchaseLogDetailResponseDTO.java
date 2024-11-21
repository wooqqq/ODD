package odd.client.common.purchase.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;
import java.util.List;
import lombok.Getter;
import lombok.Setter;
import odd.client.common.purchase.dto.PurchaseLogDTO;

@Getter
@Setter
@Schema(description = "Purchase Log 상세 응답 DTO")
public class PurchaseLogDetailResponseDTO extends PurchaseLogDTO {

    @Schema(description = "구매 상품 목록")
    private List<PurchaseItemResponseDTO> items;

    public PurchaseLogDetailResponseDTO(Long purchaseId, String platform, String serviceType, Integer totalPrice,
                                        LocalDateTime purchaseDate) {
        super(purchaseId, platform, serviceType, totalPrice, purchaseDate);
    }
}