package odd.client.common.log.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import odd.client.common.log.model.Log;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface LogRepository extends CassandraRepository<Log, UUID> {

    @Query("SELECT * FROM logs WHERE user_id = :userId AND inter = :inter AND service IN :services ALLOW FILTERING")
    List<Log> findByUserIdAndInterAndServiceIn(
            @Param("userId") String userId,
            @Param("inter") String inter,
            @Param("services") List<String> services);

    @Query("SELECT * FROM logs WHERE user_id = :userId AND service IN :services AND date >= :sevenDaysAgo ALLOW FILTERING")
    List<Log> findByUserIdAndRecentLogsWithService(
            @Param("userId") String userId,
            @Param("services") List<String> services,
            @Param("sevenDaysAgo") LocalDate sevenDaysAgo);

    @Query("SELECT * FROM logs WHERE user_id = :userId AND date >= :startDate ALLOW FILTERING")
    List<Log> findByUserIdAndDateAfter(
            @Param("userId") String userId,
            @Param("startDate") LocalDate startDate);

    @Query("SELECT * FROM logs WHERE inter = 'view' AND service = :service ALLOW FILTERING")
    List<Log> findViewLogsByService(@Param("service") String service);

    @Query("SELECT * FROM logs WHERE inter = 'cart' AND service IN :services ALLOW FILTERING")
    List<Log> findCartLogsByService(@Param("services") List<String> services);

    @Query("SELECT * FROM logs WHERE inter = 'order' AND service IN :services ALLOW FILTERING")
    List<Log> findOrderLogsByService(@Param("services") List<String> services);

    @Query("SELECT user_id, item_id, item_name, date FROM logs WHERE inter = 'order' AND service IN :services ALLOW FILTERING")
    List<Log> findOrdersByPlatform(@Param("services") List<String> services);


}