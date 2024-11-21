package odd.client.common.item.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;
import odd.client.common.item.dto.ItemRecommendationDTO;
import odd.client.common.item.dto.response.*;
import odd.client.common.item.model.Item;
import odd.client.common.item.model.Platform;
import odd.client.common.item.repository.ItemRepository;
import odd.client.common.log.service.LogService;
import odd.client.common.purchase.model.PurchaseItem;
import odd.client.common.purchase.model.PurchaseLog;
import odd.client.common.purchase.repository.PurchaseItemRepository;
import odd.client.common.purchase.repository.PurchaseLogRepository;
import odd.client.common.user.model.Category;
import odd.client.common.user.model.FavCategory;
import odd.client.common.user.model.GsUser;
import odd.client.common.user.repository.GsUserRepository;
import odd.client.common.user.repository.UserFavoriteCategoriesRepository;
import odd.client.global.mapper.ItemMapper;
import odd.client.global.util.UserInfo;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;

@Service
public class ItemService {

    private final WebClient webClient;

    private final ItemRepository itemRepository;
    private final GsUserRepository gsUserRepository;
    private final LogService logService;
    private final PurchaseLogRepository purchaseLogRepository;
    private final PurchaseItemRepository purchaseItemRepository;
    private final UserFavoriteCategoriesRepository userFavoriteCategoriesRepository;

    @Value("${FASTAPI_BASE_URL}")
    private String baseUrl;


    public ItemService(WebClient webClient, ItemRepository itemRepository, GsUserRepository gsUserRepository,
                       LogService logService, PurchaseLogRepository purchaseLogRepository,
                       PurchaseItemRepository purchaseItemRepository,
                       UserFavoriteCategoriesRepository userFavoriteCategoriesRepository) {
        this.webClient = webClient;
        this.itemRepository = itemRepository;
        this.gsUserRepository = gsUserRepository;
        this.logService = logService;
        this.purchaseLogRepository = purchaseLogRepository;
        this.purchaseItemRepository = purchaseItemRepository;
        this.userFavoriteCategoriesRepository = userFavoriteCategoriesRepository;
    }

    public ItemResponseDTO getItemDetails(String itemId, String platformDescription) {
        Platform platform = Platform.fromDescription(platformDescription);
        Item item = itemRepository.findById(itemId).orElse(null);
        if (item == null) {
            return null;
        }

        boolean logSaved = logService.getItemDetail(platform, item);
        if (!logSaved) {
            return null;
        }

        return ItemMapper.toDTO(item, platform);
    }

    public ItemPageResponseDTO getItemsByPlatformAndSubCategory(
            String platformDescription,
            String middle,
            String subCategory,
            String sort,
            String filter,
            int page,
            int size) {

        Pageable pageable = getPageable(sort, page, size);

        Platform platform = Platform.fromDescription(platformDescription);
        Page<Item> itemPage;

        // 조건에 따른 쿼리 선택
        if (subCategory.equals("전체")) {
            itemPage = findItemsByMiddleCategoryAndPlatform(middle, filter, platformDescription, pageable);
        } else {
            itemPage = findItemsBySubCategoryAndPlatform(subCategory, filter, platformDescription, pageable);
        }

        List<ItemResponseDTO> itemDtos = ItemMapper.toDTOList(itemPage.getContent(), platform);

        return new ItemPageResponseDTO(
                itemDtos,
                itemPage.getNumber(),
                itemPage.getSize(),
                itemPage.getTotalElements(),
                itemPage.getTotalPages(),
                itemPage.isLast()
        );
    }

    private Pageable getPageable(String sort, int page, int size) {
        if (sort.equals("낮은")) {
            return PageRequest.of(page, size, Sort.by(Direction.ASC, "price"));
        } else if (sort.equals("높은")) {
            return PageRequest.of(page, size, Sort.by(Direction.DESC, "price"));
        } else if (sort.equals("추천")) {// 추천
            return PageRequest.of(page, size, Sort.by(Direction.ASC, "id"));
        } else {
            throw new IllegalArgumentException("Invalid sort value: " + sort);
        }
    }

