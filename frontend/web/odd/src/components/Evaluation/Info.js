import { useState, useEffect } from "react";
import { fetchUserInfo } from "../../apis/Evaluation/InfoApi"; // API 호출 함수 가져오기
import useUserStore from "../../stores/userStore";
import "../../components/Evaluation/Info.css";
import "../../pages/Dashboard/Evaluation.css";
import "../../components/Dashboard/Loading.css";

import nameIcon from "../../assets/images/name.png";
import ageIcon from "../../assets/images/age.png";
import genderIcon from "../../assets/images/gender.png";

const Info = () => {
  const [userInfo, setUserInfo] = useState(null);
  const [loading, setLoading] = useState(true); // 로딩 상태 추가
  const { userId } = useUserStore();

  useEffect(() => {
    if (!userId) {
      console.error("userId가 설정되지 않았습니다.");
      setLoading(false);
      return;
    }

    const fetchData = async () => {
      try {
        const data = await fetchUserInfo(userId); // API 호출
        if (data) {
          setUserInfo(data);
        } else {
          console.error("데이터를 불러올 수 없습니다.");
        }
      } catch (error) {
        console.error("API 호출 에러:", error);
      } finally {
        setLoading(false); // 로딩 상태 종료
      }
    };

    fetchData();
  }, [userId]);

  if (loading) {
    return (
      <div className="loading-container">
        <div className="loading-spinner"></div>
      </div>
    );
  }

  if (!userInfo) {
    return <div>데이터를 불러오지 못했습니다.</div>; // 에러 상태 표시
  }

  return (
    <div className="info-content">
      <div className="info-item">
        <img src={nameIcon} alt="이름 아이콘" className="icon" />
        <div className="info-text">
          <span>닉네임</span>
          <span>{userInfo.nickname}</span>
        </div>
      </div>
      <div className="info-item">
        <img src={ageIcon} alt="나이 아이콘" className="icon" />
        <div className="info-text">
          <span>나이</span>
          <span>{userInfo.age}세</span>
        </div>
      </div>
      <div className="info-item">
        <img src={genderIcon} alt="성별 아이콘" className="icon" />
        <div className="info-text">
          <span>성별</span>
          <span>{userInfo.gender === "F" ? "여자" : "남자"}</span>
        </div>
      </div>
    </div>
  );
};

export default Info;
