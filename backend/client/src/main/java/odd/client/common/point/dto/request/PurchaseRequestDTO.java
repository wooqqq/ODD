package odd.client.common.point.dto.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import odd.client.common.item.model.ServiceType;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PurchaseRequestDTO {
    private String platform;
    private ServiceType serviceType;
    private List<PurchaseItemDTO> items;
    private Integer total;
}
