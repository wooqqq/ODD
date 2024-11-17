package odd.manager.common.evaluation.dto.response;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Data
@SuperBuilder
@NoArgsConstructor
public class ItemResponseDTO {
    private String id;
    private String itemName;
}
