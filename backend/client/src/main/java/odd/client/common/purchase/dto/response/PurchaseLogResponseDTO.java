package odd.client.common.purchase.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import odd.client.common.purchase.dto.PurchaseLogDTO;

@Getter
@Setter
@Schema(description = "Purchase Log 응답 DTO")
public class PurchaseLogResponseDTO extends PurchaseLogDTO {

    @Schema(description = "대표 상품 이미지 URL")
    private String s3url;

    @Schema(description = "전체 상품 개수")
    private int totalCount;

    @Schema(description = "대표 상품 이름")
    private String firstProductName;

    public PurchaseLogResponseDTO(Long purchaseId, String platform, String serviceType, Integer totalPrice,
                                  LocalDateTime purchaseDate, String s3url, int totalCount,
                                  String firstProductName) {
        super(purchaseId, platform, serviceType, totalPrice, purchaseDate);
        this.s3url = s3url;
        this.totalCount = totalCount;
        this.firstProductName = firstProductName;
    }
}
