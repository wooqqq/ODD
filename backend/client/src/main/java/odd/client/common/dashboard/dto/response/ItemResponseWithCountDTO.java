package odd.client.common.dashboard.dto.response;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import odd.client.common.evaluation.dto.response.ItemResponseDTO;

@Getter
@SuperBuilder
@NoArgsConstructor
public class ItemResponseWithCountDTO extends ItemResponseDTO {
    private long count;
}