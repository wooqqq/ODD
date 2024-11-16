package odd.client.common.user.repository;

import odd.client.common.user.model.FavCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserFavoriteCategoriesRepository extends JpaRepository<FavCategory, Long> {
    List<FavCategory> findByUserId(Long userId);
}