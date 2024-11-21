package odd.client.common.dashboard.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.*;
import java.util.stream.Collectors;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import odd.client.common.category.repository.CategoryRepository;
import odd.client.common.dashboard.dto.response.*;
import odd.client.common.item.model.Item;
import odd.client.common.item.model.Platform;
import odd.client.common.item.repository.ItemRepository;
import odd.client.common.log.model.Log;
import odd.client.common.log.repository.LogRepository;
import odd.client.common.purchase.model.PurchaseItem;
import odd.client.common.purchase.model.PurchaseLog;
import odd.client.common.purchase.repository.PurchaseItemRepository;
import odd.client.common.purchase.repository.PurchaseLogRepository;
import odd.client.common.user.model.GsUser;
import odd.client.common.user.model.User;
import odd.client.common.user.repository.GsUserRepository;
import odd.client.common.user.repository.UserRepository;
import org.springframework.data.cassandra.config.SessionFactoryFactoryBean;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class DashboardService {
    private final LogRepository logRepository;
    private final PurchaseLogRepository purchaseLogRepository;
    private final PurchaseItemRepository purchaseItemRepository;
    private final ItemRepository itemRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;
    private final GsUserRepository gsUserRepository;
    private static final int TOP_LIMIT = 10;
    private final SessionFactoryFactoryBean cassandraSessionFactory;

    public List<CategoryStatsResponseDTO> getCategoryStats(String data, String platformDescription) {
        Platform platform = Platform.fromDescription(platformDescription);

        // 1. 해당 플랫폼의 카테고리 목록 조회 (중분류 기준)
        List<String> categories = switch (platform) {
            case GS25 -> itemRepository.findDistinctBdItemMclsNmByGs25();  // GS25 pickup 또는 delivery가 Y인 경우
            case GSFRESH -> itemRepository.findDistinctBdItemMclsNmByMart();  // 마트 pickup 또는 delivery가 Y인 경우
            case WINE25 -> itemRepository.findDistinctBdItemMclsNmByWine25();  // wine25가 Y인 경우
        };

        // 2. 전체 로그 데이터 미리 조회 (성능 개선을 위해)
        List<Log> viewLogs = logRepository.findViewLogsByService(platform.getForLog());
        List<Log> cartLogs = logRepository.findCartLogsByService(getPlatformServices(platformDescription));
        List<Log> orderLogs = logRepository.findOrderLogsByService(getPlatformServices(platformDescription));

        // 3. 각 카테고리별 통계 계산
        return categories.stream()
                .map(category -> {
                    // 해당 카테고리의 아이템 목록 조회 (플랫폼 조건 추가)
                    List<Item> categoryItems = switch (platform) {
                        case GS25 -> itemRepository.findByBdItemMclsNmAndGs25(category);
                        case GSFRESH -> itemRepository.findByBdItemMclsNmAndMart(category);
                        case WINE25 -> itemRepository.findByBdItemMclsNmAndIsWine25(category, "Y");
                    };

                    List<String> itemIds = categoryItems.stream()
                            .map(Item::getId)
                            .collect(Collectors.toList());

                    // 조회수 집계
                    long viewCount = viewLogs.stream()
                            .filter(log -> {
                                String[] ids = log.getItemId().split(",");
                                return Arrays.stream(ids)
                                        .map(String::trim)
                                        .anyMatch(itemIds::contains);
                            })
                            .count();

                    // 장바구니 집계
                    long cartCount = cartLogs.stream()
                            .filter(log -> {
                                String[] ids = log.getItemId().split(",");
                                return Arrays.stream(ids)
                                        .map(String::trim)
                                        .anyMatch(itemIds::contains);
                            })
                            .count();

                    // 구매수와 재구매수 집계
                    Map<String, Map<String, Integer>> userItemPurchases = new HashMap<>();
                    long orderCount = 0;

                    for (Log order : orderLogs) {
                        String[] ids = order.getItemId().split(",");

                        for (String id : ids) {
                            id = id.trim();
                            if (itemIds.contains(id)) {
                                orderCount++;
                                // 사용자별 아이템 구매 횟수 누적
                                userItemPurchases
                                        .computeIfAbsent(order.getUserId(), k -> new HashMap<>())
                                        .merge(id, 1, Integer::sum);
                            }
                        }
                    }

                    // 재구매 횟수 계산
                    long reorderCount = userItemPurchases.values().stream()
                            .flatMap(purchases -> purchases.entrySet().stream())
                            .filter(entry -> entry.getValue() > 1)
                            .mapToLong(entry -> entry.getValue() - 1L)
                            .sum();

                    return CategoryStatsResponseDTO.builder()
                            .category(category)
                            .viewCount(viewCount)
                            .cartCount(cartCount)
                            .orderCount(orderCount)
                            .reorderCount(reorderCount)
                            .build();
                })
                .sorted((a, b) -> {
                    long sumA = a.getViewCount() + a.getCartCount() + a.getOrderCount() + a.getReorderCount();
                    long sumB = b.getViewCount() + b.getCartCount() + b.getOrderCount() + b.getReorderCount();
                    return Long.compare(sumB, sumA);
                })
                .collect(Collectors.toList());
    }

    public List<ItemResponseWithCountDTO> getTopViewedItems(String data, String platformDescription, String category) {
        Platform platform = Platform.fromDescription(platformDescription);
        List<Log> viewLogs = logRepository.findViewLogsByService(platform.getForLog());

        return viewLogs.stream()
                .collect(Collectors.groupingBy(
                        log -> new ItemKey(log.getItemId(), log.getItemName()),
                        Collectors.counting()))
                .entrySet().stream()
                .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
                .limit(TOP_LIMIT)
                .map(entry -> ItemResponseWithCountDTO.builder()
                        .id(entry.getKey().getId())
                        .itemName(entry.getKey().getName())
                        .count(entry.getValue())
                        .build())
                .collect(Collectors.toList());
    }

    public List<ItemResponseWithCountDTO> getTopCartItems(String data, String platformDescription, String category) {
        List<String> services = getPlatformServices(platformDescription);
        List<Log> cartLogs = logRepository.findCartLogsByService(services);

        return cartLogs.stream()
                .collect(Collectors.groupingBy(
                        log -> new ItemKey(log.getItemId(), log.getItemName()),
                        Collectors.counting()))
                .entrySet().stream()
                .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
                .limit(TOP_LIMIT)
                .map(entry -> ItemResponseWithCountDTO.builder()
                        .id(entry.getKey().getId())
                        .itemName(entry.getKey().getName())
                        .count(entry.getValue())
                        .build())
                .collect(Collectors.toList());
    }

    public List<ItemResponseWithCountDTO> getTopPurchasedItems(String data, String platformDescription,
                                                               String category) {

        Platform platform = Platform.fromDescription(platformDescription);
        LocalDateTime startDate = LocalDateTime.now().minusDays(60);

        // 1. 최근 60일간의 해당 플랫폼 구매 로그 조회
        List<PurchaseLog> purchaseLogs = purchaseLogRepository.findRecentPurchasesByPlatform(platform, startDate);

        // 2. 전체 로그 ID 수집
        List<Long> logIds = purchaseLogs.stream()
                .map(PurchaseLog::getId)
                .collect(Collectors.toList());

        // 3. 구매 아이템 조회
        List<PurchaseItem> purchaseItems = purchaseItemRepository.findByLogIds(logIds);

        // 4. 아이템별 구매 횟수 집계
        Map<Long, Long> itemPurchaseFrequency = purchaseItems.stream()
                .collect(Collectors.groupingBy(
                        PurchaseItem::getItemId,
                        Collectors.counting()
                ));

        // 5. 구매 기록이 있는 아이템들 조회
        List<Item> items = itemRepository.findAllById(
                new ArrayList<>(itemPurchaseFrequency.keySet())
        );

        // 6. DTO 변환 및 구매 횟수 기준 정렬
        List<ItemResponseWithCountDTO> result = items.stream()
                .map(item -> ItemResponseWithCountDTO.builder()
                        .id(item.getId())
                        .itemName(item.getBdItemNm())
                        .count(itemPurchaseFrequency.getOrDefault(Long.valueOf(item.getId()), 0L))
                        .build()
                )
                .sorted((a, b) -> Long.compare(b.getCount(), a.getCount()))
                .limit(10)
                .collect(Collectors.toList());

        return result;

//        cassandra 통한 구매 순위 조회
//        List<Log> orderLogs = logRepository.findOrderLogsByService(getPlatformServices(platformDescription));
//        Map<ItemKey, Integer> purchaseCount = new HashMap<>();
//
//        for (Log order : orderLogs) {
//            System.out.println("Log: " + order);
//            String[] itemIds = order.getItemId().split(",");
//            String[] itemNames = order.getItemName().split(",");
//
//            for (int i = 0; i < itemIds.length; i++) {
//                ItemKey itemKey = new ItemKey(itemIds[i].trim(), itemNames[i].trim());
//                purchaseCount.merge(itemKey, 1, Integer::sum);
//            }
//        }
//
//        return purchaseCount.entrySet().stream()
//                .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
//                .limit(TOP_LIMIT)
//                .map(entry -> ItemResponseWithCountDTO.builder()
//                        .id(entry.getKey().getId())
//                        .itemName(entry.getKey().getName())
//                        .count(entry.getValue())
//                        .build())
//                .collect(Collectors.toList());
    }

    public List<ItemResponseWithCountDTO> getTopRepurchaseItems(String data, String platformDescription,
                                                                String category) {
        List<Log> orderLogs = logRepository.findOrderLogsByService(getPlatformServices(platformDescription));
        Map<String, Map<ItemKey, Integer>> userPurchases = new HashMap<>();

        for (Log order : orderLogs) {
            String[] itemIds = order.getItemId().split(",");
            String[] itemNames = order.getItemName().split(",");

            for (int i = 0; i < itemIds.length; i++) {
                ItemKey itemKey = new ItemKey(itemIds[i].trim(), itemNames[i].trim());
                userPurchases.computeIfAbsent(order.getUserId(), k -> new HashMap<>())
                        .merge(itemKey, 1, Integer::sum);
            }
        }

        Map<ItemKey, Long> repurchaseCount = userPurchases.values().stream()
                .flatMap(purchases -> purchases.entrySet().stream())
                .filter(entry -> entry.getValue() > 1)
                .collect(Collectors.groupingBy(
                        Map.Entry::getKey,
                        Collectors.counting()
                ));

        return repurchaseCount.entrySet().stream()
                .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
                .limit(TOP_LIMIT)
                .map(entry -> ItemResponseWithCountDTO.builder()
                        .id(entry.getKey().getId())
                        .itemName(entry.getKey().getName())
                        .count(entry.getValue())
                        .build())
                .collect(Collectors.toList());
    }

    public ReorderRatioResponseDTO getReorderUserRatio(String data, String platform) {
        LocalDate startDate = LocalDate.now().minusDays(60);

        List<String> services = getPlatformServices(platform);

        List<Log> orders = logRepository.findOrdersByPlatform(services);

        List<Log> filteredOrders = orders.stream()
                .filter(log -> {
                    if (log.getDate() == null) {
                        System.err.println("Null date found for log: " + log);
                        return false; // null인 데이터는 필터에서 제외
                    }
                    return log.getDate().isAfter(startDate);
                })
                .toList();

        // Map<userId, Map<itemId, Integer>>로 데이터 그룹화
        Map<String, Map<String, Long>> userOrderCounts = filteredOrders.stream()
                .collect(Collectors.groupingBy(
                        Log::getUserId,
                        Collectors.groupingBy(Log::getItemId, Collectors.counting())
                ));

        // 재구매 여부 계산
        long first = 0;
        long secondOrMore = 0;

        for (Map.Entry<String, Map<String, Long>> userEntry : userOrderCounts.entrySet()) {
            for (Long count : userEntry.getValue().values()) {
                if (count == 1 || count == 2) {
                    first++;
                } else if (count > 2) {
                    secondOrMore++;
                }
            }
        }

        float reorderRatio = (float) secondOrMore / (first + secondOrMore);

        return ReorderRatioResponseDTO.builder()
                .first(first)
                .secondOrMore(secondOrMore)
                .reorderRatio(String.format("%.2f", reorderRatio * 100))
                .build();
    }

    public GenderAgeGroupResponseDTO getReorderUserCountByAgeAndGender(String data, String platform) {
        List<String> services = getPlatformServices(platform);

        List<Log> orders = logRepository.findOrdersByPlatform(services);

        Map<String, Map<String, Long>> userOrderCounts = orders.stream()
                .collect(Collectors.groupingBy(
                        Log::getUserId,
                        Collectors.groupingBy(Log::getItemId, Collectors.counting())
                ));

        List<User> reorderUsers = new ArrayList<>();

        for (Map.Entry<String, Map<String, Long>> userEntry : userOrderCounts.entrySet()) {
            String gsUserId = userEntry.getKey();

            for (Long count : userEntry.getValue().values()) {
                if (count > 2) {
                    GsUser gsUser = gsUserRepository.findByGsUserId(gsUserId)
                            .orElse(null);

                    if (gsUser != null) {
                        User user = gsUser.getUser();
                        reorderUsers.add(user);
                    }
                }
            }
        }

        Map<String, AgeGroupResponseDTO> genderAgeGroups = new HashMap<>();
        for (User user : reorderUsers) {
            int age = calculateAge(user.getBirthday());
            String gender = user.getGender();

            String ageGroup = getAgeGroup(age);

            if (gender.equals("female")) {
                genderAgeGroups.computeIfAbsent("female", k -> new AgeGroupResponseDTO(0, 0, 0, 0 ,0))
                        .incrementAgeGroup(ageGroup);
            } else if (gender.equals("male")) {
                genderAgeGroups.computeIfAbsent("male", k -> new AgeGroupResponseDTO(0, 0, 0, 0 ,0))
                        .incrementAgeGroup(ageGroup);
            }
        }

        AgeGroupResponseDTO female = genderAgeGroups.getOrDefault("female", new AgeGroupResponseDTO(0, 0, 0, 0, 0));
        AgeGroupResponseDTO male = genderAgeGroups.getOrDefault("male", new AgeGroupResponseDTO(0, 0, 0, 0, 0));

        return GenderAgeGroupResponseDTO.builder()
                .female(female)
                .male(male)
                .build();
    }

    private List<String> getPlatformServices(String platformDescription) {
        List<String> services = new ArrayList<>();
        switch (platformDescription) {
            case "GS25":
                services.add("gs25_pickup");
                services.add("gs25_dlvy");  // delivery의 약자
                break;
            case "GS더프레시":
                services.add("mart_pickup");
                services.add("mart_dlvy");  // delivery의 약자
                break;
            case "wine25":
                services.add("wine25");
                break;
            default:
                throw new IllegalArgumentException("Unknown platform prefix: " + platformDescription);
        }
        return services;
    }

    private int calculateAge(LocalDate birthDate) {
        if (birthDate == null) {
            return 0; // Invalid or missing birthDate
        }
        return Period.between(birthDate, LocalDate.now()).getYears();
    }

    // 나이대 그룹화
    private String getAgeGroup(int age) {
        if (age >= 10 && age <= 19) return "teens";
        if (age >= 20 && age <= 29) return "twenties";
        if (age >= 30 && age <= 39) return "thirties";
        if (age >= 40 && age <= 49) return "forties";
        return "other";
    }

    @Data
    @AllArgsConstructor
    private static class ItemKey {
        private String id;
        private String name;

        @Override
        public boolean equals(Object o) {
            if (this == o) {
                return true;
            }
            if (o == null || getClass() != o.getClass()) {
                return false;
            }
            ItemKey itemKey = (ItemKey) o;
            return Objects.equals(id, itemKey.id);
        }

        @Override
        public int hashCode() {
            return Objects.hash(id);
        }
    }
}