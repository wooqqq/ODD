package odd.client.global.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import odd.client.global.util.JwtUtil;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@RequiredArgsConstructor
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final UserDetailsService customUserDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        String requestURI = request.getRequestURI();
        System.out.println("Request URI: " + requestURI); // 디버깅 로그

        if (requestURI.equals("/client/api/auth/user/signup") ||
                requestURI.equals("/client/api/auth/user/login")) {
            System.out.println("Skipping JwtAuthFilter for: " + requestURI); // 디버깅 로그
            filterChain.doFilter(request, response);
            return;
        }

        String authorizationHeader = request.getHeader("Authorization");

        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            String token = authorizationHeader.substring(7);
            System.out.println("Token received: " + token); // 토큰 확인

            if (jwtUtil.validateToken(token)) {
                String username = jwtUtil.getUsernameFromToken(token);
                System.out.println("Username extracted: " + username); // 사용자명 확인
                UserDetails userDetails = customUserDetailsService.loadUserByUsername(username);

                if (userDetails != null) {
                    System.out.println("UserDetails loaded successfully");
                    UsernamePasswordAuthenticationToken authToken =
                            new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                    System.out.println("Authentication set in SecurityContextHolder");
                } else {
                    System.out.println("Failed to load UserDetails");
                }
            } else {
                System.out.println("Invalid token");
            }
        } else {
            System.out.println("No Authorization header found or invalid format");
        }

        filterChain.doFilter(request, response);
    }
}
