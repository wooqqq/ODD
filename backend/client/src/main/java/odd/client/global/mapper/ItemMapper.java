package odd.client.global.mapper;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ForkJoinPool;
import java.util.stream.Collectors;
import lombok.extern.slf4j.Slf4j;
import odd.client.common.item.dto.response.ItemResponseDTO;
import odd.client.common.item.model.Item;
import odd.client.common.item.model.Platform;
import odd.client.common.item.model.ServiceType;

@Slf4j
public class ItemMapper {

    private static final String YES_VALUE = "Y";
    private static final int PARALLEL_THRESHOLD = 1000; // 병렬처리 임계값
    private static final ForkJoinPool customThreadPool = new ForkJoinPool(
            Runtime.getRuntime().availableProcessors() // CPU 코어 수에 맞춤
    );

    public static ItemResponseDTO toDTO(Item item, Platform platform) {
        PlatformInfo platformInfo = getPlatformInfo(item, platform);

        return new ItemResponseDTO(
                item.getId(),
                item.getBdItemNm(),
                platformInfo.platformDescription(),
                platformInfo.serviceTypes(),
                item.getPrice(),
                item.getS3Url()
        );
    }

    public static List<ItemResponseDTO> toDTOList(List<Item> items, Platform platform) {
        if (items == null || items.isEmpty()) {
            return List.of();
        }

        // 데이터 크기가 임계값보다 작으면 일반 스트림 사용
        if (items.size() < PARALLEL_THRESHOLD) {
            return items.stream()
                    .map(item -> toDTO(item, platform))
                    .collect(Collectors.toList());
        }

        try {
            // 커스텀 스레드 풀을 사용한 병렬 처리
            return customThreadPool.submit(() ->
                    items.parallelStream()
                            .map(item -> toDTO(item, platform))
                            .collect(Collectors.toList())
            ).get();
        } catch (Exception e) {
            log.error("Error during parallel processing: ", e);
            // 에러 발생 시 일반 스트림으로 폴백
            return items.stream()
                    .map(item -> toDTO(item, platform))
                    .collect(Collectors.toList());
        }
    }

    private static PlatformInfo getPlatformInfo(Item item, Platform platform) {
        return switch (platform) {
            case GS25 -> handleGS25Platform(item);
            case GSFRESH -> handleGSFreshPlatform(item);
            case WINE25 -> handleWine25Platform(item);
        };
    }

    private static PlatformInfo handleGS25Platform(Item item) {
        if (!YES_VALUE.equals(item.getIsGs25Dlvy()) && !YES_VALUE.equals(item.getIsGs25Pickup())) {
            return new PlatformInfo("", List.of());
        }

        List<String> serviceTypes = new ArrayList<>(2);
        if (YES_VALUE.equals(item.getIsGs25Dlvy())) {
            serviceTypes.add(ServiceType.DELIVERY.getDescription());
        }
        if (YES_VALUE.equals(item.getIsGs25Pickup())) {
            serviceTypes.add(ServiceType.PICKUP.getDescription());
        }

        return new PlatformInfo(Platform.GS25.getDescription(), serviceTypes);
    }

    private static PlatformInfo handleGSFreshPlatform(Item item) {
        if (!YES_VALUE.equals(item.getIsMartDlvy()) && !YES_VALUE.equals(item.getIsMartPickup())) {
            return new PlatformInfo("", List.of());
        }

        List<String> serviceTypes = new ArrayList<>(2);
        if (YES_VALUE.equals(item.getIsMartDlvy())) {
            serviceTypes.add(ServiceType.DELIVERY.getDescription());
        }
        if (YES_VALUE.equals(item.getIsMartPickup())) {
            serviceTypes.add(ServiceType.PICKUP.getDescription());
        }

        return new PlatformInfo(Platform.GSFRESH.getDescription(), serviceTypes);
    }

    private static PlatformInfo handleWine25Platform(Item item) {
        if (!YES_VALUE.equals(item.getIsWine25())) {
            return new PlatformInfo("", List.of());
        }
        List<String> serviceTypes = new ArrayList<>(1);
        serviceTypes.add(ServiceType.PICKUP.getDescription());
        return new PlatformInfo(Platform.WINE25.getDescription(), serviceTypes);
    }

    private record PlatformInfo(String platformDescription, List<String> serviceTypes) {
    }
}