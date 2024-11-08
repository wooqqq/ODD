package odd.client.common.item.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Item 응답 DTO")
public class ItemResponseDTO {

    private Long itemId;
    private String ItemName;
    private String platform;
    private List<String> serviceType;
    private int price;
    private String s3url;
}