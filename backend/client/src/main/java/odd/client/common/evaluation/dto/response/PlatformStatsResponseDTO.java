package odd.client.common.evaluation.dto.response;

import java.util.List;
import java.util.Map;
import lombok.Data;

@Data
public class PlatformStatsResponseDTO {
    private List<Map<String, Integer>> view;
    private List<Map<String, Integer>> cart;
    private List<Map<String, Integer>> order;
}
