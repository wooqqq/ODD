package odd.client.common.notification.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Getter
@Setter
@ToString
public class TimeSlotsResponseDTO {

    @JsonProperty("user_id")
    private String userId;

    @JsonProperty("time_slots")
    private List<Integer> timeSlots;

}
