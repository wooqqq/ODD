package odd.client.common.search.model;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.CompletionField;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.core.suggest.Completion;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(indexName = "items")
public class ElasticsearchItem {

    @Id
    private String id;
    private String bdItemNm; // 상품명
    @CompletionField(maxInputLength = 100)
    private Completion itemNmSuggest; // 검색어 추천용 필드
    private String isGs25Div;
    private String isGs25Pickup;
    private String isMartDiv;
    private String isMartPickup;
    private String isWine25;
    private Integer price;
    private String bdItemLclsNm;
    private Integer bdItemLclsCd;
    private String bdItemMclsNm;
    private Integer bdItemMclsCd;
    private String bdItemSclsNm;
    private Integer bdItemSclsCd;
    private String bdItemDclsNm;
    private Integer bdItemDclsCd;
    private String s3Url;
}

