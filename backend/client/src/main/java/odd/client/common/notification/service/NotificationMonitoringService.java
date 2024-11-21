package odd.client.common.notification.service;

import lombok.RequiredArgsConstructor;
import odd.client.common.item.model.Item;
import odd.client.common.item.repository.ItemRepository;
import odd.client.common.notification.dto.response.PeriodNotificationDTO;
import odd.client.common.notification.dto.response.PeriodRecommendationDTO;
import odd.client.common.notification.dto.response.PeriodResponseDTO;
import odd.client.common.notification.dto.response.TimeSlotsResponseDTO;
import odd.client.common.notification.repository.NotificationRepository;
import odd.client.common.user.model.GsUser;
import odd.client.common.user.model.User;
import odd.client.common.user.repository.GsUserRepository;
import odd.client.common.user.repository.UserRepository;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationMonitoringService {

    private final WebClient webClient;
    private final UserRepository userRepository;
    private final ItemRepository itemRepository;
    private final GsUserRepository gsUserRepository;
    private final NotificationService notificationService;

    private List<PeriodResponseDTO> periodNotifications;
    

    @Scheduled(cron = "0 0 12 * * *") // 매일 오후 12시 실행
    public void getPeriodRecommendations() {
        // 1. 주기별 추천 대상 불러오기
        List<PeriodResponseDTO> periodResponseDTOList = fetchRecommendations();

        // 2. 알림으로 만들기
        List<PeriodNotificationDTO> notifications = periodResponseDTOList.stream()
                .map(response -> {
                    Item item = itemRepository.findById(response.getItemId())
                            .orElse(null);

                    User user = userRepository.findById(response.getUserId())
                            .orElseThrow(() -> new IllegalArgumentException("해당 사용자가 존재하지 않습니다."));

                    return PeriodNotificationDTO.createResponseDTO(user.getId(), user.getNickname(), item);
                })
                .filter(response -> response != null)
                .toList();

        // 3. 알림 전송
        for (PeriodNotificationDTO notification : notifications) {
            notificationService.sendRecommendNotification(notification.getUserId(), notification.getTitle(), notification.getBody(), notification.getData());
        }
    }

    @Scheduled(cron = "0 0 11 * * *") // 매일 오전 11시 실행
    public List<PeriodResponseDTO> fetchRecommendations() {
        // 1. api 호출로 결과값 가져오기
        List<PeriodRecommendationDTO> periodRecommendations = webClient.get()
                .uri("/period/all")
                .retrieve()
                .bodyToFlux(PeriodRecommendationDTO.class)
                .doOnError(error -> System.out.println(
                        "Error occurred while making WebClient request: " + error.getMessage()))
                .collectList()
                .block();

        System.out.println("Received items: " + periodRecommendations);

        // 2. 해당하는 추천 알림 폼 만들어서 임시 저장해두기
        periodNotifications = periodRecommendations.stream()
                .map(recommend -> {
                    Item item = itemRepository.findById(recommend.getItemId())
                            .orElse(null);

                    GsUser gsUser = gsUserRepository.findByGsUserId(recommend.getUserId())
                            .orElseThrow(() -> new IllegalArgumentException("해당 사용자가 존재하지 않습니다."));

                    return PeriodResponseDTO.fromJsonToDto(gsUser.getUser().getId(), recommend.getItemId(),
                            recommend.getItemName(), recommend.getRecommendationDate(), recommend.getPurchaseDates());
                })
                .filter(response -> response != null)
                .toList();

        // 3. 위 메서드로 보내주기
        return periodNotifications;
    }

    @Scheduled(cron = "0 0 0 * * *")
    public void getUserTimeSlots() {
        // 1. api 호출로 결과값 가져오기
        List<TimeSlotsResponseDTO> timeRecommendations = webClient.get()
                .uri("/user-time-slots")
                .retrieve()
                .bodyToFlux(TimeSlotsResponseDTO.class)
                .doOnError(error -> System.out.println(
                        "Error occurred while making WebClient request: " + error.getMessage()))
                .collectList()
                .block();

        System.out.println("Received items: " + timeRecommendations);
        // Received items: [TimeSlotsResponseDTO(userId=dummy1, timeSlots=[8, 19]), TimeSlotsResponseDTO(userId=dummy2, timeSlots=[19])]

        for (TimeSlotsResponseDTO timeRecommendation : timeRecommendations) {
            GsUser gsUser = gsUserRepository.findByGsUserId(timeRecommendation.getUserId())
                    .orElse(null);

            if (gsUser != null) {
                Long userId = gsUser.getUser().getId();
                notificationService.sendTimeSlotNotification(userId, timeRecommendation.getTimeSlots());
            }
        }
    }

}
