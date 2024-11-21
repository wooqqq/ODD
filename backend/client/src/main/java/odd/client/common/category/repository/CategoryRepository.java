package odd.client.common.category.repository;


import java.util.List;
import odd.client.common.category.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    List<Category> findByIsGs25(String isGs25);

    List<Category> findByIsMart(String isMart);

    List<Category> findByIsWine25(String isWine25);

    List<Category> findByIsGs25AndBdItemMclsNm(String isGs25, String bdItemMclsNm);

    List<Category> findByIsMartAndBdItemMclsNm(String isMart, String bdItemMclsNm);

    List<Category> findByIsWine25AndBdItemMclsNm(String isWine25, String bdItemMclsNm);

    @Query("SELECT DISTINCT c.bdItemMclsNm FROM Category c WHERE c.isGs25 = :isGs25 AND c.bdItemMclsNm IS NOT NULL")
    List<String> findDistinctBdItemMclsNmByIsGs25(String isGs25);

    @Query("SELECT DISTINCT c.bdItemMclsNm FROM Category c WHERE c.isMart = :isMart AND c.bdItemMclsNm IS NOT NULL")
    List<String> findDistinctBdItemMclsNmByIsMart(String isMart);

    @Query("SELECT DISTINCT c.bdItemMclsNm FROM Category c WHERE c.isWine25 = :isWine25 AND c.bdItemMclsNm IS NOT NULL")
    List<String> findDistinctBdItemMclsNmByIsWine25(String isWine25);
}
