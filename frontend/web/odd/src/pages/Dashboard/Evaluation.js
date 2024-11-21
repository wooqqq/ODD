import useUserStore from "../../stores/userStore";
import "./Evaluation.css";
import Card from "../../components/Dashboard/Card";
import CardTitle from "../../components/Dashboard/CardTitle";
import Info from "../../components/Evaluation/Info";
import PurchaseLog from "../../components/Evaluation/PurchaseLog";
import OtherLog from "../../components/Evaluation/OtherLog";
import RecommendCategory from "../../components/Evaluation/RecommendCategory";
import RecommendPeriod from "../../components/Evaluation/RecommendPeriod";
import RecommendTime from "../../components/Evaluation/RecommendTime";
import ChartVisit from "../../components/Evaluation/ChartVisit";
import ChartCartOrder from "../../components/Evaluation/ChartCartOrder";

const Evaluation = () => {
  const userId = useUserStore((state) => state.userId);
  const nickname = useUserStore((state) => state.nickname);

  // userId가 없을 때 메시지 반환
  if (!userId) {
    return (
      <div className="evaluation-container">
        <p>회원 이메일을 검색해주세요</p>
      </div>
    );
  }

  // userId가 있을 때 화면 구성
  return (
    <div className="evaluation-container">
      {/* 첫 번째 줄 */}
      <div className="evaluation-row">
        <Card flexGrow={1}>
          <CardTitle title="기본 정보" />
          <Info />
        </Card>
        <Card flexGrow={2}>
          <CardTitle title="플랫폼별 상품 조회수" />
          <ChartVisit />
        </Card>
        <Card flexGrow={3}>
          <CardTitle title="플랫폼별 장바구니수 / 구매수" />
          <ChartCartOrder />
        </Card>
      </div>

      {/* 두 번째 줄 */}
      <div className="evaluation-row">
        <div className="evaluation-col">
          <Card flexGrow={1}>
            <CardTitle
              title={`${nickname}님에게 맞는 시간대 추천 상품 (GS25)`}
            />
            <RecommendTime userId={userId} />
          </Card>
          <Card flexGrow={1}>
            <CardTitle
              title={`${nickname}님에게 맞는 주기 추천 상품 (GS더프레쉬)`}
            />
            <RecommendPeriod userId={userId} />
          </Card>
        </div>
        <Card flexGrow={1}>
          <CardTitle title={`${nickname}님에게 맞는 카테고리 추천 상품`} />
          <RecommendCategory userId={userId} />
        </Card>
      </div>

      {/* 세 번째 줄 */}
      <div className="evaluation-row">
        <Card flexGrow={1}>
          <CardTitle title="구매 상품 리스트" />
          <PurchaseLog />
        </Card>
        <Card flexGrow={1}>
          <CardTitle title="로그 기록" />
          <OtherLog />
        </Card>
      </div>
    </div>
  );
};

export default Evaluation;
