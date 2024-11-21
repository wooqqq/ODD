package odd.client.common.user.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.Arrays;

@Getter
@RequiredArgsConstructor
public enum Category {
    GENERAL_FOOD("일반식품"),
    BEVERAGE("음료"),
    SNACKS("과자"),
    FRUIT("과일"),
    MEAT("축산"),
    VEGETABLE("채소"),
    DAIRY("유제품"),
    DAILY_NECESSITIES("일상용품"),
    ICE_CREAM("빙과류"),
    REFRIGERATED_FOOD("냉장식품"),
    SEAFOOD("수산"),
    PREPARED_FOOD("조리식품"),
    MEAL_KITS("밀키트"),
    FRESH_FOOD("FreshFood"),
    ALCOHOLIC_BEVERAGE("주류"),
    CONVENIENCE_FOOD("간편식품"),
    BEAUTY("뷰티");

    private final String categoryName;

    @JsonCreator
    public static Category fromValue(String value) {
        for (Category category : Category.values()) {
            if (category.name().equalsIgnoreCase(value)) {
                return category;
            }
        }
        throw new IllegalArgumentException("Unknown category: " + value);
    }

    @JsonValue
    public String getCategoryName() {
        return categoryName;
    }
}