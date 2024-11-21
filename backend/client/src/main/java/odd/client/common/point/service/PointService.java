package odd.client.common.point.service;

import odd.client.common.user.repository.UserRepository;
import odd.client.common.user.model.User;
import org.springframework.stereotype.Service;

@Service
public class PointService {

    private final UserRepository userRepository;

    public PointService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public Long getTotalPoints(Long userId) {
        System.out.println("Fetching total points for userId: " + userId);
        Long points = userRepository.findById(userId)
                .map(User::getPoints)
                .orElse(0L);
        System.out.println("Total points found: " + points);
        return points;
    }
}
