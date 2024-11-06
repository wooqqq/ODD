package odd.client.global.util;

import org.springframework.security.core.context.SecurityContextHolder;

public class MemberInfo {

    private MemberInfo(){}

    public static String getId(){
        return SecurityContextHolder.getContext()
                        .getAuthentication()
                        .getName();
    }


}