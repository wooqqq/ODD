package odd.manager.common.user.dto.response;

import lombok.Data;

@Data
public class UserResponseDTO {
    private String userId;
    private String nickname;
    private int age;
    private String gender;
}
