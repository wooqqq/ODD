package odd.manager.common.evaluation.service;

import lombok.RequiredArgsConstructor;
import odd.manager.common.evaluation.dto.response.*;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class EvaluationService {

    private final WebClient webClient;

    public UserResponseDTO searchUserByEmail(String email) {
        return webClient.get()
                .uri("/api/evaluation/search/{email}", email)
                .retrieve()
                .bodyToMono(UserResponseDTO.class)
                .block();
    }

    public UserResponseDTO getUserInfo(String userId) {
        return webClient.get()
                .uri("/api/evaluation/{userId}", userId)
                .retrieve()
                .bodyToMono(UserResponseDTO.class)
                .block();
    }

    public PlatformStatsResponseDTO getPlatformStats(String userId) {
        return webClient.get()
                .uri("/api/evaluation/{userId}/platform-stats", userId)
                .retrieve()
                .bodyToMono(PlatformStatsResponseDTO.class)
                .block();
    }

    public List<ItemResponseDTO> getFavoriteCategoryItems(String userId, String platform) {
        return webClient.get()
                .uri("/api/evaluation/fav-category/{userId}/{platform}", userId, platform)
                .retrieve()
                .bodyToFlux(ItemResponseDTO.class)
                .collectList()
                .block();
    }

    public Map<Integer, List<TimeRecItemResponseDTO>> getTimeRecommendedItems(String userId) {
        Mono<Map<Integer, List<TimeRecItemResponseDTO>>> timeRecItemResponseDTOs = webClient.get()
                .uri("/api/evaluation/time-rec/{userId}", userId)
                .retrieve()
                .bodyToMono(new ParameterizedTypeReference<Map<Integer, List<TimeRecItemResponseDTO>>>() {});

        return timeRecItemResponseDTOs.block();
    }

    public List<PurchaseCycleItemResponseDTO> getPurchaseCycleItems(String userId) {
        return webClient.get()
                .uri("/api/evaluation/purchase-cycle/{userId}", userId)
                .retrieve()
                .bodyToMono(new ParameterizedTypeReference<List<PurchaseCycleItemResponseDTO>>() {})
                .block();
    }

    public List<PurchaseLogResponseDTO> getPurchaseItems(String userId, String platform) {
        return webClient.get()
                .uri("/api/evaluation/purchase/{userId}/{platform}", userId, platform)
                .retrieve()
                .bodyToMono(new ParameterizedTypeReference<List<PurchaseLogResponseDTO>>() {})
                .block();
    }

    public List<LogResponseDTO> getLogs(String userId, String platform) {
        return webClient.get()
                .uri("/api/evaluation/log/{userId}/{platform}", userId, platform)
                .retrieve()
                .bodyToFlux(LogResponseDTO.class)
                .collectList()
                .block();
    }
}
