package odd.client.common.log.repository;

import java.util.UUID;
import odd.client.common.log.model.PeriodRecommendData;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PeriodRecommendDataRepository extends CassandraRepository<PeriodRecommendData, UUID> {
}