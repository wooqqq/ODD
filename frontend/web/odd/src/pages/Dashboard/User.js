import Card from "../../components/Dashboard/Card";
import CardTitle from "../../components/Dashboard/CardTitle";
import "./User.css";

const User = () => {
  return (
    <div className="user-container">
      {/* 첫번째 줄 */}
      <div className="user-row">
        <div className="user-column">
          <Card flexGrow={5}>
            <CardTitle title="사용자수" />
          </Card>
          <Card flexGrow={5}>
            <CardTitle title="재구매 사용자수" />
          </Card>
        </div>
        <Card flexGrow={4}>
          <CardTitle title="전체 회원 성별 & 나이" />
        </Card>
        <Card flexGrow={4}>
          <CardTitle title="재구매 회원 성별 & 나이" />
        </Card>
      </div>
      {/* 두번째 줄 */}
      <div className="user-row">
        <Card flexGrow={1}>
          <CardTitle title="접속 시간대 별 사용자 수" />
        </Card>
      </div>
    </div>
  );
};

export default User;
