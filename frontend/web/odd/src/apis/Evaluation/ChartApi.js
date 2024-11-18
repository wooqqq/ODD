import axios from "axios";

const baseUrl = process.env.REACT_APP_BASE_URL;

// 플랫폼 통계 데이터 (GET)
export const fetchPlatformStats = async (userId) => {
  try {
    const response = await axios.get(
      `${baseUrl}/evaluation/${userId}/platform-stats`
    );
    console.log("플랫폼 통계 데이터 받아오기 성공:", response.data);
    return response.data;
  } catch (error) {
    console.error("플랫폼 통계 데이터 받아오기 실패:", error);
    return null;
  }
};
