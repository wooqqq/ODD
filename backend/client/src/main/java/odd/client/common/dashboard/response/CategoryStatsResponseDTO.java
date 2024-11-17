package odd.client.common.dashboard.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CategoryStatsResponseDTO {
    private String category;
    private long viewCount;
    private long cartCount;
    private long purchaseCount;
    private long repurchaseCount;
    private double repurchaseRate;
}