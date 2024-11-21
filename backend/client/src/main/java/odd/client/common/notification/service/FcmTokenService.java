package odd.client.common.notification.service;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;

@Service
@RequiredArgsConstructor
public class FcmTokenService {

    private final RedisTemplate<String, String> redisTemplate;
    private static final String FCM_TOKEN_PREFIX = "fcmToken:";

    public void saveFcmToken(Long userId, String fcmToken) {
        String key = FCM_TOKEN_PREFIX + userId;
        redisTemplate.opsForValue().set(key, fcmToken);
        // 추후 필요하다면 만료 시간 수정 예정 (기본값: 30일)
        redisTemplate.expire(key, Duration.ofDays(30));
    }

    public String getFcmToken(Long userId) {
        String key = FCM_TOKEN_PREFIX + userId;
        return redisTemplate.opsForValue().get(key);
    }

    public void deleteFcmToken(Long userId) {
        String key = FCM_TOKEN_PREFIX + userId;
        redisTemplate.delete(key);
    }

}
