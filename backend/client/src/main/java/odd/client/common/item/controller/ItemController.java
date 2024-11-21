package odd.client.common.item.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import java.util.List;
import odd.client.common.item.dto.request.CartRequestDTO;
import odd.client.common.item.dto.response.ItemPageResponseDTO;
import odd.client.common.item.dto.response.ItemResponseDTO;
import odd.client.common.item.dto.response.ItemWithPurchaseCountRseponseDTO;
import odd.client.common.item.service.ItemService;
import odd.client.common.log.service.LogService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/item")
public class ItemController {

    private final ItemService itemService;
    private final LogService logService;

    public ItemController(ItemService itemService, LogService logService) {
        this.itemService = itemService;
        this.logService = logService;
    }

    @GetMapping("/detail/{itemId}/{platform}")
    @Operation(summary = "상품 상세 조회", description = "상품 상제 조회할 때 사용하는 API")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "상품 상세 조회",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = ItemResponseDTO.class))),
            @ApiResponse(responseCode = "404",
                    description = "Error Message 로 전달함",
                    content = @Content(mediaType = "application/json"))})
    public ResponseEntity<?> getItemDetails(@PathVariable String itemId, @PathVariable String platform) {

        ItemResponseDTO item = itemService.getItemDetails(itemId, platform);
        if (item == null) {
            return ResponseEntity.status(404).body("데이터가 존재하지 않거나 log 저장 실패");
        }
        return ResponseEntity.ok(item);
    }

    @GetMapping("")
    @Operation(summary = "상품 리스트 조회", description = "상품 리스트를 조회하는 API")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "상품 리스트 조회 성공",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = ItemPageResponseDTO.class))),
            @ApiResponse(responseCode = "404",
                    description = "Error Message 로 전달함",
                    content = @Content(mediaType = "application/json"))})
    public ResponseEntity<?> getItemsByCategory(@RequestParam("platform") String platform,
                                                @RequestParam("middle") String middle,
                                                @RequestParam(value = "sub", defaultValue = "전체") String sub,
                                                @RequestParam(value = "sort", defaultValue = "추천") String sort,
                                                @RequestParam(value = "filter", defaultValue = "전체") String filter,
                                                @RequestParam(value = "page", defaultValue = "0") int page,
                                                @RequestParam(value = "size", defaultValue = "20") int size) {

        ItemPageResponseDTO items = itemService.getItemsByPlatformAndSubCategory(platform, middle, sub, sort,
                filter,
                page, size);
        if (items.getItems().isEmpty()) {
            return ResponseEntity.status(404).body("데이터가 존재하지 않습니다.");
        }
        return ResponseEntity.ok(items);
    }

    @PostMapping("/cart")
    @Operation(summary = "장바구니 담기", description = "상품을 장바구니에 담는 API")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "",
                    content = @Content(mediaType = "application/json")),
            @ApiResponse(responseCode = "404",
                    description = "Error Message 로 전달함",
                    content = @Content(mediaType = "application/json"))})
    public ResponseEntity<?> addItemToCart(@RequestBody CartRequestDTO cartRequestDTO) {

        boolean done = logService.addItemToCart(cartRequestDTO);
        if (!done) {
            return ResponseEntity.status(404).body("로그 저장 실패");
        }
        return ResponseEntity.ok("log 등록 성공");
    }


    // 특정 시간대에 구매했던 상품 (시간 입력 필요 O)
    @GetMapping("/time-rec")
    @Operation(summary = "특정 시간 추천 상품 목록 조회", description = "특정 시간을 기반으로 상품 목록 추천하는 API")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "특정 시간을 기반으로 상품 목록 조회",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = ItemResponseDTO.class))),
            @ApiResponse(responseCode = "404",
                    description = "Error Message 로 전달함",
                    content = @Content(mediaType = "application/json"))})
    public ResponseEntity<?> getTimeBasedRecommendedItems(
            @RequestParam(value = "platform", defaultValue = "GS25") String platform,
            @RequestParam(value = "hour") int hour) {

        List<ItemResponseDTO> items = itemService.getTimeBasedRecommendedItems(platform, hour);

        return ResponseEntity.ok(items);
    }

    // 특정 시간대에 구매했던 상품 (시간 입력 필요 X)
    @GetMapping("/time-total-rec")
    @Operation(summary = "특정 시간 추천 상품 목록 조회", description = "특정 시간을 기반으로 상품 목록 추천하는 API")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "특정 시간을 기반으로 상품 목록 조회",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = ItemResponseDTO.class))),
            @ApiResponse(responseCode = "404",
                    description = "Error Message 로 전달함",
                    content = @Content(mediaType = "application/json"))})
    public ResponseEntity<?> getTotalTimeBasedRecommendedItems(
            @RequestParam(value = "platform", defaultValue = "GS25") String platform) {

        List<ItemResponseDTO> items = itemService.getTotalTimeBasedRecommendedItems(platform);

        return ResponseEntity.ok(items);
    }

    @GetMapping("/fav-category")
    public ResponseEntity<?> getFavoriteCategoryItems(
            @RequestParam(value = "platform", defaultValue = "GS25") String platform) {

        // 로깅 추가 - 플랫폼 값 확인
        System.out.println("Received platform parameter: " + platform);

        try {
            List<ItemResponseDTO> items = itemService.getFavoriteCategoryItems(platform);
            return ResponseEntity.ok(items);
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("An unexpected error occurred: " + e.getMessage());
        }
    }

    @GetMapping("/fav-category/all")
    public ResponseEntity<?> getAllPlatformItems() {
        System.out.println("Received request for all platform items");

        try {
            List<ItemResponseDTO> items = itemService.getAllPlatformItems();
            return ResponseEntity.ok(items);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("An unexpected error occurred: " + e.getMessage());
        }
    }

    @GetMapping("/purchase-cycle")
    @Operation(summary = "구매 주기 기반 상품 목록 조회", description = "구매 주기를 기반으로 상품 목록 추천하는 API")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "구매 주기를 기반으로 상품 목록 조회",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = ItemResponseDTO.class))),
            @ApiResponse(responseCode = "404",
                    description = "Error Message 로 전달함",
                    content = @Content(mediaType = "application/json"))})
    public ResponseEntity<?> getPurchaseCycleBasedRecommendations(
            @RequestParam(value = "platform", defaultValue = "GS25") String platform) {

        List<ItemResponseDTO> items = itemService.getPurchaseCycleBasedRecommendations(platform);

        return ResponseEntity.ok(items);
    }

    @GetMapping("/recent-purchase")
    @Operation(summary = "최근 구매 목록 상품 조회", description = "최근 구매를 기반으로 상품 목록 추천하는 API")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "구매 주기를 기반으로 상품 목록 조회",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = ItemResponseDTO.class))),
            @ApiResponse(responseCode = "404",
                    description = "Error Message 로 전달함",
                    content = @Content(mediaType = "application/json"))})
    public ResponseEntity<?> getRecentPurchaseItems(
            @RequestParam(value = "platform", defaultValue = "전체") String platform) {

        List<ItemWithPurchaseCountRseponseDTO> items = itemService.getRecentPurchaseItems();

//        return ResponseEntity.noContent().build();
        return ResponseEntity.ok(items);
    }
}
