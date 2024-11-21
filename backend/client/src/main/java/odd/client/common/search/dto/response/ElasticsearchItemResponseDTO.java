package odd.client.common.search.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Elasticsearch Item 응답 DTO")
public class ElasticsearchItemResponseDTO {

    @Schema(description = "상품 ID")
    private String itemId;

    @Schema(description = "상품명")
    private String itemName;

    @Schema(description = "플랫폼명")
    private String platform;

    @Schema(description = "서비스 타입")
    private List<String> serviceType;

    @Schema(description = "가격")
    private Integer price;

    @Schema(description = "상품 사진 URL")
    private String s3url;
}
