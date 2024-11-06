package odd.client.common.item.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum Platform {
    GS25("GS25"),
    GSFRESH("GS더프레시"),
    WINE25("WINE25")
    ;

    private String description;

}
