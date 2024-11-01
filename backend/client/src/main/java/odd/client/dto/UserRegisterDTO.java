package odd.client.dto;

import lombok.Data;
import java.time.LocalDate;
import java.util.List;

@Data
public class UserRegisterDTO {
    private String email;
    private String password;
    private String confirmPassword;
    private String nickname;
    private LocalDate birthdate;
    private String gender; // 'M' or 'W'
    private List<String> preferredCategories;
}