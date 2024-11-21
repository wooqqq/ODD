package odd.client.common.item.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Entity
@Table(name = "item")
public class Item {

    @Id
    private String id;

    @Column(nullable = false, length = 100)
    private String bdItemNm;

    @Column(nullable = false, length = 1, name = "is_gs25_dlvy")
    private String isGs25Dlvy;

    @Column(nullable = false, length = 1, name = "is_gs25_pickup")
    private String isGs25Pickup;

    @Column(nullable = false, length = 1)
    private String isMartDlvy;

    @Column(nullable = false, length = 1)
    private String isMartPickup;

    @Column(nullable = false, length = 1)
    private String isWine25;

    @Column(nullable = false)
    private Integer price;

    @Column(nullable = false, length = 100)
    private String bdItemLclsNm;

    @Column(nullable = false)
    private Integer bdItemLclsCd;

    @Column(nullable = false, length = 100)
    private String bdItemMclsNm;

    @Column(nullable = false)
    private Integer bdItemMclsCd;

    @Column(nullable = false, length = 100)
    private String bdItemSclsNm;

    @Column(nullable = false)
    private Integer bdItemSclsCd;

    @Column(nullable = false, length = 100)
    private String bdItemDclsNm;

    @Column(nullable = false)
    private Integer bdItemDclsCd;

    @Column(length = 255)
    private String s3Url;
}
