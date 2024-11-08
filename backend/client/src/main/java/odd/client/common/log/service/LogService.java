package odd.client.common.log.service;

import odd.client.common.item.dto.request.CartRequestDTO;
import odd.client.global.util.UserInfo;
import org.springframework.stereotype.Service;

@Service
public class LogService {

    public void addItemToCart(CartRequestDTO cartRequestDTO) {
        System.out.println(UserInfo.getId());
        System.out.println(cartRequestDTO);
    }
}
