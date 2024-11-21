package odd.client.common.category.service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import odd.client.common.category.dto.response.MiddleCategoryResponseDTO;
import odd.client.common.category.dto.response.SubCategoryResponseDTO;
import odd.client.common.category.model.Category;
import odd.client.common.category.repository.CategoryRepository;
import org.springframework.stereotype.Service;

@Service
public class CategoryService {

    private final CategoryRepository categoryRepository;

    public CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    public List<MiddleCategoryResponseDTO> getMiddleCategoriesByPlatform(String platform) {
        List<Category> categories = switch (platform) {
            case "GS25" -> categoryRepository.findByIsGs25("Y");
            case "GS더프레시" -> categoryRepository.findByIsMart("Y");
            case "wine25" -> categoryRepository.findByIsWine25("Y");
            default -> new ArrayList<>();
        };

        return categories.stream()
                .map(category -> new MiddleCategoryResponseDTO(category.getBdItemMclsNm(), category.getS3Url()))
                .distinct() // 중복 제거
                .collect(Collectors.toList());
    }

    public List<SubCategoryResponseDTO> getSubCategoriesByPlatform(String platform, String middle) {
        List<Category> categories = switch (platform) {
            case "GS25" -> categoryRepository.findByIsGs25AndBdItemMclsNm("Y", middle);
            case "GS더프레시" -> categoryRepository.findByIsMartAndBdItemMclsNm("Y", middle);
            case "wine25" -> categoryRepository.findByIsWine25AndBdItemMclsNm("Y", middle);
            default -> new ArrayList<>();
        };

        return categories.stream()
                .map(category -> new SubCategoryResponseDTO(category.getBdItemSclsNm()))
                .distinct()
                .collect(Collectors.toList());
    }

}
