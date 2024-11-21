package odd.client.common.purchase.repository;

import java.util.List;
import odd.client.common.purchase.model.PurchaseItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PurchaseItemRepository extends JpaRepository<PurchaseItem, Long> {
    @Query("SELECT pi FROM PurchaseItem pi WHERE pi.log.id = :logId ORDER BY pi.id ASC LIMIT 1")
    PurchaseItem findFirstByLogId(@Param("logId") Long logId);

    @Query("SELECT pi FROM PurchaseItem pi WHERE pi.log.id IN :logIds ORDER BY pi.log.id, pi.id ASC")
    List<PurchaseItem> findFirstItemsByLogIds(@Param("logIds") List<Long> logIds);

    @Query("SELECT pi FROM PurchaseItem pi WHERE pi.log.id = :logId")
    List<PurchaseItem> findByLogId(@Param("logId") Long logId);

    @Query("SELECT pi FROM PurchaseItem pi WHERE pi.log.id IN :logIds")
    List<PurchaseItem> findByLogIds(List<Long> logIds);
}
