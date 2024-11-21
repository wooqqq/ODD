package odd.manager.common.dashobard.controller;

import lombok.RequiredArgsConstructor;
import odd.manager.common.dashobard.dto.response.CategoryStatsResponseDTO;
import odd.manager.common.dashobard.dto.response.GenderAgeGroupResponseDTO;
import odd.manager.common.dashobard.dto.response.ItemResponseWithCountDTO;
import odd.manager.common.dashobard.dto.response.ReorderRatioResponseDTO;
import odd.manager.common.dashobard.service.DashboardService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService dashboardService;

    @GetMapping("/item/categories/stats")
    public ResponseEntity<?> getCategoryStats(
            @RequestParam(defaultValue = "odd") String data,
            @RequestParam(defaultValue = "GS25") String platform) {
        List<CategoryStatsResponseDTO> stats = dashboardService.getCategoryStats(data, platform);
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/item/top-repurchase")
    public ResponseEntity<?> getTopRepurchaseItems(
            @RequestParam(defaultValue = "odd") String data,
            @RequestParam(defaultValue = "GS25") String platform,
            @RequestParam(defaultValue = "전체") String category) {
        List<ItemResponseWithCountDTO> items = dashboardService.getTopRepurchaseItems(data, platform,category);
        return ResponseEntity.ok(items);
    }

    @GetMapping("/item/top-views")
    public ResponseEntity<?> getTopViewedItems(
            @RequestParam(defaultValue = "odd") String data,
            @RequestParam(defaultValue = "GS25") String platform,
            @RequestParam(defaultValue = "전체") String category) {
        List<ItemResponseWithCountDTO> items = dashboardService.getTopViewedItems(data, platform,category);
        return ResponseEntity.ok(items);
    }

    @GetMapping("/item/top-cart")
    public ResponseEntity<?> getTopCartItems(
            @RequestParam(defaultValue = "odd") String data,
            @RequestParam(defaultValue = "GS25") String platform,
            @RequestParam(defaultValue = "전체") String category) {
        List<ItemResponseWithCountDTO> items = dashboardService.getTopCartItems(data, platform,category);
        return ResponseEntity.ok(items);
    }

    @GetMapping("/item/top-purchase")
    public ResponseEntity<?> getTopPurchasedItems(
            @RequestParam(defaultValue = "odd") String data,
            @RequestParam(defaultValue = "GS25") String platform,
            @RequestParam(defaultValue = "전체") String category) {
        List<ItemResponseWithCountDTO> items = dashboardService.getTopPurchasedItems(data, platform,category);
        return ResponseEntity.ok(items);
    }

    @GetMapping("/user/reorder")
    public ResponseEntity<?> getReorderUserRatio(
            @RequestParam(defaultValue = "odd") String data,
            @RequestParam(defaultValue = "GS25") String platform) {
        ReorderRatioResponseDTO response = dashboardService.getReorderUserRatio(data, platform);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/user/reorder-age")
    public ResponseEntity<?> getReorderUserCountByAgeAndGender(
            @RequestParam(defaultValue = "odd") String data,
            @RequestParam(defaultValue = "GS25") String platform) {
        GenderAgeGroupResponseDTO response = dashboardService.getReorderUserCountByAgeAndGender(data, platform);
        return ResponseEntity.ok(response);
    }
}