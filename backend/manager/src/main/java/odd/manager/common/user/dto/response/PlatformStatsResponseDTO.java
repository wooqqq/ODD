package odd.manager.common.user.dto.response;

import lombok.Data;
import java.util.List;
import java.util.Map;

@Data
public class PlatformStatsResponseDTO {
    private List<Map<String, Integer>> view;
    private List<Map<String, Integer>> cart;
    private List<Map<String, Integer>> order;
}
