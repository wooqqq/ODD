package odd.client.common.evaluation.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import odd.client.common.evaluation.dto.response.ItemResponseDTO;
import odd.client.common.evaluation.dto.response.LogResponseDTO;
import odd.client.common.evaluation.dto.response.PlatformStatsResponseDTO;
import odd.client.common.evaluation.dto.response.PurchaseCycleItemResponseDTO;
import odd.client.common.evaluation.dto.response.PurchaseLogResponseDTO;
import odd.client.common.evaluation.dto.response.TimeRecItemResponseDTO;
import odd.client.common.evaluation.dto.response.UserResponseDTO;
import odd.client.common.item.dto.response.PeriodRecommendItemResponseDTO;
import odd.client.common.item.dto.response.TimeRecommendItemResponseDTO;
import odd.client.common.item.model.Item;
import odd.client.common.item.model.Platform;
import odd.client.common.item.repository.ItemRepository;
import odd.client.common.log.model.Log;
import odd.client.common.log.repository.LogRepository;
import odd.client.common.purchase.model.PurchaseItem;
import odd.client.common.purchase.model.PurchaseLog;
import odd.client.common.purchase.repository.PurchaseItemRepository;
import odd.client.common.purchase.repository.PurchaseLogRepository;
import odd.client.common.user.model.Category;
import odd.client.common.user.model.FavCategory;
import odd.client.common.user.model.GsUser;
import odd.client.common.user.model.User;
import odd.client.common.user.repository.GsUserRepository;
import odd.client.common.user.repository.UserFavoriteCategoriesRepository;
import odd.client.common.user.repository.UserRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

@Slf4j
@Service
@RequiredArgsConstructor
public class EvaluationService {

    private final GsUserRepository gsUserRepository;
    @Value("${FASTAPI_BASE_URL}")
    private String baseUrl;

    private final WebClient webClient;
    final private UserRepository userRepository;
    final private LogRepository logRepository;
    final private PurchaseLogRepository purchaseLogRepository;
    final private PurchaseItemRepository purchaseItemRepository;
    final private ItemRepository itemRepository;
    private final UserFavoriteCategoriesRepository userFavoriteCategoriesRepository;

    public UserResponseDTO searchUserByEmail(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다: " + email));

        // 예시로 더미 데이터를 반환하는 로직
        UserResponseDTO responseUser = new UserResponseDTO();
        responseUser.setUserId(String.valueOf(user.getId()));

        return responseUser;
    }

    public UserResponseDTO getUserInfo(String userId) {
        // 예시로 더미 데이터를 반환하는 로직
        User user = userRepository.findById(Long.valueOf(userId))
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다: " + userId));

        UserResponseDTO responseUser = new UserResponseDTO();
        responseUser.setUserId(String.valueOf(user.getId()));
        responseUser.setNickname(user.getNickname());
        responseUser.setAge(Period.between(user.getBirthday(), LocalDate.now()).getYears());
        responseUser.setGender(user.getGender());
        return responseUser;
    }

