package odd.client.common.evaluation.dto.response;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Getter
@SuperBuilder
@NoArgsConstructor
public class TimeRecItemResponseDTO extends ItemResponseDTO {
    private int purchaseCount;
}
