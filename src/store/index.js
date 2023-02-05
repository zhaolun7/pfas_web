import { createStore } from 'vuex'

export default createStore({
  state: {
    taskId: "",
    taskName:"(please select)",
  },
  getters: {
    getTaskId(state) {
      return state.taskId
    },
    getTaskName(state) {
      return state.taskName
    },
  },
  mutations: {
    setTaskId(state, newTaskId) {
      state.taskId = newTaskId;
    },
    setTaskName(state, newName){
      state.taskName = newName;
    },
  },
  actions: {
  },
  modules: {
  }
})
