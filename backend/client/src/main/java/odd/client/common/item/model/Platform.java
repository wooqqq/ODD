package odd.client.common.item.model;

import java.util.HashMap;
import java.util.Map;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum Platform {
    GS25("GS25", "gs25"),
    GSFRESH("GS더프레시", "mart"),
    WINE25("wine25", "wine25");

    private final String description;
    private final String forLog;

    private static final Map<String, Platform> BY_DESCRIPTION = new HashMap<>();

    static {
        for (Platform platform : values()) {
            BY_DESCRIPTION.put(platform.description, platform);
        }
    }

    public static Platform fromDescription(String description) {
        Platform platform = BY_DESCRIPTION.get(description);
        if (platform == null) {
            throw new IllegalArgumentException("일치하는 Platform이 없습니다: " + description);
        }
        return platform;
    }

}
