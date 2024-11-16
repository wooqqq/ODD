import { create } from "zustand";

const useUserStore = create((set) => ({
  userId: null,
  nickname: null,
  setUserId: (id) => set({ userId: id }),
  setNickname: (name) => set({ nickname: name }),
}));

export default useUserStore;
