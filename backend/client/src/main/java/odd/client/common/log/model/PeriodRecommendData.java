package odd.client.common.log.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.data.cassandra.core.cql.PrimaryKeyType;
import org.springframework.data.cassandra.core.mapping.Column;
import org.springframework.data.cassandra.core.mapping.PrimaryKeyColumn;
import org.springframework.data.cassandra.core.mapping.Table;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Table("period_recommend_data")
public class PeriodRecommendData {
    @PrimaryKeyColumn(name = "order_id", type = PrimaryKeyType.PARTITIONED)
    private String orderId;

    @PrimaryKeyColumn(name = "user_id", type = PrimaryKeyType.CLUSTERED)
    private String userId;

    @PrimaryKeyColumn(name = "event_time", type = PrimaryKeyType.CLUSTERED)
    private LocalDateTime eventTime;

    @Column("id")
    private UUID id;

    @Column("date")
    private LocalDate date;

    @Column("service")
    private String service;

    @Column("item_id")
    private String itemId;

    @Column("item_name")
    private String itemName;

    @Column("inter")
    private String inter;
}
