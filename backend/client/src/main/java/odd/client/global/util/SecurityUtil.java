package odd.client.global.util;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import odd.client.global.security.CustomUserDetails;

public class SecurityUtil {

    private SecurityUtil() {
    }

    public static String getCurrentUserNickname() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication != null && authentication.getPrincipal() instanceof CustomUserDetails customUserDetails) {
            return customUserDetails.getUser().getNickname();
        }

        return null;
    }
}
