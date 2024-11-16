package odd.client.common.user.repository;

import odd.client.common.user.model.GsUser;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface GsUserRepository extends JpaRepository<GsUser, Long> {
    Optional<GsUser> findByGsUserId(String gsUserId);
}
