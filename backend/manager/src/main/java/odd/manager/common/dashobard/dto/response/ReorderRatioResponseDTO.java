package odd.manager.common.dashobard.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReorderRatioResponseDTO {

    private Long first;

    private Long secondOrMore;

    private String reorderRatio;
}