    private Page<Item> findItemsByMiddleCategoryAndPlatform(String category, String filter, String platformDescription,
                                                            Pageable pageable) {
        return switch (platformDescription) {
            case "GS25" -> {
                if (filter.equals("배달")) {
                    yield itemRepository.findItemsByMAndGS25AndCondition(category, true, false, pageable);
                } else if (filter.equals("픽업")) {
                    yield itemRepository.findItemsByMAndGS25AndCondition(category, false, true, pageable);
                } else if (filter.equals("전체")) { // "전체"
                    yield itemRepository.findItemsByMAndGS25AndCondition(category, true, true, pageable);
                } else {
                    throw new IllegalArgumentException("Invalid filter value: " + filter);
                }
            }
            case "GS더프레시" -> {
                if (filter.equals("배달")) {
                    yield itemRepository.findItemsByMAndMartAndCondition(category, true, false, pageable);
                } else if (filter.equals("픽업")) {
                    yield itemRepository.findItemsByMAndMartAndCondition(category, false, true, pageable);
                } else if (filter.equals("전체")) { // "전체"
                    yield itemRepository.findItemsByMAndMartAndCondition(category, true, true, pageable);
                } else {
                    throw new IllegalArgumentException("Invalid filter value: " + filter);
                }
            }
            case "wine25" -> {
                if (filter.equals("전체") || filter.equals("픽업")) {
                    yield itemRepository.findByBdItemMclsNmAndIsWine25(category, "Y", pageable);
                } else {
                    throw new IllegalArgumentException("Invalid filter value: " + filter);
                }
            }
            default -> throw new IllegalStateException("Unexpected value: " + platformDescription);
        };
    }

    private Page<Item> findItemsBySubCategoryAndPlatform(String category, String filter, String platformDescription,
                                                         Pageable pageable) {
        return switch (platformDescription) {
            case "GS25" -> {
                if (filter.equals("배달")) {
                    yield itemRepository.findItemsBySAndGS25AndCondition(category, true, false, pageable);
                } else if (filter.equals("픽업")) {
                    yield itemRepository.findItemsBySAndGS25AndCondition(category, false, true, pageable);
                } else if (filter.equals("전체")) { // "전체"
                    yield itemRepository.findItemsBySAndGS25AndCondition(category, true, true, pageable);
                } else {
                    throw new IllegalArgumentException("Invalid filter value: " + filter);
                }
            }
            case "GS더프레시" -> {
                if (filter.equals("배달")) {
                    yield itemRepository.findItemsBySAndMartAndCondition(category, true, false, pageable);
                } else if (filter.equals("픽업")) {
                    yield itemRepository.findItemsBySAndMartAndCondition(category, false, true, pageable);
                } else if (filter.equals("전체")) { // "전체"
                    yield itemRepository.findItemsBySAndMartAndCondition(category, true, true, pageable);
                } else {
                    throw new IllegalArgumentException("Invalid filter value: " + filter);
                }
            }
            case "wine25" -> {
                if (filter.equals("전체") || filter.equals("픽업")) {
                    yield itemRepository.findByBdItemSclsNmAndIsWine25(category, "Y", pageable);
                } else {
                    throw new IllegalArgumentException("Invalid filter value: " + filter);
                }
            }
            default -> throw new IllegalStateException("Unexpected value: " + platformDescription);
        };
    }

