package odd.client.common.user.repository;

import odd.client.common.user.model.GsUser;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GsUserRepository extends JpaRepository<GsUser, Long> {
}
