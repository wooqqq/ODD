package odd.client.common.item.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum ServiceType {
    DELIVERY("배달"),
    PICKUP("픽업");

    private final String description;

    @JsonValue
    public String getDescription() {
        return this.description;
    }

    @JsonCreator
    public static ServiceType fromDescription(String description) {
        for (ServiceType type : ServiceType.values()) {
            if (type.getDescription().equals(description)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown description: " + description);
    }
}
