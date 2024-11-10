package odd.client.common.purchase.repository;

import odd.client.common.purchase.model.PurchaseItem;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PurchaseItemRepository extends JpaRepository<PurchaseItem, Long> {
}
