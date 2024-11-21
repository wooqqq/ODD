package odd.client.common.item.repository;

import java.util.List;
import java.util.Optional;
import odd.client.common.item.model.Item;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ItemRepository extends JpaRepository<Item, Long> {

    Optional<Item> findById(String id);

    // 중분류(M) 카테고리 관련 메서드
    @Query("SELECT i FROM Item i WHERE i.bdItemMclsNm = :category " +
            "AND ((:dlvy = TRUE AND i.isGs25Dlvy = 'Y') OR " +
            "(:pickup = TRUE AND i.isGs25Pickup = 'Y') OR " +
            "(:dlvy = TRUE AND :pickup = TRUE AND (i.isGs25Dlvy = 'Y' OR i.isGs25Pickup = 'Y')))")
    Page<Item> findItemsByMAndGS25AndCondition(
            @Param("category") String category,
            @Param("dlvy") boolean dlvy,
            @Param("pickup") boolean pickup,
            Pageable pageable);

    @Query("SELECT i FROM Item i WHERE i.bdItemMclsNm = :category " +
            "AND ((:dlvy = TRUE AND i.isMartDlvy = 'Y') OR " +
            "(:pickup = TRUE AND i.isMartPickup = 'Y') OR " +
            "(:dlvy = TRUE AND :pickup = TRUE AND (i.isMartDlvy = 'Y' OR i.isMartPickup = 'Y')))")
    Page<Item> findItemsByMAndMartAndCondition(
            @Param("category") String category,
            @Param("dlvy") boolean dlvy,
            @Param("pickup") boolean pickup,
            Pageable pageable);

    Page<Item> findByBdItemMclsNmAndIsWine25(String bdItemMclsNm, String isWine25, Pageable pageable);

    // 소분류(S) 카테고리 관련 메서드
    @Query("SELECT i FROM Item i WHERE i.bdItemSclsNm = :category " +
            "AND ((:dlvy = TRUE AND i.isGs25Dlvy = 'Y') OR " +
            "(:pickup = TRUE AND i.isGs25Pickup = 'Y') OR " +
            "(:dlvy = TRUE AND :pickup = TRUE AND (i.isGs25Dlvy = 'Y' OR i.isGs25Pickup = 'Y')))")
    Page<Item> findItemsBySAndGS25AndCondition(
            @Param("category") String category,
            @Param("dlvy") boolean dlvy,
            @Param("pickup") boolean pickup,
            Pageable pageable);

    @Query("SELECT i FROM Item i WHERE i.bdItemSclsNm = :category " +
            "AND ((:dlvy = TRUE AND i.isMartDlvy = 'Y') OR " +
            "(:pickup = TRUE AND i.isMartPickup = 'Y') OR " +
            "(:dlvy = TRUE AND :pickup = TRUE AND (i.isMartDlvy = 'Y' OR i.isMartPickup = 'Y')))")
    Page<Item> findItemsBySAndMartAndCondition(
            @Param("category") String category,
            @Param("dlvy") boolean dlvy,
            @Param("pickup") boolean pickup,
            Pageable pageable);

    Page<Item> findByBdItemSclsNmAndIsWine25(String bdItemSclsNm, String isWine25, Pageable pageable);

    // 카테고리 조회 관련 메서드
    @Query("SELECT DISTINCT i.bdItemMclsNm FROM Item i WHERE i.isGs25Pickup = 'Y' OR i.isGs25Dlvy = 'Y'")
    List<String> findDistinctBdItemMclsNmByGs25();

    @Query("SELECT DISTINCT i.bdItemMclsNm FROM Item i WHERE i.isMartPickup = 'Y' OR i.isMartDlvy = 'Y'")
    List<String> findDistinctBdItemMclsNmByMart();

    @Query("SELECT DISTINCT i.bdItemMclsNm FROM Item i WHERE i.isWine25 = 'Y'")
    List<String> findDistinctBdItemMclsNmByWine25();

    // 아이템 조회 관련 메서드
    @Query("SELECT i FROM Item i WHERE i.bdItemMclsNm = :category AND (i.isGs25Pickup = 'Y' OR i.isGs25Dlvy = 'Y')")
    List<Item> findByBdItemMclsNmAndGs25(String category);

    @Query("SELECT i FROM Item i WHERE i.bdItemMclsNm = :category AND (i.isMartPickup = 'Y' OR i.isMartDlvy = 'Y')")
    List<Item> findByBdItemMclsNmAndMart(String category);

    @Query("SELECT i FROM Item i WHERE i.bdItemMclsNm = :category AND i.isWine25 = :isWine25")
    List<Item> findByBdItemMclsNmAndIsWine25(String category, String isWine25);
}