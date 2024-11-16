import { create } from "zustand";

const useUserStore = create((set) => ({
  userId: null, // 초기 userId 상태
  setUserId: (id) => set({ userId: id }), // userId 업데이트 함수
}));

export default useUserStore;
