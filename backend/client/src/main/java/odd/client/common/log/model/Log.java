package odd.client.common.log.model;

import java.time.LocalDate;
import java.time.LocalTime;
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
@Table("logs")
public class Log {
    @PrimaryKeyColumn(name = "date", ordinal = 0, type = PrimaryKeyType.PARTITIONED)
    private LocalDate date;

    @PrimaryKeyColumn(name = "event_time", ordinal = 1, type = PrimaryKeyType.CLUSTERED)
    private LocalTime eventTime;

    @Column("service")
    private String service;

    @Column("order_id")
    private String orderId;

    @Column("user_id")
    private String userId;

    @Column("item_id")
    private String itemId;

    @Column("item_name")
    private String itemName;

    @Column("inter")
    private String inter;
}