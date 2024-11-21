package odd.client.common.purchase.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Purchase Log Page 응답 DTO")
public class PurchaseLogPageResponseDTO {

    @Schema(description = "구매 이력 목록")
    private List<PurchaseLogResponseDTO> purchases;

    @Schema(description = "현재 페이지 번호")
    private int pageNo;

    @Schema(description = "페이지별 구매 이력 수")
    private int pageSize;

    @Schema(description = "전체 구매 이력 수")
    private long totalPurchases;

    @Schema(description = "전체 페이지 수")
    private int totalPages;

    @Schema(description = "마지막 페이지 여부")
    private boolean last;
}