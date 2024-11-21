package odd.client.common.notification.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@Builder
@Schema(description = "주기별 추천 알고리즘 응답 DTO")
public class PeriodResponseDTO {

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private Long userId;

    private String itemId;

    private String itemName;

    private LocalDateTime recommendationDate;

    private List<LocalDateTime> purchaseDates;


    public static PeriodResponseDTO fromJsonToDto(Long userId, String itemId, String itemName, String recommendationDateStr, List<String> purchaseDatesStr) {
        LocalDateTime recommendationDate = LocalDateTime.parse(recommendationDateStr, DATE_TIME_FORMATTER);
        List<LocalDateTime> purchaseDates = purchaseDatesStr.stream()
                .map(date -> LocalDateTime.parse(date, DATE_TIME_FORMATTER))
                .collect(Collectors.toList());

        return PeriodResponseDTO.builder()
                .userId(userId)
                .itemId(itemId)
                .itemName(itemName)
                .recommendationDate(recommendationDate)
                .purchaseDates(purchaseDates)
                .build();
    }
}
