package odd.client.common.search.repository;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import odd.client.common.search.model.ElasticsearchItem;
import java.util.List;

public interface ItemSearchRepository extends ElasticsearchRepository<ElasticsearchItem, Long> {
    // 필드명을 올바르게 변경
    List<ElasticsearchItem> findByItemNmContaining(String keyword);

    List<ElasticsearchItem> findSuggestionsByItemNmSuggest(String prefix);
}
