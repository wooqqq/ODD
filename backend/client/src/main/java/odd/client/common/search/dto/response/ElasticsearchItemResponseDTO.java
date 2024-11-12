package odd.client.common.search.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Elasticsearch Item 응답 DTO")
public class ElasticsearchItemResponseDTO {

    @Schema(description = "상품 ID")
    private Long itemId;

    @Schema(description = "상품명")
    private String itemName;
}
