import { create } from "zustand";
import { persist } from "zustand/middleware";

const useAdminStore = create(
  persist(
    (set) => ({
      isLogin: false, // 초기 로그인 상태
      setLogin: () => set({ isLogin: true }), // 로그인
      setLogout: () => set({ isLogin: false }), // 로그아웃
      resetState: () => {
        set({ isLogin: false });
        localStorage.removeItem("admin-store");
      }, // 상태 초기화
    }),
    {
      // 로컬에 저장
      name: "admin-store",
      getStorage: () => localStorage,
    }
  )
);

export default useAdminStore;
