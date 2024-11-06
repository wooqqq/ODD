package odd.client.common.point.model.repository;

import odd.client.common.point.entity.UserPoint;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserPointRepository extends JpaRepository<UserPoint, Long> {
    Optional<UserPoint> findByUserId(Long userId);
}
