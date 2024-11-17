package odd.manager.common.dashobard.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AgeGroupResponseDTO {
    private int teens;

    private int twenties;

    private int thirties;

    private int forties;

    private int other;

}
