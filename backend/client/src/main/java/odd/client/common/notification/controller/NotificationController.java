package odd.client.common.notification.controller;

import lombok.RequiredArgsConstructor;
import odd.client.common.notification.dto.response.NotificationListResponseDTO;
import odd.client.common.notification.dto.response.RecommendResponseDTO;
import odd.client.common.notification.service.NotificationMonitoringService;
import odd.client.common.notification.service.NotificationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/notification")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;
    private final NotificationMonitoringService monitoringService;

    @PostMapping("/send")
    public ResponseEntity<RecommendResponseDTO> sendNotification(
            @RequestParam String title,
            @RequestParam String body,
            @RequestParam Map<String, String> data) {
        RecommendResponseDTO response = notificationService.createAndSendNotification(title, body, data);

        return ResponseEntity.ok(response);
    }

    @GetMapping("/list")
    public ResponseEntity<NotificationListResponseDTO> getNotificationList() {
        NotificationListResponseDTO response = notificationService.getNotificationList();

        return ResponseEntity.ok(response);
    }

    // 주기별 재구매 추천 조회 확인용
    @GetMapping("/period")
    public void checkPeriod() {
        monitoringService.fetchRecommendations();
    }

    // time slots 조회 확인용
    @GetMapping("/user-time-slots")
    public void checkUserTimeSlots() {
        monitoringService.getUserTimeSlots();
    }

    // 시간대별 알림 전송 기능 확인용
    @GetMapping("/time-recom")
    public void checkTimeRecom() {
        monitoringService.getUserTimeSlots();
    }
}
