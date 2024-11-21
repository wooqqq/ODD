import axios from "axios";

const BASE_URL = process.env.REACT_APP_BASE_URL;

// 조회
export const TopView = async (platform) => {
  try {
    const response = await axios.get(`${BASE_URL}/dashboard/item/top-views`, {
      params: {
        data: "odd",
        platform: platform,
        category: "전체",
      },
    });

    console.log("조회 높은 상품 10개 성공", response.data);
    return response.data;
  } catch (e) {
    console.error("조회 높은 상품 10개 오류", e);
    throw e;
  }
};

// 구매
export const TopPurchase = async (platform) => {
  try {
    const response = await axios.get(
      `${BASE_URL}/dashboard/item/top-purchase`,
      {
        params: {
          data: "odd",
          platform: platform,
          category: "전체",
        },
      }
    );

    console.log("구매 높은 상품 10개 성공", response.data);
    return response.data;
  } catch (e) {
    console.error("구매 높은 상품 10개 오류", e);
    throw e;
  }
};

// 재구매
export const TopRePurchase = async (platform) => {
  try {
    const response = await axios.get(
      `${BASE_URL}/dashboard/item/top-repurchase`,
      {
        params: {
          data: "odd",
          platform: platform,
          category: "전체",
        },
      }
    );

    console.log("재구매 높은 상품 10개 성공", response.data);
    return response.data;
  } catch (e) {
    console.error("재구매 높은 상품 10개 오류", e);
    throw e;
  }
};

// 장바구니
export const TopCart = async (platform) => {
  try {
    const response = await axios.get(`${BASE_URL}/dashboard/item/top-cart`, {
      params: {
        data: "odd",
        platform: platform,
        category: "전체",
      },
    });

    console.log("장바구니 높은 상품 10개 성공", response.data);
    return response.data;
  } catch (e) {
    console.error("장바구니 높은 상품 10개 오류", e);
    throw e;
  }
};
