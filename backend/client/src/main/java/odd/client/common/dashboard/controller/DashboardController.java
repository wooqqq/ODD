package odd.client.common.dashboard.controller;

import java.util.List;
import lombok.RequiredArgsConstructor;
import odd.client.common.dashboard.dto.response.CategoryStatsResponseDTO;
import odd.client.common.dashboard.dto.response.GenderAgeGroupResponseDTO;
import odd.client.common.dashboard.dto.response.ItemResponseWithCountDTO;
import odd.client.common.dashboard.dto.response.ReorderRatioResponseDTO;
import odd.client.common.dashboard.service.DashboardService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService dashboardService;

    @GetMapping("/item/categories/stats")
    public ResponseEntity<?> getCategoryStats(
            @RequestParam String data,
            @RequestParam String platform) {
        List<CategoryStatsResponseDTO> stats = dashboardService.getCategoryStats(data, platform);
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/item/top-repurchase")
    public ResponseEntity<?> getTopRepurchaseItems(
            @RequestParam String data,
            @RequestParam String platform,
            @RequestParam(defaultValue = "전체") String category) {
        List<ItemResponseWithCountDTO> items = dashboardService.getTopRepurchaseItems(data, platform, category);
        return ResponseEntity.ok(items);
    }

    @GetMapping("/item/top-views")
    public ResponseEntity<?> getTopViewedItems(
            @RequestParam String data,
            @RequestParam String platform,
            @RequestParam(defaultValue = "전체") String category) {
        List<ItemResponseWithCountDTO> items = dashboardService.getTopViewedItems(data, platform, category);
        return ResponseEntity.ok(items);
    }

    @GetMapping("/item/top-cart")
    public ResponseEntity<?> getTopCartItems(
            @RequestParam String data,
            @RequestParam String platform,
            @RequestParam(defaultValue = "전체") String category) {
        List<ItemResponseWithCountDTO> items = dashboardService.getTopCartItems(data, platform, category);
        return ResponseEntity.ok(items);
    }

    @GetMapping("/item/top-purchase")
    public ResponseEntity<?> getTopPurchasedItems(
            @RequestParam String data,
            @RequestParam String platform,
            @RequestParam(defaultValue = "전체") String category) {
        List<ItemResponseWithCountDTO> items = dashboardService.getTopPurchasedItems(data, platform, category);
        return ResponseEntity.ok(items);
    }

    @GetMapping("/user/reorder")
    public ResponseEntity<?> getReorderUserRatio(
            @RequestParam String data,
            @RequestParam String platform) {
        ReorderRatioResponseDTO responseDTO = dashboardService.getReorderUserRatio(data, platform);
        return ResponseEntity.ok(responseDTO);
    }

    @GetMapping("/user/reorder-age")
    public ResponseEntity<?> getReorderUserCountByAgeAndGender(
            @RequestParam String data,
            @RequestParam String platform) {
        GenderAgeGroupResponseDTO responseDTO = dashboardService.getReorderUserCountByAgeAndGender(data, platform);
        return ResponseEntity.ok(responseDTO);
    }
}