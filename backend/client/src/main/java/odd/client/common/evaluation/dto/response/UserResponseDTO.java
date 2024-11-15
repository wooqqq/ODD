package odd.client.common.evaluation.dto.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class UserResponseDTO {
    private String userId;
    private String nickname;
    private int age;
    private String gender;

    public Integer getAge() {
        return age == 0 ? null : age;
    }
}
