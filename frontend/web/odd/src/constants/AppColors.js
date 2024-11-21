export const AppColors = {
  gsPrimary: "#02D4EC", // gs 메인
  gsSecondary: "#DBF8FC", // gs 배경
  freshPrimary: "#07E17A", // 더프레시 메인
  freshSecondary: "#CEF9E5", // 더프레시 배경
  winePrimary: "#C3155C", // 와인 메인
  wineSecondary: "#FFECF0", // 와인 배경

  notice: "#FC4249", // 알림
  accent: "#047AFB", // 포인트
  click: "#006adb", // 클릭

  background: "#F4F5FA", // 배경
  sidebar: "#D3E2FF", // 사이드바
  white: "#FFFFFF", // 화이트
  black: "#000000", // 블랙
  darkgrey: "#52555A", // 다크그레이
  grey: "#8C8C8C", // 그레이
  middlegrey: "#B2B2B2",
  lightgrey: "#ECECEC", // 라이트그레이
  navy: "#16449B", // 네이비
  darknavy: "#05004E", // 다크네이비
};

// CSS 변수로 설정하는 함수
export const setCSSVariables = () => {
  const root = document.documentElement;
  Object.keys(AppColors).forEach((key) => {
    root.style.setProperty(`--${key}`, AppColors[key]);
  });
};
