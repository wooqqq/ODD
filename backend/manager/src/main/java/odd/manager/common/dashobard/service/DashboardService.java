package odd.manager.common.dashobard.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import odd.manager.common.dashobard.dto.response.CategoryStatsResponseDTO;
import odd.manager.common.dashobard.dto.response.GenderAgeGroupResponseDTO;
import odd.manager.common.dashobard.dto.response.ItemResponseWithCountDTO;
import odd.manager.common.dashobard.dto.response.ReorderRatioResponseDTO;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class DashboardService {

    private final WebClient webClient;
    private static final String BASE_PATH = "/api/dashboard";

    public List<CategoryStatsResponseDTO> getCategoryStats(String data, String platform){
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path(BASE_PATH + "/item/categories/stats")
                        .queryParam("data", data)
                        .queryParam("platform", platform)
                        .build())
                .retrieve()
                .bodyToFlux(CategoryStatsResponseDTO.class)
                .collectList()
                .block();
    }

    public List<ItemResponseWithCountDTO> getTopRepurchaseItems(String data, String platform, String category) {
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path(BASE_PATH + "/item/top-repurchase")
                        .queryParam("data", data)
                        .queryParam("platform", platform)
                        .queryParam("category", category)
                        .build())
                .retrieve()
                .bodyToFlux(ItemResponseWithCountDTO.class)
                .collectList()
                .block();
    }

    public List<ItemResponseWithCountDTO> getTopViewedItems(String data, String platform, String category) {
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path(BASE_PATH + "/item/top-views")
                        .queryParam("data", data)
                        .queryParam("platform", platform)
                        .queryParam("category", category)
                        .build())
                .retrieve()
                .bodyToFlux(ItemResponseWithCountDTO.class)
                .collectList()
                .block();
    }

    public List<ItemResponseWithCountDTO> getTopCartItems(String data, String platform, String category) {
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path(BASE_PATH + "/item/top-cart")
                        .queryParam("data", data)
                        .queryParam("platform", platform)
                        .queryParam("category", category)
                        .build())
                .retrieve()
                .bodyToFlux(ItemResponseWithCountDTO.class)
                .collectList()
                .block();
    }

    public List<ItemResponseWithCountDTO> getTopPurchasedItems(String data, String platform, String category) {
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path(BASE_PATH + "/item/top-purchase")
                        .queryParam("data", data)
                        .queryParam("platform", platform)
                        .queryParam("category", category)
                        .build())
                .retrieve()
                .bodyToFlux(ItemResponseWithCountDTO.class)
                .collectList()
                .block();
    }

    public ReorderRatioResponseDTO getReorderUserRatio(String data, String platform) {
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path(BASE_PATH + "/user/reorder")
                        .queryParam("data", data)
                        .queryParam("platform", platform)
                        .build())
                .retrieve()
                .bodyToFlux(ReorderRatioResponseDTO.class)
                .blockFirst();
    }

    public GenderAgeGroupResponseDTO getReorderUserCountByAgeAndGender(String data, String platform) {
        return webClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path(BASE_PATH + "/user/reorder-age")
                        .queryParam("data", data)
                        .queryParam("platform", platform)
                        .build())
                .retrieve()
                .bodyToMono(GenderAgeGroupResponseDTO.class)
                .block();
    }

}
