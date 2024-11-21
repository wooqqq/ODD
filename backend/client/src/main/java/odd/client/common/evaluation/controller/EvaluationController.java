package odd.client.common.evaluation.controller;

import java.util.List;
import java.util.Map;

import odd.client.common.evaluation.dto.response.*;
import odd.client.common.evaluation.service.EvaluationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/evaluation")
public class EvaluationController {

    private final EvaluationService evaluationService;

    public EvaluationController(EvaluationService evaluationService) {
        this.evaluationService = evaluationService;
    }

    @GetMapping("/search/{email}")
    public ResponseEntity<?> searchUser(@PathVariable String email) {
        UserResponseDTO user = evaluationService.searchUserByEmail(email);
        return ResponseEntity.ok(user);
    }

    @GetMapping("/{userId}")
    public ResponseEntity<?> getUserInfo(@PathVariable String userId) {
        UserResponseDTO userInfo = evaluationService.getUserInfo(userId);
        return ResponseEntity.ok(userInfo);
    }

    @GetMapping("/{userId}/platform-stats")
    public ResponseEntity<?> getPlatformStats(@PathVariable String userId) {
        PlatformStatsResponseDTO platformStats = evaluationService.getPlatformStats(userId);
        return ResponseEntity.ok(platformStats);
    }

    @GetMapping("/fav-category/{userId}/{platform}")
    public ResponseEntity<?> getFavoriteCategoryItems(@PathVariable String userId,
                                                      @PathVariable String platform) {
        List<ItemResponseDTO> favoriteItems = evaluationService.getFavoriteCategoryItems(userId, platform);
        return ResponseEntity.ok(favoriteItems);
    }

    @GetMapping("/time-rec/{userId}")
    public ResponseEntity<?> getTimeRecommendedItems(@PathVariable String userId) {
        Map<Integer, List<TimeRecItemResponseDTO>> recommendedItems = evaluationService.getTimeRecommendedItems(userId);
        return ResponseEntity.ok(recommendedItems);
    }

    @GetMapping("/purchase-cycle/{userId}")
    public ResponseEntity<?> getPurchaseCycleItems(@PathVariable String userId) {
        List<PurchaseCycleItemResponseDTO> purchaseCycleItems = evaluationService.getPurchaseCycleItems(userId);
        return ResponseEntity.ok(purchaseCycleItems);
    }

    @GetMapping("/purchase/{userId}/{platform}")
    public ResponseEntity<?> getPurchaseItems(@PathVariable String userId,
                                              @PathVariable String platform) {
        List<PurchaseLogResponseDTO> purchaseItems = evaluationService.getPurchaseItems(userId, platform);
        return ResponseEntity.ok(purchaseItems);
    }

    @GetMapping("/log/{userId}/{platform}")
    public ResponseEntity<?> getLogs(@PathVariable String userId, @PathVariable String platform) {
        List<LogResponseDTO> logs = evaluationService.getLogs(userId, platform);
        return ResponseEntity.ok(logs);
    }

}
