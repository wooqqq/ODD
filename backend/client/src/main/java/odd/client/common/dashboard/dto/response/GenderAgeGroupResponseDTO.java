package odd.client.common.dashboard.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GenderAgeGroupResponseDTO {

    private AgeGroupResponseDTO female;
    private AgeGroupResponseDTO male;
}
