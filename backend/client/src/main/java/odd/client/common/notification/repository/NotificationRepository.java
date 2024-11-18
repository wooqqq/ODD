package odd.client.common.notification.repository;

import odd.client.common.notification.model.Notification;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface NotificationRepository extends MongoRepository<Notification, String> {
    Optional<List<Notification>> findByUserId(Long userId);
}
