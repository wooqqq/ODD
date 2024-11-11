package odd.client.common.search.repository;

import odd.client.common.search.model.ElasticsearchItem;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ItemSearchRepository extends ElasticsearchRepository<ElasticsearchItem, Long> {
    List<ElasticsearchItem> findByBdItemNmStartingWith(String prefix);
    List<ElasticsearchItem> findByBdItemNmContaining(String keyword);
}
