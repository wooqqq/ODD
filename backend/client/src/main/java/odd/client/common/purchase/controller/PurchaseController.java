package odd.client.common.purchase.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import odd.client.common.purchase.dto.request.PurchaseRequestDTO;
import odd.client.common.purchase.dto.response.PurchaseLogDetailResponseDTO;
import odd.client.common.purchase.dto.response.PurchaseLogPageResponseDTO;
import odd.client.common.purchase.service.PurchaseService;
import odd.client.global.security.CustomUserDetails;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/purchase")
public class PurchaseController {

    private final PurchaseService purchaseService;

    public PurchaseController(PurchaseService purchaseService) {
        this.purchaseService = purchaseService;
    }

    @PostMapping("")
    public String purchase(@AuthenticationPrincipal CustomUserDetails userDetails,
                           @RequestBody PurchaseRequestDTO request) {
        if (userDetails == null || userDetails.getUser() == null) {
            throw new IllegalArgumentException("인증된 사용자 정보를 찾을 수 없습니다.");
        }
        Long userId = userDetails.getUser().getId();
        purchaseService.processPurchase(userId, request);
        return "구매가 성공적으로 처리되었습니다.";
    }

    @GetMapping("/list")
    @Operation(summary = "구매 목록 조회", description = "구매 목록 조회 API")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "구매 목록 조회",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = PurchaseLogPageResponseDTO.class))),
            @ApiResponse(responseCode = "404",
                    description = "Error Message 로 전달함",
                    content = @Content(mediaType = "application/json"))})
    public ResponseEntity<?> getPurchaseList(@AuthenticationPrincipal CustomUserDetails userDetails,
                                             @RequestParam("platform") String platform,
                                             @RequestParam(value = "serviceType", defaultValue = "전체") String serviceType,
                                             @RequestParam(value = "page", defaultValue = "0") int page,
                                             @RequestParam(value = "size", defaultValue = "10") int size) {
        if (userDetails == null || userDetails.getUser() == null) {
            throw new IllegalArgumentException("인증된 사용자 정보를 찾을 수 없습니다.");
        }
        PurchaseLogPageResponseDTO logs = purchaseService.getPurchaseList(platform, serviceType, page, size);
        if (logs.getPurchases().isEmpty()) {
            return ResponseEntity.status(404).body("데이터가 존재하지 않습니다.");
        }
        return ResponseEntity.ok(logs);

    }

    @GetMapping("/{purchaseId}")
    @Operation(summary = "구매 상세 조회", description = "구매 상세 조회 API")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "구매 상세 조회",
                    content = @Content(mediaType = "application/json",
                            schema = @Schema(implementation = PurchaseLogDetailResponseDTO.class))),
            @ApiResponse(responseCode = "404",
                    description = "Error Message 로 전달함",
                    content = @Content(mediaType = "application/json"))})
    public ResponseEntity<?> getPurchaseDetail(
            @PathVariable("purchaseId") Long purchaseId) {

        PurchaseLogDetailResponseDTO log = purchaseService.getPurchaseDetail(purchaseId);
        if (log.getItems().isEmpty()) {
            return ResponseEntity.status(404).body("데이터가 존재하지 않습니다.");
        }
        return ResponseEntity.ok(log);
    }

}