    public PlatformStatsResponseDTO getPlatformStats(String userId) {
        LocalDate startDate = LocalDate.now().minusDays(45);

        // 한 번의 쿼리로 로그 데이터 조회
        List<Log> logs = logRepository.findByUserIdAndDateAfter(userId, startDate);

        // 서비스와 inter별로 데이터 집계
        Map<String, Map<String, Integer>> serviceInterCounts = logs.stream()
                .collect(Collectors.groupingBy(
                        Log::getService,
                        Collectors.groupingBy(
                                Log::getInter,
                                Collectors.collectingAndThen(Collectors.counting(), Long::intValue)
                        )
                ));

        PlatformStatsResponseDTO responseDTO = new PlatformStatsResponseDTO();

        // view 데이터 설정
        List<Map<String, Integer>> viewData = Arrays.asList(
                Map.of("GS25", getCount(serviceInterCounts, "gs25", "view")),
                Map.of("GS더프레시", getCount(serviceInterCounts, "mart", "view")),
                Map.of("wine25", getCount(serviceInterCounts, "wine25", "view"))
        );

        // cart 데이터 설정
        List<Map<String, Integer>> cartData = new ArrayList<>();

        // GS25 cart
        Map<String, Integer> gs25Cart = new HashMap<>();
        gs25Cart.put("GS25_pickup", getCount(serviceInterCounts, "gs25_pickup", "cart"));
        gs25Cart.put("GS25_delivery", getCount(serviceInterCounts, "gs25_dlvy", "cart"));
        cartData.add(gs25Cart);

        // GS더프레시 cart
        Map<String, Integer> gsFreshCart = new HashMap<>();
        gsFreshCart.put("GS더프레시_pickup", getCount(serviceInterCounts, "mart_pickup", "cart"));
        gsFreshCart.put("GS더프레시_delivery", getCount(serviceInterCounts, "mart_dlvy", "cart"));
        cartData.add(gsFreshCart);

        // wine25 cart
        Map<String, Integer> wine25Cart = Map.of("wine25", getCount(serviceInterCounts, "wine25", "cart"));
        cartData.add(wine25Cart);

        // order 데이터 설정
        List<Map<String, Integer>> orderData = new ArrayList<>();

        // GS25 order
        Map<String, Integer> gs25Order = new HashMap<>();
        gs25Order.put("GS25_pickup", getCount(serviceInterCounts, "gs25_pickup", "order"));
        gs25Order.put("GS25_delivery", getCount(serviceInterCounts, "gs25_dlvy", "order"));
        orderData.add(gs25Order);

        // GS더프레시 order
        Map<String, Integer> gsFreshOrder = new HashMap<>();
        gsFreshOrder.put("GS더프레시_pickup", getCount(serviceInterCounts, "mart_pickup", "order"));
        gsFreshOrder.put("GS더프레시_delivery", getCount(serviceInterCounts, "mart_dlvy", "order"));
        orderData.add(gsFreshOrder);

        // wine25 order
        orderData.add(Map.of("wine25", getCount(serviceInterCounts, "wine25", "order")));

        responseDTO.setView(viewData);
        responseDTO.setCart(cartData);
        responseDTO.setOrder(orderData);

        return responseDTO;
    }

    private int getCount(Map<String, Map<String, Integer>> data, String service, String inter) {
        return data.getOrDefault(service, Collections.emptyMap())
                .getOrDefault(inter, 0);
    }

    public List<ItemResponseDTO> getFavoriteCategoryItems(String userId, String platformDescription) {
        int orderCount = purchaseLogRepository.countOrdersByUserId(Long.valueOf(userId));
        String uri;
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("user_id", userId);
        requestBody.put("platform", platformDescription);

        // 로깅 추가 - 요청 데이터 확인
        System.out.println("Generated request body: " + requestBody);

        if (orderCount >= 6) {
            uri = baseUrl + "/recommend/existing-user-category";
        } else {
            uri = baseUrl + "/recommend/new-user-category";

            List<String> favoriteCategories = userFavoriteCategoriesRepository.findByUserId(Long.parseLong(userId))
                    .stream()
                    .map(FavCategory::getCategory)
                    .map(Category::getCategoryName)
                    .toList();

            if (favoriteCategories.isEmpty()) {
                throw new IllegalStateException("사용자의 선호 카테고리가 없습니다.");
            }

            requestBody.put("new_user_category", favoriteCategories);
        }

        List<Map<String, Object>> rawResponse = webClient.post()
                .uri(uri)
                .contentType(MediaType.APPLICATION_JSON)
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + System.getenv("JWT_SECRET"))
                .bodyValue(requestBody)
                .retrieve()
                .bodyToFlux(new ParameterizedTypeReference<Map<String, Object>>() {
                })
                .collectList()
                .block();

