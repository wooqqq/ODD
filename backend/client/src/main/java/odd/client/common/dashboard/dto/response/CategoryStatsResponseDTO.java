package odd.client.common.dashboard.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CategoryStatsResponseDTO {
    private String category;
    private long viewCount;
    private long cartCount;
    private long orderCount;
    private long reorderCount;
}