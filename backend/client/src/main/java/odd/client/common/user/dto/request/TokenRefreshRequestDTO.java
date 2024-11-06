package odd.client.common.user.dto.request;

import lombok.Data;

@Data
public class TokenRefreshRequestDTO {
    private String refreshToken;
}
