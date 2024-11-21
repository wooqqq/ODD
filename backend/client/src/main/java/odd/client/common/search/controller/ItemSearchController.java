package odd.client.common.search.controller;

import odd.client.common.search.dto.response.ElasticsearchItemResponseDTO;
import odd.client.common.search.service.ItemSearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/search") // 기본 경로 설정
public class ItemSearchController {

    @Autowired
    private ItemSearchService itemSearchService;

    // 자동완성 엔드포인트
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/autocomplete")
    public List<String> getAutocompleteSuggestions(@RequestParam String keyword) {
        return itemSearchService.autocomplete(keyword);
    }

    // 검색 엔드포인트
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/items")
    public Page<ElasticsearchItemResponseDTO> searchItems(
            @RequestParam String keyword,
            @RequestParam String platform,
            Pageable pageable) {
        return itemSearchService.searchItemsByKeyword(keyword, platform, pageable);
    }
}
