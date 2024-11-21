package odd.client.common.dashboard.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AgeGroupResponseDTO {

    private int teens;

    private int twenties;

    private int thirties;

    private int forties;

    private int other;

    public void incrementAgeGroup(String ageGroup) {
        switch (ageGroup) {
            case "teens":
                this.teens++;
                break;
            case "twenties":
                this.twenties++;
                break;
            case "thirties":
                this.thirties++;
                break;
            case "forties":
                this.forties++;
                break;
            case "other":
                this.other++;
                break;
        }
    }
}
