import axios from "axios";

const BASE_URL = process.env.REACT_APP_BASE_URL;

// 연령 및 성별 재구매 사용자 데이터 조회 (GET)
export const fetchAgeGenderReorderData = async (platform) => {
  try {
    const response = await axios.get(`${BASE_URL}/dashboard/user/reorder-age`, {
      params: {
        data: "odd", // "gs" 또는 "odd"로 전달
        platform: platform,
      },
      headers: {
        accept: "*/*",
      },
    });

    console.log("연령 및 성별 데이터 조회 성공", response.data);
    return response.data;
  } catch (error) {
    console.error("연령 및 성별 데이터 조회 오류", error);
    throw error;
  }
};
