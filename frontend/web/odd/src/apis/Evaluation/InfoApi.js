import axios from "axios";

const baseUrl = process.env.REACT_APP_BASE_URL;

// 기본정보 받아오기 (GET)
export const fetchUserInfo = async (userId) => {
  try {
    // baseUrl과 API 경로 결합
    const response = await axios.get(`${baseUrl}/evaluation/${userId}`);
    console.log("사용자 정보 받아오기 성공! ! :", response.data);
    return response.data;
  } catch (error) {
    console.error("사용자 정보 받아오기 실패 :", error);
    return null;
  }
};
