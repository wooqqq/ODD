import axios from "axios";

const BASE_URL = process.env.REACT_APP_BASE_URL;

// 재구매 사용자 데이터 조회 (GET)
// path 추후 수정 필요
export const fetchReorderUserData = async (platform) => {
  try {
    const response = await axios.get(`${BASE_URL}/dashboard/user/reorder`, {
      params: {
        data: "odd",
        platform: platform,
      },
      headers: {
        accept: "*/*",
      },
    });

    console.log("재구매 사용자 데이터 성공", response.data);
    return response.data;
  } catch (e) {
    console.error("재구매 사용자 데이터 오류", e);
    throw e;
  }
};
