package odd.client.common.purchase.repository;

import java.time.LocalDateTime;
import java.util.List;
import odd.client.common.item.model.Platform;
import odd.client.common.item.model.ServiceType;
import odd.client.common.purchase.model.PurchaseLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PurchaseLogRepository extends JpaRepository<PurchaseLog, Long> {
    @Query("SELECT pl FROM PurchaseLog pl " +
            "WHERE pl.user.id = :userId " +
            "AND (:platform IS NULL OR pl.platform = :platform) " +
            "AND (:serviceType IS NULL OR :serviceType = '전체' OR pl.serviceType = :serviceType) " +
            "ORDER BY pl.createTime DESC")
    Page<PurchaseLog> findByUserIdAndConditions(
            @Param("userId") Long userId,
            @Param("platform") Platform platform,
            @Param("serviceType") ServiceType serviceType,
            Pageable pageable);

    @Query("SELECT COUNT(p) FROM PurchaseLog p WHERE p.user.id = :userId")
    int countOrdersByUserId(Long userId);

    @Query("SELECT pl FROM PurchaseLog pl " +
            "WHERE pl.user.id = :userId " +
            "AND pl.platform = :platform " +
            "ORDER BY pl.createTime DESC")
    List<PurchaseLog> findByUserIdAndPlatform(Long userId, Platform platform);

    @Query("SELECT pl FROM PurchaseLog pl " +
            "WHERE pl.user.id = :userId " +
            "AND pl.platform = :platform " +
            "AND pl.createTime >= :sevenDaysAgo " + // 7일 전 날짜 필터 추가
            "ORDER BY pl.createTime DESC")
    List<PurchaseLog> findByUserIdAndPlatformAndCreateTimeAfter(
            @Param("userId") Long userId,
            @Param("platform") Platform platform,
            @Param("sevenDaysAgo") LocalDateTime sevenDaysAgo);


    @Query("SELECT pl FROM PurchaseLog pl WHERE pl.user.id = :userId AND pl.createTime >= :startDate")
    List<PurchaseLog> findRecentPurchasesByUserId(
            @Param("userId") Long userId,
            @Param("startDate") LocalDateTime startDate);

    @Query("SELECT p FROM PurchaseLog p WHERE p.platform = :platform AND p.createTime >= :startDate")
    List<PurchaseLog> findRecentPurchasesByPlatform(Platform platform, LocalDateTime startDate);
}
