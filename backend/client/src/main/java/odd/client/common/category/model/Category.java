package odd.client.common.category.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "category")
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 1)
    private String isGs25;

    @Column(nullable = false, length = 1)
    private String isMart;

    @Column(nullable = false, length = 1)
    private String isWine25;

    @Column(nullable = false)
    private Integer bdItemLclsCd;

    @Column(nullable = false, length = 100)
    private String bdItemLclsNm;

    @Column
    private Integer bdItemMclsCd;

    @Column(length = 100)
    private String bdItemMclsNm;

    @Column
    private Integer bdItemSclsCd;

    @Column(length = 100)
    private String bdItemSclsNm;

    @Column
    private Integer bdItemDclsCd;

    @Column(length = 100)
    private String bdItemDclsNm;

    @Column(length = 255)
    private String s3Url;
}
