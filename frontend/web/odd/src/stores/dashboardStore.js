import { create } from "zustand";

const dashboardStore = create((set) => ({
  selectedMenu: "대시보드",
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
