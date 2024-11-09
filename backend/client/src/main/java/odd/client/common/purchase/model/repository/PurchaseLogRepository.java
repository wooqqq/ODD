package odd.client.common.purchase.model.repository;

import odd.client.common.purchase.entity.PurchaseLog;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PurchaseLogRepository extends JpaRepository<PurchaseLog, Long> {
}