    // 특정 시간대에 구매했던 상품 (시간 입력 필요 O)
    public List<ItemResponseDTO> getTimeBasedRecommendedItems(String platformDescription, int hour) {
        Platform platform = Platform.fromDescription(platformDescription);
        Long userId = UserInfo.getId();
        GsUser gsUser = gsUserRepository.findByUser_Id(userId)
                .orElseThrow(() -> new IllegalArgumentException("연결된 GS 사용자 계정이 없습니다."));

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("user_id", gsUser.getGsUserId());
        requestBody.put("hour", hour);

        List<TimeRecommendItemResponseDTO> itemRecommendations = webClient.post()
                .uri("/user-hour-recommend")
                .contentType(MediaType.APPLICATION_JSON)
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + System.getenv("JWT_SECRET"))
                .bodyValue(requestBody)
                .retrieve()
                .bodyToFlux(TimeRecommendItemResponseDTO.class)
                .doOnError(error -> System.out.println(
                        "Error occurred while making WebClient request: " + error.getMessage()))
                .collectList()
                .block();

        System.out.println("Received items: " + itemRecommendations);

        List<ItemResponseDTO> itemResponseDTOS = itemRecommendations.stream()
                .map(recommend -> {
                    Item item = itemRepository.findById(recommend.getItemId())
                            .orElse(null);

                    if (item != null) {
                        List<String> serviceTypes = new ArrayList<>();
                        if ("Y".equals(item.getIsGs25Dlvy())) {
                            serviceTypes.add("배달");
                        }
                        if ("Y".equals(item.getIsGs25Pickup())) {
                            serviceTypes.add("픽업");
                        }

                        return ItemResponseDTO.createResponseDTO(item, Platform.GS25.getDescription(), serviceTypes);
                    }
                    return null;
                })
                .filter(response -> response != null)
                .toList();

