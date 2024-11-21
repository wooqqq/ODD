package odd.client.global.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;

@Component
public class JwtUtil {

    private final SecretKey secretKey;
    private final long accessTokenExpirationTime;
    private final long refreshTokenExpirationTime;

    public JwtUtil(@Value("${jwt.secret}") String secretKey,
                   @Value("${jwt.access-expiration-time}") long accessTokenExpirationTime,
                   @Value("${jwt.refresh-expiration-time}") long refreshTokenExpirationTime) {
        this.secretKey = Keys.hmacShaKeyFor(secretKey.getBytes());
        this.accessTokenExpirationTime = accessTokenExpirationTime;
        this.refreshTokenExpirationTime = refreshTokenExpirationTime;
    }

    public String generateToken(String username, Long userId) {
        Date now = new Date();
        Date expiration = new Date(now.getTime() + accessTokenExpirationTime);

        String token = Jwts.builder()
                .setSubject(username)
                .claim("userId", userId)
                .setIssuedAt(now)
                .setExpiration(expiration)
                .signWith(secretKey, SignatureAlgorithm.HS256)
                .compact();

        System.out.println("Generated Token: " + token); // 디버깅 로그
        return token;
    }

    public String generateRefreshToken(String username) {
        Date now = new Date();
        Date expiration = new Date(now.getTime() + refreshTokenExpirationTime);

        String refreshToken = Jwts.builder()
                .setSubject(username)
                .setIssuedAt(now)
                .setExpiration(expiration)
                .signWith(secretKey, SignatureAlgorithm.HS256)
                .compact();

        System.out.println("Generated Refresh Token: " + refreshToken); // 디버깅 로그
        return refreshToken;
    }

    public String getUsernameFromToken(String token) {
        try {
            Claims claims = Jwts.parser()
                    .setSigningKey(secretKey)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
            String username = claims.getSubject();
            System.out.println("Extracted Username: " + username); // 디버깅 로그
            return username;
        } catch (Exception e) {
            System.out.println("Failed to extract username from token: " + e.getMessage()); // 에러 로그
            return null;
        }
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parser()
                    .setSigningKey(secretKey)
                    .build()
                    .parseClaimsJws(token);
            System.out.println("Token is valid"); // 디버깅 로그
            return true;
        } catch (Exception e) {
            System.out.println("Invalid token: " + e.getMessage()); // 에러 로그
            return false;
        }
    }
}
