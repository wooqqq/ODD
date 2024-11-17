package odd.manager.common.evaluation.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TimeRecItemResponseDTO {
    private String id;
    private String itemName;
    private int purchaseCount;
}
