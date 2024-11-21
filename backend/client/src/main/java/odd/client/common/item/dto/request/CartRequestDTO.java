package odd.client.common.item.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Cart 요청 DTO")
public class CartRequestDTO {

    @Schema(description = "상품ID", example = "9800800056")
    private String itemId;

    @Schema(description = "상품 개수", example = "2")
    private int count;

    @Schema(description = "플랫폼", example = "GS25")
    private String platform;

    @Schema(description = "서비스 유형", example = "배달")
    private String serviceType;
}
