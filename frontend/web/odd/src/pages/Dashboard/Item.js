import { useState } from "react";
import Card from "../../components/Dashboard/Card";
import CardTitle from "../../components/Dashboard/CardTitle";
import ItemDropdown from "../../components/Dashboard/ItemDropdown";
import TopItem from "../../components/Item/TopItem";
import UserCount from "../../components/Item/UserCount";
import AgeGender from "../../components/Item/AgeGender";
import dashboardStore from "../../stores/dashboardStore";
import "./Item.css";
import ChartCategory from "../../components/Item/ChartCategory";

const Item = () => {
  const { selectedPlatform } = dashboardStore();
  const [selectedTopType, setSelectedTopType] = useState("조회순");

  return (
    <div className="item-container">
      {/* 첫번째 줄 */}
      <div className="item-row">
        <Card flexGrow={1} style={{ height: "300px" }}>
          <CardTitle title="재구매 사용자 수" />
          <UserCount platform={selectedPlatform} />
        </Card>
        <Card flexGrow={2} style={{ height: "300px" }}>
          <CardTitle title="성별 & 나이" />
          <AgeGender platform={selectedPlatform} />
        </Card>
        <Card flexGrow={2} style={{ height: "300px" }}>
          <div className="top-title">
            <CardTitle title="상품 리스트 TOP10" />
            <ItemDropdown
              selectedItem={selectedTopType}
              setSelectedItem={setSelectedTopType}
            />
          </div>
          <TopItem platform={selectedPlatform} type={selectedTopType} />
        </Card>
      </div>
      {/* 두번째 줄 */}
      <div className="item-row-second">
        <Card flexGrow={1}>
          <CardTitle title="카테고리" />
          <ChartCategory platform={selectedPlatform} />
        </Card>
      </div>
    </div>
  );
};

export default Item;
