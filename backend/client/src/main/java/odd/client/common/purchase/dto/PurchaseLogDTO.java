package odd.client.common.purchase.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Purchase Log 기본 DTO")
public class PurchaseLogDTO {

    @Schema(description = "구매 ID")
    private Long purchaseId;

    @Schema(description = "플랫폼")
    private String platform;

    @Schema(description = "서비스 타입")
    private String serviceType;

    @Schema(description = "총 가격")
    private Integer totalPrice;

    @Schema(description = "구매 일시")
    @JsonFormat(pattern = "yyyy.MM.dd HH:mm:ss")
    private LocalDateTime purchaseDate;
}