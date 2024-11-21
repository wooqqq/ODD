package odd.client.common.item.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import odd.client.common.item.model.Item;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Item 응답 DTO")
public class ItemResponseDTO {

    @Schema(description = "상품 ID")
    private String itemId;

    @Schema(description = "상품명")
    private String itemName;

    @Schema(description = "플랫폼명")
    private String platform;

    @Schema(description = "서비스 타입")
    private List<String> serviceType;

    @Schema(description = "가격")
    private int price;

    @Schema(description = "상품 사진 URL")
    private String s3url;

    public static ItemResponseDTO createResponseDTO(Item item, String platform, List<String> serviceType) {
        return ItemResponseDTO.builder()
                .itemId(item.getId())
                .itemName(item.getBdItemNm())
                .platform(platform)
                .serviceType(serviceType)
                .price(item.getPrice())
                .s3url(item.getS3Url())
                .build();
    }
}