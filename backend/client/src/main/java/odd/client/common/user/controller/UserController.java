package odd.client.common.user.controller;

import odd.client.global.util.SecurityUtil;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @PreAuthorize("isAuthenticated()")
    @GetMapping("/name")
    public String getUserName() {
        String nickname = SecurityUtil.getCurrentUserNickname();
        return nickname != null ? nickname : "사용자 정보가 올바르지 않습니다.";
    }
}
