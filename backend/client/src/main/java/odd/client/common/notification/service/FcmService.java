package odd.client.common.notification.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
@RequiredArgsConstructor
public class FcmService {

    private final StringRedisTemplate redisTemplate;

    public void sendPushNotification(Long userId, String title, String body, Map<String, String> data) {
        String fcmToken = redisTemplate.opsForValue().get("fcmToken:" + userId);

        if (fcmToken == null) {
            throw new IllegalArgumentException("해당 유저의 FCM token이 존재하지 않습니다: " + userId);
        }

        // Notification 객체를 Builder로 생성
        Notification notification = Notification.builder()
                .setTitle(title)  // 제목 설정
                .setBody(body)    // 내용 설정
                .build();         // Builder로 객체 생성

        // FCM 메시지 구성
        Message.Builder messageBuilder = Message.builder()
                .setToken(fcmToken)
                .setNotification(notification);

        // 데이터 추가
        if (data != null && !data.isEmpty()) {
            messageBuilder.putAllData(data); // putAllData 로 data 를 추가
        }

        // 메시지 빌드
        Message message = messageBuilder.build();

        try {
            // FCM 서버로 메시지 전송
            String response = FirebaseMessaging.getInstance().send(message);
            System.out.println("message 전송 성공: " + response);
        } catch (Exception e) {
            System.out.println("message 전송 에러 발생: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
