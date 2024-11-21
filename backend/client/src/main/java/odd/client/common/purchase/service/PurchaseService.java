package odd.client.common.purchase.service;

import jakarta.persistence.EntityNotFoundException;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import odd.client.common.item.model.Item;
import odd.client.common.item.model.Platform;
import odd.client.common.item.model.ServiceType;
import odd.client.common.item.repository.ItemRepository;
import odd.client.common.log.service.LogService;
import odd.client.common.purchase.dto.request.PurchaseItemDTO;
import odd.client.common.purchase.dto.request.PurchaseRequestDTO;
import odd.client.common.purchase.dto.response.PurchaseItemResponseDTO;
import odd.client.common.purchase.dto.response.PurchaseLogDetailResponseDTO;
import odd.client.common.purchase.dto.response.PurchaseLogPageResponseDTO;
import odd.client.common.purchase.dto.response.PurchaseLogResponseDTO;
import odd.client.common.purchase.model.PurchaseItem;
import odd.client.common.purchase.model.PurchaseLog;
import odd.client.common.purchase.repository.PurchaseItemRepository;
import odd.client.common.purchase.repository.PurchaseLogRepository;
import odd.client.common.user.model.User;
import odd.client.common.user.repository.UserRepository;
import odd.client.global.util.UserInfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PurchaseService {

    private final UserRepository userRepository;
    private final PurchaseLogRepository purchaseLogRepository;
    private final PurchaseItemRepository purchaseItemRepository;
    private final LogService logService;
    private final ItemRepository itemRepository;


    public PurchaseService(UserRepository userRepository,
                           PurchaseLogRepository purchaseLogRepository,
                           PurchaseItemRepository purchaseItemRepository, LogService logService,
                           ItemRepository itemRepository) {
        this.userRepository = userRepository;
        this.purchaseLogRepository = purchaseLogRepository;
        this.purchaseItemRepository = purchaseItemRepository;
        this.logService = logService;
        this.itemRepository = itemRepository;
    }

    private static final String ALL_SERVICE_TYPE = "전체";

    @Transactional
    public void processPurchase(Long userId, PurchaseRequestDTO request) {
        // 사용자 정보 가져오기
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        // 포인트 차감 로직
        if (user.getPoints() < request.getTotal()) {
            throw new IllegalArgumentException("포인트가 부족합니다.");
        }
        user.setPoints(user.getPoints() - request.getTotal());
        userRepository.save(user);

        // 전체 구매 아이템 수 계산
        int totalCount = request.getItems().stream()
                .mapToInt(PurchaseItemDTO::getCount)
                .sum();

        // 구매 로그 저장
        PurchaseLog purchaseLog = new PurchaseLog();
        purchaseLog.setUser(user);
        purchaseLog.setCreateTime(LocalDateTime.now());
        purchaseLog.setTotalPrice(request.getTotal());
        purchaseLog.setServiceType(request.getServiceType());
        Platform platform = Platform.fromDescription(request.getPlatform());
        purchaseLog.setTotalCount(totalCount);
        purchaseLog.setPlatform(platform);
        PurchaseLog savedLog = purchaseLogRepository.save(purchaseLog);

        // 구매 상품 저장
        for (PurchaseItemDTO itemDTO : request.getItems()) {
            PurchaseItem purchaseItem = new PurchaseItem();
            purchaseItem.setLog(savedLog);
            purchaseItem.setItemId(itemDTO.getId());
            purchaseItem.setCount(itemDTO.getCount());
            purchaseItemRepository.save(purchaseItem);
        }

        // Cassandra 로그 저장
        boolean saveLog = logService.savePurchaseLog(savedLog, request.getItems(), userId);
    }

    public PurchaseLogPageResponseDTO getPurchaseList(String platformStr, String serviceTypeStr,
                                                      int page, int size) {
        Long userId = UserInfo.getId();
        // Platform 변환
        Platform platform = null;
        if (platformStr != null && !platformStr.isEmpty()) {
            platform = Platform.fromDescription(platformStr);
        }

        // ServiceType 변환
        ServiceType serviceType = null;
        if (serviceTypeStr != null && !serviceTypeStr.isEmpty() && !serviceTypeStr.equals(ALL_SERVICE_TYPE)) {
            serviceType = ServiceType.fromDescription(serviceTypeStr);
        }

        Pageable pageable = PageRequest.of(page, size);
        Page<PurchaseLog> purchaseLogs = purchaseLogRepository.findByUserIdAndConditions(
                userId,
                platform,
                serviceType,
                pageable
        );

        // 모든 purchaseLog의 ID 목록 추출
// 로그 ID 리스트 생성
        List<Long> logIds = purchaseLogs.getContent().stream()
                .map(PurchaseLog::getId)
                .collect(Collectors.toList());

// 각 purchaseLog의 첫 번째 item 조회
        List<PurchaseItem> firstItems = purchaseItemRepository.findFirstItemsByLogIds(logIds);

// 첫 번째 아이템으로 맵 생성 (여기서 중복 키 확인 가능)
        Map<Long, PurchaseItem> firstItemMap = firstItems.stream()
                .collect(Collectors.toMap(
                        item -> item.getLog().getId(),
                        item -> item,
                        (existing, replacement) -> existing  // 병합 전략 추가
                ));

// Item IDs 추출
        List<Long> itemIds = firstItems.stream()
                .map(PurchaseItem::getItemId)
                .collect(Collectors.toList());

// Item Map 생성 (중복 키 발생 시 병합 전략 추가)
        Map<String, Item> itemMap = itemRepository.findAllById(itemIds).stream()
                .collect(Collectors.toMap(
                        Item::getId,
                        item -> item,
                        (existing, replacement) -> existing  // 병합 전략 추가
                ));

        // PurchaseLogResponseDTO 리스트로 변환
        List<PurchaseLogResponseDTO> purchaseLogResponses = purchaseLogs.getContent().stream()
                .map(log -> {
                    // 첫 번째 상품 정보 가져오기
                    PurchaseItem firstItem = firstItemMap.get(log.getId());
                    String s3Url = null;
                    String firstProductName = null;

                    if (firstItem != null) {
                        Item item = itemMap.get(String.valueOf(firstItem.getItemId()));

                        if (item != null) {
                            s3Url = item.getS3Url();
                            firstProductName = item.getBdItemNm();
                        }
                    }

                    return new PurchaseLogResponseDTO(
                            log.getId(),
                            log.getPlatform().getDescription(),
                            log.getServiceType().getDescription(),
                            log.getTotalPrice(),
                            log.getCreateTime(),
                            s3Url,
                            log.getTotalCount(),
                            firstProductName
                    );
                })
                .collect(Collectors.toList());

        // PurchaseLogPageResponseDTO로 변환하여 반환
        return new PurchaseLogPageResponseDTO(
                purchaseLogResponses,
                purchaseLogs.getNumber(),
                purchaseLogs.getSize(),
                purchaseLogs.getTotalElements(),
                purchaseLogs.getTotalPages(),
                purchaseLogs.isLast()
        );
    }

    public PurchaseLogDetailResponseDTO getPurchaseDetail(Long purchaseId) {
        Long userId = UserInfo.getId();

        PurchaseLog purchaseLog = purchaseLogRepository.findById(purchaseId)
                .orElseThrow(() -> new EntityNotFoundException("Purchase not found"));

        if (!purchaseLog.getUser().getId().equals(userId)) {
            throw new AccessDeniedException("권한이 없습니다.");
        }

        List<PurchaseItem> purchaseItems = purchaseItemRepository.findByLogId(purchaseId);

        List<Long> itemIds = purchaseItems.stream()
                .map(PurchaseItem::getItemId)
                .collect(Collectors.toList());

        Map<String, Item> itemMap = itemRepository.findAllById(itemIds).stream()
                .collect(Collectors.toMap(Item::getId, item -> item));

        Map<Long, Integer> countMap = purchaseItems.stream()
                .collect(Collectors.groupingBy(
                        PurchaseItem::getItemId,
                        Collectors.summingInt(PurchaseItem::getCount)
                ));

        List<PurchaseItemResponseDTO> products = itemIds.stream()
                .map(itemId -> {
                    Item item = itemMap.get(String.valueOf(itemId));
                    PurchaseItemResponseDTO dto = new PurchaseItemResponseDTO();
                    dto.setItemId(String.valueOf(itemId));
                    dto.setItemName(item.getBdItemNm());
                    dto.setPrice(item.getPrice());
                    dto.setPlatform(purchaseLog.getPlatform().getDescription());
                    dto.setServiceType(Collections.singletonList(purchaseLog.getServiceType().getDescription()));
                    dto.setS3url(item.getS3Url());
                    dto.setCount(countMap.get(itemId));
                    return dto;
                })
                .collect(Collectors.toList());

        PurchaseLogDetailResponseDTO responseDTO = new PurchaseLogDetailResponseDTO(
                purchaseLog.getId(),
                purchaseLog.getPlatform().getDescription(),
                purchaseLog.getServiceType().getDescription(),
                purchaseLog.getTotalPrice(),
                purchaseLog.getCreateTime()
        );
        responseDTO.setItems(products);

        return responseDTO;
    }
}
