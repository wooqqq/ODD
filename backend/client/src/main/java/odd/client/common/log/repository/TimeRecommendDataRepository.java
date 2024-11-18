package odd.client.common.log.repository;

import java.util.UUID;
import odd.client.common.log.model.TimeRecommendData;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TimeRecommendDataRepository extends CassandraRepository<TimeRecommendData, UUID> {
}