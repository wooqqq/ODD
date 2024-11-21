// 구매 로그 출력
export const fetchPurchaseLogs = async (userId, platform) => {
  const baseURL = process.env.REACT_APP_BASE_URL;
  const url = `${baseURL}/evaluation/purchase/${userId}/${platform}`;
  console.log(`상품구매로그 요청 URL: ${url}`);

  try {
    const response = await fetch(url);
    console.log(`상품구매로그 응답 상태 코드: ${response.status}`);

    if (!response.ok) {
      console.error("API 응답 실패:", response.statusText);
      throw new Error("상품 구매 로그 가져오기 실패");
    }

    const data = await response.json();
    console.log("상품구매로그 응답 데이터:", data);

    return data || [];
  } catch (error) {
    console.error("상품구매로그 호출 중 오류 발생:", error.message);
    throw error;
  }
};

// 로그 출력
export const fetchOtherLogs = async (userId, platform) => {
  const baseURL = process.env.REACT_APP_BASE_URL;
  const url = `${baseURL}/evaluation/log/${userId}/${platform}`;
  console.log(`other로그 요청 URL: ${url}`);

  try {
    const response = await fetch(url);
    console.log(`other로그 응답 상태 코드: ${response.status}`);

    if (!response.ok) {
      console.error("API 응답 실패:", response.statusText);
      throw new Error("other로그 가져오기 실패");
    }

    const data = await response.json();
    console.log("other로그 응답 데이터:", data);

    return data || [];
  } catch (error) {
    console.error("other로그 호출 중 오류 발생:", error.message);
    throw error;
  }
};
