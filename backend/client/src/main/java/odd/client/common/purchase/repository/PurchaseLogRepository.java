package odd.client.common.purchase.repository;

import odd.client.common.purchase.model.PurchaseLog;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PurchaseLogRepository extends JpaRepository<PurchaseLog, Long> {
}
