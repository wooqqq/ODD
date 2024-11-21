package odd.client.common.log.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import odd.client.common.item.dto.request.CartRequestDTO;
import odd.client.common.item.model.Item;
import odd.client.common.item.model.Platform;
import odd.client.common.item.model.ServiceType;
import odd.client.common.item.repository.ItemRepository;
import odd.client.common.log.model.Log;
import odd.client.common.log.model.PeriodRecommendData;
import odd.client.common.log.model.TimeRecommendData;
import odd.client.common.log.repository.LogRepository;
import odd.client.common.log.repository.PeriodRecommendDataRepository;
import odd.client.common.log.repository.TimeRecommendDataRepository;
import odd.client.common.purchase.dto.request.PurchaseItemDTO;
import odd.client.common.purchase.model.PurchaseLog;
import odd.client.global.util.UserInfo;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LogService {

    private final LogRepository logRepository;
    private final ItemRepository itemRepository;
    private final PeriodRecommendDataRepository periodRecommendDataRepository;
    private final TimeRecommendDataRepository timeRecommendDataRepository;

    public LogService(LogRepository logRepository, ItemRepository itemRepository,
                      PeriodRecommendDataRepository periodRecommendDataRepository,
                      TimeRecommendDataRepository timeRecommendDataRepository) {
        this.logRepository = logRepository;
        this.itemRepository = itemRepository;
        this.periodRecommendDataRepository = periodRecommendDataRepository;
        this.timeRecommendDataRepository = timeRecommendDataRepository;
    }

    @Transactional
    public boolean addItemToCart(CartRequestDTO cartRequestDTO) {
        try {
            String userId = String.valueOf(UserInfo.getId());
            Long itemId = Long.valueOf(cartRequestDTO.getItemId());

            String itemName = itemRepository.findById(itemId)
                    .map(Item::getBdItemNm)
                    .orElse("Unknown Item");

            Platform platform = Platform.fromDescription(cartRequestDTO.getPlatform());
            ServiceType serviceType = ServiceType.fromDescription(cartRequestDTO.getServiceType());

            String service = getServiceString(platform, serviceType);

            Log log = Log.builder()
                    .date(LocalDate.now())
                    .service(service)
                    .orderId(null)
                    .userId(userId)
                    .itemId(String.valueOf(cartRequestDTO.getItemId()))
                    .itemName(itemName)
                    .inter("cart")
                    .eventTime(LocalTime.now())
                    .build();

            logRepository.save(log);
            return true;

        } catch (Exception e) {
            System.err.println("Failed to save log: " + e.getMessage());
            return false;
        }
    }

    @Transactional
    public boolean getItemDetail(Platform platform, Item item) {
        try {
            String userId = String.valueOf(UserInfo.getId());

            Log log = Log.builder()
                    .date(LocalDate.now())
                    .service(platform.getForLog())
                    .orderId(null)
                    .userId(userId)
                    .itemId(String.valueOf(item.getId()))
                    .itemName(item.getBdItemNm())
                    .inter("view")
                    .eventTime(LocalTime.now())
                    .build();

            logRepository.save(log);
            return true;

        } catch (Exception e) {
            System.err.println("Failed to save log: " + e.getMessage());
            return false;
        }
    }


    @Transactional
    public boolean savePurchaseLog(PurchaseLog purchaseLog, List<PurchaseItemDTO> items, Long userId) {
        try {
            // 기존 로그 데이터 수집 (원래 코드 유지)
            List<String> itemIds = new ArrayList<>();
            List<String> itemNames = new ArrayList<>();

            for (PurchaseItemDTO itemDTO : items) {
                itemIds.add(String.valueOf(itemDTO.getId()));
                itemRepository.findById(itemDTO.getId()).ifPresent(item -> itemNames.add(item.getBdItemNm()));
            }

            // service 값 생성
            String service = getServiceString(purchaseLog.getPlatform(), purchaseLog.getServiceType());
            LocalDate now = LocalDate.now();
            LocalTime eventTime = LocalTime.now();

            // 기존 Cassandra 로그 생성 및 저장
            Log log = Log.builder()
                    .date(now)
                    .orderId(purchaseLog.getId().toString())
                    .service(service)
                    .userId(userId.toString())
                    .itemId(String.join(",", itemIds))
                    .itemName(String.join(",", itemNames))
                    .inter("order")
                    .eventTime(eventTime)
                    .build();

            logRepository.save(log);

            // 추가: period_recommend_data와 time_recommend_data에 개별 아이템 로그 저장
            LocalDateTime nowDateTime = LocalDateTime.now();

            for (PurchaseItemDTO itemDTO : items) {
                Item item = itemRepository.findById(itemDTO.getId())
                        .orElse(null);

                if (item != null) {
                    // Period Recommend Data 저장
                    PeriodRecommendData periodData = PeriodRecommendData.builder()
                            .id(UUID.randomUUID())
                            .date(now)
                            .orderId(purchaseLog.getId().toString())
                            .service(service)
                            .userId(userId.toString())
                            .itemId(String.valueOf(item.getId()))
                            .itemName(item.getBdItemNm())
                            .inter("order")
                            .eventTime(nowDateTime)
                            .build();

                    // Time Recommend Data 저장
                    TimeRecommendData timeData = TimeRecommendData.builder()
                            .id(UUID.randomUUID())
                            .date(now)
                            .orderId(purchaseLog.getId().toString())
                            .service(service)
                            .userId(userId.toString())
                            .itemId(String.valueOf(item.getId()))
                            .itemName(item.getBdItemNm())
                            .inter("order")
                            .eventTime(nowDateTime)
                            .build();

                    periodRecommendDataRepository.save(periodData);
                    timeRecommendDataRepository.save(timeData);
                }
            }

            return true;
        } catch (Exception e) {
            System.err.println("Failed to save purchase log: " + e.getMessage());
            return false;
        }
    }

    // service 문자열 생성 메서드
    private String getServiceString(Platform platform, ServiceType serviceType) {
        String platformStr = platform.getDescription().toLowerCase();
        String serviceStr = serviceType.getDescription();  // "배달" 또는 "픽업"

        return switch (platformStr) {
            case "gs25" -> {
                if (serviceStr.equals("배달")) {
                    yield "gs25_dlvy";
                } else if (serviceStr.equals("픽업")) {
                    yield "gs25_pickup";
                } else {
                    throw new IllegalArgumentException("Unknown service type: " + serviceStr);
                }
            }
            case "gs더프레시" -> {
                if (serviceStr.equals("배달")) {
                    yield "mart_dlvy";
                } else if (serviceStr.equals("픽업")) {
                    yield "mart_pickup";
                } else {
                    throw new IllegalArgumentException("Unknown service type: " + serviceStr);
                }
            }
            case "wine25" -> "wine25";
            default -> throw new IllegalArgumentException("Unknown platform: " + platform);
        };
    }
}
