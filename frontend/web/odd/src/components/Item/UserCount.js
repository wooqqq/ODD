import React, { useEffect, useState } from "react";
import { fetchReorderUserData } from "../../apis/Item/UserCountApi";
import oneIcon from "../../assets/images/one.png";
import threeIcon from "../../assets/images/three.png";
import percentIcon from "../../assets/images/percent.png";
import "./UserCount.css";

const UserCount = ({ platform }) => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchData = async () => {
      try {
        const result = await fetchReorderUserData(platform);
        setData(result);
        setError("");
      } catch (error) {
        console.error("데이터 가져오기 실패:", error);
        setError("데이터를 불러오는 데 실패했습니다.");
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [platform]);

  if (loading) {
    return <div>로딩 중...</div>;
  }

  if (error) {
    return <div>{error}</div>;
  }

  if (!data) {
    return <div>데이터가 없습니다.</div>;
  }

  return (
    <div className="user-count-content">
      <div className="user-count-item">
        <img src={oneIcon} alt="회원 아이콘" className="icon-user" />
        <div className="user-count-text">
          <span>1회 이상 구매 회원수</span>
          <span>{data.first.toLocaleString()} 명</span>
        </div>
      </div>
      <div className="user-count-item">
        <img src={threeIcon} alt="재구매 아이콘" className="icon-user" />
        <div className="user-count-text">
          <span>3회 이상 구매 회원수</span>
          <span>{data.secondOrMore.toLocaleString()} 명</span>
        </div>
      </div>
      <div className="user-count-item">
        <img src={percentIcon} alt="비율 아이콘" className="icon-user" />
        <div className="user-count-text">
          <span>비율 (3회 / 1회)</span>
          <span>{data.reorderRatio} %</span>
        </div>
      </div>
    </div>
  );
};

export default UserCount;
