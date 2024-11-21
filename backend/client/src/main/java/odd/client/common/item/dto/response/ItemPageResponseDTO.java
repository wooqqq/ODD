package odd.client.common.item.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Item Page 응답 DTO")
public class ItemPageResponseDTO {

    @Schema(description = "상품 정보 목록")
    private List<ItemResponseDTO> Items;

    @Schema(description = "현재 페이지 번호")
    private int pageNo;

    @Schema(description = "페이지별 상품 수 ")
    private int pageSize;

    @Schema(description = "전체 상품 수")
    private long totalItems;

    @Schema(description = "전체 페이지 수")
    private int totalPages;

    @Schema(description = "마지막 페이지 여부")
    private boolean last;
}