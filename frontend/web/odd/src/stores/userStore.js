import { create } from "zustand";

const useUserStore = create((set) => ({
  userId: null,
  nickname: null,
  email: null,
  setUserId: (id) => set({ userId: id }),
  setNickname: (name) => set({ nickname: name }),
  setEmail: (email) => set({ email: email }),
}));

export default useUserStore;
