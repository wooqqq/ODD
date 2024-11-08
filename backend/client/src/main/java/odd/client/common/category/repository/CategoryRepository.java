package odd.client.common.category.repository;


import odd.client.common.category.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    List<Category> findByIsGs25(String isGs25);
    List<Category> findByIsMart(String isMart);
    List<Category> findByIsWine25(String isWine25);
}
