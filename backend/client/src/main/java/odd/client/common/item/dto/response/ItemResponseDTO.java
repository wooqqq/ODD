package odd.client.common.item.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;
import odd.client.common.item.entity.Platform;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Item 응답 DTO")
public class ItemResponseDTO {

    private Long Id;
    private String productName;
    private List<Platform> platform;
    private List<String> orderType;
    private int price;
    private String s3url;
}