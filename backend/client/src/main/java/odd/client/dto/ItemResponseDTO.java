package odd.client.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;
import odd.client.model.OrderType;
import odd.client.model.Platform;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Item 응답 DTO")
public class ItemResponseDTO {

    private Long Id;
    private String productName;
    private List<Platform> platform;
    private List<OrderType> orderType;
    private int price;
    private String s3url;
}