package odd.client.common.notification.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import odd.client.common.item.model.Platform;
import odd.client.common.notification.dto.response.NotificationListResponseDTO;
import odd.client.common.notification.dto.response.NotificationResponseDTO;
import odd.client.common.notification.dto.response.RecommendResponseDTO;
import odd.client.common.notification.model.Notification;
import odd.client.common.notification.repository.NotificationRepository;
import odd.client.common.user.model.User;
import odd.client.common.user.repository.UserRepository;
import odd.client.global.util.UserInfo;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;
    private final FcmService fcmService;
    private final TaskScheduler taskScheduler;
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public RecommendResponseDTO createAndSendNotification(String title, String body, Map<String, String> data) {
        Long userId = UserInfo.getId();

        Notification notification = Notification.builder()
                .userId(userId)
                .content(body)
                .createDate(LocalDateTime.now())
                .data(data)
                .build();

        notificationRepository.save(notification);

        try {
            fcmService.sendPushNotification(userId, title, body, data);
            return new RecommendResponseDTO(true, "알림 생성 및 전송 성공");
        } catch (Exception e) {
            return new RecommendResponseDTO(false, "알림 전송 중 오류 발생: " + e.getMessage());
        }
    }

    public RecommendResponseDTO sendRecommendNotification(Long userId, String title, String body, Map<String, String> data) {
        Notification notification = Notification.builder()
                .userId(userId)
                .content(title)
                .createDate(LocalDateTime.now())
                .data(data)
                .build();

        notificationRepository.save(notification);

        try {
            fcmService.sendPushNotification(userId, title, body, data);
            return new RecommendResponseDTO(true, "알림 생성 및 전송 성공");
        } catch (Exception e) {
            return new RecommendResponseDTO(false, "알림 전송 중 오류 발생: " + e.getMessage());
        }
    }

    public RecommendResponseDTO sendTimeSlotNotification(Long userId, List<Integer> timeSlots) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("해당 사용자가 존재하지 않습니다."));

        for (int hour : timeSlots) {
            String body = String.format("%s 님, 이 상품을 구매할 시간입니다! (주문 시간대: %d 시)", user.getNickname(), hour);
            String title = "GS25";

            Map<String, String> data = new HashMap<>();
            data.put("platform", "GS25");

            scheduleNotification(userId, hour, title, body, data);
        }

        return new RecommendResponseDTO(true, "알림 예약 성공");
    }

    private void scheduleNotification(Long userId, int hour, String title,
                                      String body, Map<String, String> data) {
        LocalTime currentTime = LocalTime.now();
        LocalTime targetTime = LocalTime.of(hour, 0);

        long initialDelay = currentTime.until(targetTime, ChronoUnit.MINUTES);

        data.put("hour", String.valueOf(hour));

        if (initialDelay < 0) {
            initialDelay += 24 * 60;
        }

        System.out.println("여기는 hour: " + data.get("hour"));
        System.out.println("여기는 platform: " + data.get("platform"));

//        sendNotification(userId, title, body, data);
        taskScheduler.schedule(() -> {
            sendNotification(userId, title, body, data); // 알림 전송 메서드 호출
        }, new Date(System.currentTimeMillis() + initialDelay * 60 * 1000)); // 일정 시간 후 실행

    }

    private void sendNotification(Long userId, String title, String body, Map<String, String> data) {
        Notification notification = Notification.builder()
                .userId(userId)
                .content(body)
                .createDate(LocalDateTime.now())
                .data(data)
                .build();

        System.out.println(notification.toString());

        notificationRepository.save(notification);

        try {
            fcmService.sendPushNotification(userId, title, body, data);
            log.info("알림 전송 성공: userId=" + userId + ", title=" + title);
        } catch (Exception e) {
            log.error("알림 전송 실패: userId=" + userId + ", title=" + title, e);
        }
    }

    public NotificationListResponseDTO getNotificationList() {
        Long userId = UserInfo.getId();

        userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("해당 사용자는 존재하지 않습니다."));

        List<Notification> notificationList = notificationRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("해당 사용자에게 알림이 존재하지 않습니다."));

        List<NotificationResponseDTO> responseList = notificationList.stream()
                .sorted(Comparator.comparing(Notification::getCreateDate).reversed()) // 최신순 정렬
                .map(notification -> NotificationResponseDTO.builder()
                        .itemId(notification.getData().get("itemId"))
                        .platform(notification.getData().get("platform"))
                        .content(notification.getContent())
                        .date(notification.getCreateDate().format(DATE_FORMATTER)) // LocalDateTime을 String으로 변환
                        .build())
                .toList();

        return new NotificationListResponseDTO(true, "알림 목록 조회 성공", responseList);
    }
}
