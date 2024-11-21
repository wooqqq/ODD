import axios from "axios";

const BASE_URL = process.env.REACT_APP_BASE_URL;

// 카테고리 추천 상품 리스트
export const Category = async (userId, platform) => {
  try {
    const response = await axios.get(
      `${BASE_URL}/evaluation/fav-category/${userId}/${platform}`
    );
    console.log("카테고리 추천 요청 플랫폼", platform);
    console.log("카테고리 추천 요청 성공", response.data);
    return response.data;
  } catch (e) {
    console.log("카테고리 추천 요청 오류", e);
    throw e;
  }
};

// 시간대 추천 상품 리스트
export const Time = async (userId) => {
  try {
    const response = await axios.get(
      `${BASE_URL}/evaluation/time-rec/${userId}`
    );
    console.log("시간대 추천 요청 성공", response.data);
    return response.data;
  } catch (e) {
    console.log("시간대 추천 요청 오류", e);
    throw e;
  }
};

// 주기 추천 상품 리스트
export const Period = async (userId) => {
  try {
    const response = await axios.get(
      `${BASE_URL}/evaluation/purchase-cycle/${userId}`
    );
    console.log("주기 추천 요청 성공", response.data);
    return response.data;
  } catch (e) {
    console.log("주기 추천 요청 오류", e);
    throw e;
  }
};
