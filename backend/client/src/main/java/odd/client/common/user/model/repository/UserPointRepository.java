package odd.client.common.user.model.repository;

import odd.client.common.user.entity.UserPoint;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserPointRepository extends JpaRepository<UserPoint, Long> {
    Optional<UserPoint> findByUserId(Long userId);
}
