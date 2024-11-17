import { create } from "zustand";

const dashboardStore = create((set) => ({
  selectedMenu: "사용자 정보",
  selectedPlatform: "GS25",

  changeMenu: (menu) =>
    set((state) => ({
      selectedMenu: menu,
    })),
  changePlatform: (platform) =>
    set((state) => ({
      selectedPlatform: platform,
    })),
}));

export default dashboardStore;
