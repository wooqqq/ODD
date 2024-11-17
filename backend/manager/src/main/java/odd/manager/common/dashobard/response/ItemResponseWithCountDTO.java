package odd.manager.common.dashobard.response;

import lombok.Getter;
import lombok.experimental.SuperBuilder;
import odd.manager.common.evaluation.dto.response.ItemResponseDTO;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@SuperBuilder
public class ItemResponseWithCountDTO extends ItemResponseDTO {
    private long count;
}