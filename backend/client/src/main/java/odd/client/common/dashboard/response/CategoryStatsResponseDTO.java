package odd.client.common.dashboard.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class CategoryStatsResponseDTO {
    private String category;
    private long viewCount;
    private long cartCount;
    private long purchaseCount;
    private long repurchaseCount;
    private double repurchaseRate;
}