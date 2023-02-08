//https://blog.csdn.net/weixin_44692055/article/details/126366697

import { InjectionKey } from "vue";
 
/**
 * 引入InjectionKey 并将其传入usestore 
 * 
 */
 
import {useStore as baseUseStore,createStore,Store} from 'vuex'
 
//为store state声明类型
export interface State {
  taskID:string
}
 
//定义 injection key
export const key:InjectionKey<Store<State>>=Symbol()
 
//导出store模块
export const store=createStore<State>({
    state:{
        taskID:'测试'
    },
    getters:{
        getTaskID:state=>{
            return state.taskID
        }
    },
    mutations: {
        SET_TaskID(state,params:string){
            state.taskID=params;
        }
    },
    actions:{}
})
 
 
export function useStore(){
    return baseUseStore(key)
}