        return itemResponseDTOS;
    }

    // 특정 시간대에 구매했던 상품 (시간 입력 필요 X)
    public List<ItemResponseDTO> getTotalTimeBasedRecommendedItems(String platformDescription) {
        Platform platform = Platform.fromDescription(platformDescription);
        Long userId = UserInfo.getId();
        GsUser gsUser = gsUserRepository.findByUser_Id(userId)
                .orElseThrow(() -> new IllegalArgumentException("연결된 GS 사용자 계정이 없습니다."));

        Map<String, Object> requestBody = new HashMap<>();
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

        System.out.println("Received items: " + itemRecommendations);

        Set<ItemResponseDTO> itemResponseDTOS = itemRecommendations.stream()
                .map(recommend -> {
                    Item item = itemRepository.findById(recommend.getItemId())
                            .orElse(null);

                    if (item != null) {
                        List<String> serviceTypes = new ArrayList<>();
                        if ("Y".equals(item.getIsGs25Dlvy())) {
                            serviceTypes.add("배달");
                        }
                        if ("Y".equals(item.getIsGs25Pickup())) {
                            serviceTypes.add("픽업");
                        }

                        return ItemResponseDTO.createResponseDTO(item, Platform.GS25.getDescription(), serviceTypes);
                    }
                    return null;
                })
                .filter(response -> response != null)
                .collect(Collectors.toSet()); // Set으로 수집하여 중복 제거

        // Set을 List로 변환하여 반환
        return new ArrayList<>(itemResponseDTOS);
    }

    public List<ItemResponseDTO> getFavoriteCategoryItems(String platformDescription) {
        String userId = UserInfo.getId().toString();

        int orderCount = purchaseLogRepository.countOrdersByUserId(Long.parseLong(userId));
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

        List<ItemResponseDTO> itemRecommendations = webClient.post()
                .uri(uri)
                .contentType(MediaType.APPLICATION_JSON)
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + System.getenv("JWT_SECRET"))
                .bodyValue(requestBody)
                .retrieve()
                .bodyToFlux(ItemResponseDTO.class)
                .doOnError(error -> System.out.println(
                        "Error occurred while making WebClient request: " + error.getMessage()))
                .collectList()
                .block();

        List<ItemResponseDTO> convertedItems = itemRecommendations.stream()
                .map(this::convertToItemResponseDTO)
                .toList();

        // 로깅 추가 - 반환된 항목 확인
        System.out.println("Received items: " + convertedItems);

        return convertedItems;
    }

    public List<ItemResponseDTO> getAllPlatformItems() {
        String userId = UserInfo.getId().toString();

        int orderCount = purchaseLogRepository.countOrdersByUserId(Long.parseLong(userId));
        String uri;
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("user_id", userId);

        List<String> platforms = Arrays.asList("GS25", "GS더프레시", "wine25");
        List<ItemResponseDTO> allItems = new ArrayList<>();

        for (String platform : platforms) {
            requestBody.put("platform", platform);
            // 로깅 추가
            System.out.println("Requesting items for platform: " + platform);

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

            List<ItemResponseDTO> itemRecommendations = webClient.post()
                    .uri(uri)
                    .contentType(MediaType.APPLICATION_JSON)
                    .header(HttpHeaders.AUTHORIZATION, "Bearer " + System.getenv("JWT_SECRET"))
                    .bodyValue(requestBody)
                    .retrieve()
                    .bodyToFlux(ItemResponseDTO.class)
                    .doOnError(error -> System.out.println(
                            "Error occurred while making WebClient request for platform " + platform + ": "
                                    + error.getMessage()))
                    .collectList()
                    .block();

            if (itemRecommendations != null) {
                allItems.addAll(itemRecommendations);
            }
        }

        List<ItemResponseDTO> mergedItems = mergeItemsAlternately(allItems, platforms.size());

        System.out.println("Received items for all platforms in alternating order: " + mergedItems);

        return mergedItems;
    }

    private List<ItemResponseDTO> mergeItemsAlternately(List<ItemResponseDTO> items, int platformCount) {
        List<ItemResponseDTO> mergedItems = new ArrayList<>();
        int maxItems = items.size() / platformCount;
        for (int i = 0; i < maxItems; i++) {
            for (int j = 0; j < platformCount; j++) {
                int index = i + j * maxItems;
                if (index < items.size()) {
                    mergedItems.add(items.get(index));
                }
            }
        }
        return mergedItems;
    }

    public List<ItemResponseDTO> getPurchaseCycleBasedRecommendations(String platformDescription) {
        // 현재는 mart만 가능하게 구현함
        Platform platform = Platform.fromDescription(platformDescription);
        Long userId = UserInfo.getId();
        GsUser gsUser = gsUserRepository.findByUser_Id(userId)
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

        System.out.println("Received items: " + itemRecommendations);

        assert itemRecommendations != null;
        return itemRecommendations.stream()
                .map(itemRec -> {
                    Item item = itemRepository.findById(itemRec.getItemId())
                            .orElse(null); // orElseThrow로 예외를 던지도록 조정 가능

                    if (item != null) {
                        List<String> serviceTypes = new ArrayList<>();
                        if ("Y".equals(item.getIsMartDlvy())) {
                            serviceTypes.add("배달");
                        }
                        if ("Y".equals(item.getIsMartPickup())) {
                            serviceTypes.add("픽업");
                        }

                        return ItemResponseDTO.createResponseDTO(item, Platform.GSFRESH.getDescription(), serviceTypes);
                    }
                    return null;
                })
                .filter(Objects::nonNull) // null 필터링
                .collect(Collectors.toList());
    }

    public List<ItemWithPurchaseCountRseponseDTO> getRecentPurchaseItems() {
        Long userId = UserInfo.getId();
        LocalDateTime startDate = LocalDateTime.now().minusDays(60);

        // 1. 최근 60일간의 구매 로그 조회
        List<PurchaseLog> purchaseLogs = purchaseLogRepository.findRecentPurchasesByUserId(userId, startDate);

        // 2. 전체 로그 ID 수집
        List<Long> logIds = purchaseLogs.stream()
                .map(PurchaseLog::getId)
                .collect(Collectors.toList());

        // 3. 구매 아이템 조회
        List<PurchaseItem> purchaseItems = purchaseItemRepository.findByLogIds(logIds);

        // 4. 아이템별 마지막 구매 날짜 맵 생성
        Map<Long, LocalDateTime> itemLastPurchaseDate = purchaseItems.stream()
                .collect(Collectors.groupingBy(
                        PurchaseItem::getItemId,
                        Collectors.mapping(
                                item -> item.getLog().getCreateTime(),
                                Collectors.maxBy(LocalDateTime::compareTo)
                        )
                ))
                .entrySet().stream()
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        e -> e.getValue().orElse(null)
                ));

        // 5. 아이템별 구매 횟수 집계
        Map<Long, Integer> itemPurchaseFrequency = purchaseItems.stream()
                .collect(Collectors.groupingBy(
                        PurchaseItem::getItemId,
                        Collectors.collectingAndThen(Collectors.counting(), Long::intValue)
                ));

        // 6. 구매 기록이 있는 아이템들 조회
        List<Item> items = itemRepository.findAllById(
                new ArrayList<>(itemPurchaseFrequency.keySet())
        );

        // 7. DTO 변환 및 정렬
        return items.stream()
                .map(item -> {
                    ItemWithPurchaseCountRseponseDTO dto = new ItemWithPurchaseCountRseponseDTO();
                    dto.setItemId(item.getId());
                    dto.setItemName(item.getBdItemNm());

                    // 각 아이템의 platform 정보 설정
                    if ("Y".equals(item.getIsGs25Pickup()) || "Y".equals(item.getIsGs25Dlvy())) {
                        dto.setPlatform(Platform.GS25.getDescription());
                    } else if ("Y".equals(item.getIsMartPickup()) || "Y".equals(item.getIsMartDlvy())) {
                        dto.setPlatform(Platform.GSFRESH.getDescription());
                    } else if ("Y".equals(item.getIsWine25())) {
                        dto.setPlatform(Platform.WINE25.getDescription());
                    }

                    // ServiceType 설정
                    List<String> serviceTypes = new ArrayList<>();
                    if ("Y".equals(item.getIsGs25Pickup()) || "Y".equals(item.getIsMartPickup()) || "Y".equals(
                            item.getIsWine25())) {
                        serviceTypes.add("픽업");
                    }
                    if ("Y".equals(item.getIsGs25Dlvy()) || "Y".equals(item.getIsMartDlvy())) {
                        serviceTypes.add("배달");
                    }

                    dto.setServiceType(serviceTypes);
                    dto.setPrice(item.getPrice());
                    dto.setS3url(item.getS3Url());
                    dto.setPurchaseCount(itemPurchaseFrequency.getOrDefault(Long.valueOf(item.getId()), 0));
                    return dto;
                })
                .sorted((a, b) -> {
                    LocalDateTime dateA = itemLastPurchaseDate.get(Long.valueOf(a.getItemId()));
                    LocalDateTime dateB = itemLastPurchaseDate.get(Long.valueOf(b.getItemId()));
                    return dateB.compareTo(dateA); // 최신 날짜순 정렬
                })
                .collect(Collectors.toList());
    }

    // TODO 임시로 데이터를 출력하기 위해 넣어둔 것
    public Flux<ItemResponseDTO> convertPageToFlux(Page<Item> page, Platform platform) {
        return Flux.fromIterable(page.getContent())
                .map(item -> ItemMapper.toDTO(item, platform));
    }

    private ItemResponseDTO convertToItemResponseDTO(ItemResponseDTO itemRecommendation) {
        return new ItemResponseDTO(
                itemRecommendation.getItemId(),
                itemRecommendation.getItemName(),
                itemRecommendation.getPlatform(),
                itemRecommendation.getServiceType(),
                itemRecommendation.getPrice(),
                itemRecommendation.getS3url()
        );
    }


}
