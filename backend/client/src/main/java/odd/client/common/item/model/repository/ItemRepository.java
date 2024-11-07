package odd.client.common.item.model.repository;

import odd.client.common.item.entity.Item;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ItemRepository extends JpaRepository<Item, Long> {
    Optional<Item> findById(Long id);
    List<Item> findByBdItemLclsNm(String bdItemLclsNm);

}
