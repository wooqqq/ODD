package odd.client.common.item.entity;

public enum OrderType {
    DELIVERY("배달"),
    PICKUP("픽업");

    private String description;

    OrderType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