        // 로깅 추가 - 반환된 항목 확인
        System.out.println("Received items: " + rawResponse);

        // Map에서 ItemResponseDTO로 변환
        List<ItemResponseDTO> items = rawResponse.stream()
                .map(map -> {
                    ItemResponseDTO item = new ItemResponseDTO();
                    item.setId(String.valueOf(map.get("itemId")));
                    item.setItemName((String) map.get("itemName"));
                    return item;
                })
                .toList();

        return items;
    }

    public Map<Integer, List<TimeRecItemResponseDTO>> getTimeRecommendedItems(String userId) {
        GsUser gsUser = gsUserRepository.findByUser_Id(Long.parseLong(userId))
                        .orElseThrow(() -> new IllegalArgumentException("연결된 GS 사용자 계정이 없습니다."));

        Map<String, String> requestBody = new HashMap<>();
        requestBody.put("user_id", gsUser.getGsUserId());

        List<TimeRecommendItemResponseDTO> itemRecommendations = webClient.post()
                .uri("/user-time-recommend")
                .contentType(MediaType.APPLICATION_JSON)
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + System.getenv("JWT_SECRET"))
                .bodyValue(requestBody)
                .retrieve()
                .bodyToFlux(TimeRecommendItemResponseDTO.class)
                .doOnError(error -> System.out.println(
                        "Error occurred while making WebClient request: " + error.getMessage()))
                .collectList()
                .block();

        Map<Integer, List<TimeRecItemResponseDTO>> timePatternMap = itemRecommendations.stream()
                .map(item -> {
                    TimeRecItemResponseDTO timeRecItem = TimeRecItemResponseDTO.builder()
                            .id(item.getItemId())
                            .itemName(item.getItemName())
                            .purchaseCount(item.getPurchaseCount())
                            .build();
                    return Map.entry(item.getTimePattern(), timeRecItem); // key-value 형태로 반환
                })
                .collect(Collectors.groupingBy(
                        Map.Entry::getKey,
                        Collectors.mapping(Map.Entry::getValue, Collectors.toList()) // value는 리스트로 수집
                ));

        return timePatternMap;
    }

    public List<PurchaseCycleItemResponseDTO> getPurchaseCycleItems(String userId) {
        GsUser gsUser = gsUserRepository.findByUser_Id(Long.parseLong(userId))
                .orElseThrow(() -> new IllegalArgumentException("연결된 GS 사용자 계정이 없습니다."));

        Map<String, String> requestBody = new HashMap<>();
        requestBody.put("user_id", gsUser.getGsUserId());

        List<PeriodRecommendItemResponseDTO> itemRecommendations = webClient.post()
                .uri("/period")
                .contentType(MediaType.APPLICATION_JSON)
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + System.getenv("JWT_SECRET"))
                .bodyValue(requestBody)
                .retrieve()
                .bodyToFlux(PeriodRecommendItemResponseDTO.class)
                .doOnError(error -> System.out.println(
                        "Error occurred while making WebClient request: " + error.getMessage()))
                .collectList()
                .block();

        assert itemRecommendations != null;

        return itemRecommendations.stream()
                .map(itemRec -> {
                    Item item = itemRepository.findById(itemRec.getItemId())
                            .orElse(null);

                    if (item != null) {
                        List<String> serviceTypes = new ArrayList<>();
                        if ("Y".equals(item.getIsMartDlvy())) {
                            serviceTypes.add("배달");
                        }
                        if ("Y".equals(item.getIsMartPickup())) {
                            serviceTypes.add("픽업");
                        }

                        return new PurchaseCycleItemResponseDTO(itemRec.getItemId(), itemRec.getItemName(),
                                itemRec.getRecommendationDate(), itemRec.getPurchaseDates());
                    }
                    return null;
                })
                .filter(Objects::nonNull)
                .toList();
    }

    public List<PurchaseLogResponseDTO> getPurchaseItems(String userId, String platformStr) {
        // Platform 문자열을 enum으로 변환
        Platform platform = Platform.fromDescription(platformStr);

        LocalDateTime sevenDaysAgo = LocalDateTime.now().minusDays(45);

        // 모든 구매 로그 조회
        List<PurchaseLog> purchaseLogs = purchaseLogRepository
                .findByUserIdAndPlatformAndCreateTimeAfter(Long.valueOf(userId), platform, sevenDaysAgo);

        if (purchaseLogs.isEmpty()) {
            return new ArrayList<>();
        }

        // 모든 로그 ID 수집
        List<Long> logIds = purchaseLogs.stream()
                .map(PurchaseLog::getId)
                .collect(Collectors.toList());

        // 모든 구매 아이템 한 번에 조회
        List<PurchaseItem> allPurchaseItems = purchaseItemRepository
                .findByLogIds(logIds);

        // 로그 ID별로 구매 아이템을 그룹화
        Map<Long, List<PurchaseItem>> itemsByLogId = allPurchaseItems.stream()
                .collect(Collectors.groupingBy(item -> item.getLog().getId()));

        // 각 로그에 대한 ResponseDTO 생성
        return purchaseLogs.stream()
                .map(log -> {
                    PurchaseLogResponseDTO responseDTO = new PurchaseLogResponseDTO();
                    responseDTO.setId(String.valueOf(log.getId()));
                    responseDTO.setPurchaseDate(log.getCreateTime()
                            .format(DateTimeFormatter.ofPattern("yyyy.MM.dd HH:mm")));

                    // 해당 로그의 아이템들을 DTO로 변환
                    List<PurchaseLogResponseDTO.PurchaseItemDTO> itemDTOs =
                            itemsByLogId.getOrDefault(log.getId(), new ArrayList<>())
                                    .stream()
                                    .map(item -> {
                                        PurchaseLogResponseDTO.PurchaseItemDTO itemDTO =
                                                new PurchaseLogResponseDTO.PurchaseItemDTO();
                                        itemDTO.setId(String.valueOf(item.getItemId()));
                                        itemDTO.setItemName(itemRepository.findById(item.getItemId())
                                                .map(Item::getBdItemNm)
                                                .orElse("Unknown Item"));
                                        itemDTO.setCount(item.getCount());
                                        return itemDTO;
                                    })
                                    .collect(Collectors.toList());

                    responseDTO.setItems(itemDTOs);
                    return responseDTO;
                })
                .collect(Collectors.toList());
    }


    public List<LogResponseDTO> getLogs(String userId, String platform) {
        LocalDate sevenDaysAgo = LocalDate.now().minusDays(45);

        // 플랫폼에 따른 서비스 목록 정의
        List<String> services = new ArrayList<>();
        switch (platform) {
            case "GS25":
                services.add("gs25");
                services.add("gs25_pickup");
                services.add("gs25_dlvy");
                break;
            case "GS더프레시":
                services.add("mart");
                services.add("mart_pickup");
                services.add("mart_dlvy");
                break;
            case "wine25":
                services.add("wine25");
                break;
            default:
                throw new IllegalArgumentException("Unknown platform prefix: " + platform);
        }

        // Cassandra에서 최근 7일간의 로그 데이터를 조회
        List<Log> logs = logRepository.findByUserIdAndRecentLogsWithService(userId, services, sevenDaysAgo);

        // 로그 데이터를 DTO로 변환
        return logs.stream()
                .map(log -> {
                    LogResponseDTO responseDTO = new LogResponseDTO();
                    responseDTO.setId(log.getOrderId() != null ? log.getOrderId() : "N/A");
                    responseDTO.setItemName(log.getItemName());
                    responseDTO.setInter(log.getInter());
                    responseDTO.setDate(log.getDate().toString());
                    responseDTO.setServicetype(log.getService());
                    return responseDTO;
                })
                .collect(Collectors.toList());
    }

}
