package odd.client.common.search.service;

import odd.client.common.search.dto.response.ElasticsearchItemResponseDTO;
import odd.client.common.item.model.Item;
import odd.client.common.item.repository.ItemRepository;
import odd.client.common.search.model.ElasticsearchItem;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.suggest.Suggest;
import org.elasticsearch.search.suggest.SuggestBuilder;
import org.elasticsearch.search.suggest.SuggestBuilders;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ItemSearchService {

    @Autowired
    private RestHighLevelClient restHighLevelClient;

    @Autowired
    private ItemRepository itemRepository;

    // 자동완성 구현 (시작 및 포함된 단어)
    public List<String> autocomplete(String prefix) {
        List<String> suggestions = new ArrayList<>();
        try {
            SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();
            sourceBuilder.suggest(new SuggestBuilder()
                    .addSuggestion("autocomplete", SuggestBuilders
                            .completionSuggestion("itemNmSuggest")
                            .prefix(prefix)
                            .size(15)));

            SearchRequest searchRequest = new SearchRequest("items");
            searchRequest.source(sourceBuilder);

            SearchResponse searchResponse = restHighLevelClient.search(searchRequest, RequestOptions.DEFAULT);
            Suggest suggest = searchResponse.getSuggest();
            if (suggest != null) {
                Suggest.Suggestion<? extends Suggest.Suggestion.Entry<? extends Suggest.Suggestion.Entry.Option>> autocompleteSuggestion = suggest.getSuggestion("autocomplete");
                for (Suggest.Suggestion.Entry<? extends Suggest.Suggestion.Entry.Option> entry : autocompleteSuggestion) {
                    for (Suggest.Suggestion.Entry.Option option : entry) {
                        suggestions.add(option.getText().string());
                    }
                }
            }

            SearchSourceBuilder wildcardSourceBuilder = new SearchSourceBuilder();
            BoolQueryBuilder boolQuery = QueryBuilders.boolQuery()
                    .should(QueryBuilders.wildcardQuery("bd_item_nm", "*" + prefix + "*").boost(0.5f));
            wildcardSourceBuilder.query(boolQuery).size(20);

            SearchRequest wildcardSearchRequest = new SearchRequest("items");
            wildcardSearchRequest.source(wildcardSourceBuilder);

            SearchResponse wildcardSearchResponse = restHighLevelClient.search(wildcardSearchRequest, RequestOptions.DEFAULT);
            for (SearchHit hit : wildcardSearchResponse.getHits().getHits()) {
                Map<String, Object> sourceMap = hit.getSourceAsMap();
                String itemName = (String) sourceMap.get("bd_item_nm");
                if (itemName != null) {
                    suggestions.add(itemName);
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
        return suggestions.stream().distinct().collect(Collectors.toList());
    }

    // 검색 구현 (포함된 단어와 시작 단어 모두 포함)
    public Page<ElasticsearchItemResponseDTO> searchItemsByKeyword(String keyword, String platform, Pageable pageable) {
        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder()
                .query(QueryBuilders.boolQuery()
                        .should(QueryBuilders.matchPhrasePrefixQuery("bd_item_nm", keyword).boost(3.0f))
                        .should(QueryBuilders.matchQuery("bd_item_nm", keyword).boost(1.0f))
                        .should(QueryBuilders.wildcardQuery("bd_item_nm", "*" + keyword + "*").boost(0.5f)))
                .from((int) pageable.getOffset())
                .size(pageable.getPageSize())
                .sort("_score");

        System.out.println("Generated Query: " + sourceBuilder.toString());

        SearchRequest searchRequest = new SearchRequest("items");
        searchRequest.source(sourceBuilder);

        try {
            SearchResponse searchResponse = restHighLevelClient.search(searchRequest, RequestOptions.DEFAULT);
            List<ElasticsearchItemResponseDTO> items = new ArrayList<>();

            for (SearchHit hit : searchResponse.getHits().getHits()) {
                Map<String, Object> sourceMap = hit.getSourceAsMap();
                String itemId = (String) sourceMap.get("item_id");

                Item dbItem = itemRepository.findById(itemId.toString()).orElse(null);
                if (dbItem != null) {
                    boolean shouldInclude = false;
                    if ("GS25".equalsIgnoreCase(platform)) {
                        shouldInclude = "Y".equals(dbItem.getIsGs25Dlvy()) || "Y".equals(dbItem.getIsGs25Pickup());
                    } else if ("GS더프레시".equalsIgnoreCase(platform)) {
                        shouldInclude = "Y".equals(dbItem.getIsMartDlvy()) || "Y".equals(dbItem.getIsMartPickup());
                    } else if ("wine25".equalsIgnoreCase(platform)) {
                        shouldInclude = "Y".equals(dbItem.getIsWine25());
                    }

                    if (shouldInclude) {
                        ElasticsearchItemResponseDTO item = new ElasticsearchItemResponseDTO();
                        item.setItemId(dbItem.getId());
                        item.setItemName(dbItem.getBdItemNm());
                        item.setPlatform(platform);

                        List<String> serviceType = new ArrayList<>();
                        if ("GS25".equalsIgnoreCase(platform)) {
                            if ("Y".equals(dbItem.getIsGs25Dlvy())) serviceType.add("배달");
                            if ("Y".equals(dbItem.getIsGs25Pickup())) serviceType.add("픽업");
                        } else if ("GS더프레시".equalsIgnoreCase(platform)) {
                            if ("Y".equals(dbItem.getIsMartDlvy())) serviceType.add("배달");
                            if ("Y".equals(dbItem.getIsMartPickup())) serviceType.add("픽업");
                        } else if ("wine25".equalsIgnoreCase(platform)) {
                            if ("Y".equals(dbItem.getIsWine25())) serviceType.add("픽업");
                        }

                        item.setServiceType(serviceType);
                        item.setPrice(dbItem.getPrice());
                        item.setS3url(dbItem.getS3Url());

                        items.add(item);
                    }
                }
            }

            int totalPurchases = (int) searchResponse.getHits().getTotalHits().value;
            Page<ElasticsearchItemResponseDTO> pageResult = new PageImpl<>(items, pageable, totalPurchases);

            // 마지막 페이지 여부 확인 로그
            System.out.println("Is Last Page: " + pageResult.isLast());

            return pageResult;
        } catch (IOException e) {
            e.printStackTrace();
            return Page.empty();
        }
    }

}
