package odd.client.common.category.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import java.util.List;
import odd.client.common.category.dto.response.MiddleCategoryResponseDTO;
import odd.client.common.category.dto.response.SubCategoryResponseDTO;
import odd.client.common.category.service.CategoryService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/category")
public class CategoryController {

    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping("/platform")
    @Operation(summary = "플랫폼 중분류 카테고리 조회", description = "플랫폼별 중분류 카테고리 조회할 때 사용하는 API")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "중분류 카테고리 조회",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = MiddleCategoryResponseDTO.class))
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "Error Message 로 전달함",
                    content = @Content(mediaType = "application/json")
            )
    })
    public ResponseEntity<?> getMiddleCategoriesByPlatform(@RequestParam("platform") String platform) {
        List<MiddleCategoryResponseDTO> categories = categoryService.getMiddleCategoriesByPlatform(platform);

        if (categories.isEmpty()) {
            return ResponseEntity.status(404).body("유효하지 않은 플랫폼입니다.");
        }
        return ResponseEntity.ok(categories);
    }

    @GetMapping("/middle")
    @Operation(summary = "플랫폼 소분류 카테고리 조회", description = "플랫폼별 소분류 카테고리 조회할 때 사용하는 API")
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "소분류 카테고리 조회",
                    content = @Content(mediaType = "application/json", schema = @Schema(implementation = SubCategoryResponseDTO.class))
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "Error Message 로 전달함",
                    content = @Content(mediaType = "application/json")
            )
    })
    public ResponseEntity<?> getSubCategoriesByPlatform(@RequestParam("platform") String platform,
                                                        @RequestParam("middle") String middle) {
        List<SubCategoryResponseDTO> categories = categoryService.getSubCategoriesByPlatform(platform, middle);

        if (categories.isEmpty()) {
            return ResponseEntity.status(404).body("유효하지 않은 값입니다.");
        }
        return ResponseEntity.ok(categories);
    }
}
