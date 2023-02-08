import { createApp } from 'vue'
import App from './App.vue'
import {store,key} from './store'
// import axios from "axios"
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import elementIcon from "./plugins/icons";
// import  { FormInstance, FormRules } from 'element-plus'
// app.use(FormInstance)
// app.use(FormRules)

const app = createApp(App);
// app.config.globalProperties.$axios = axios
// app.use(axios)
app.use(store, key)
app.use(ElementPlus)
app.use(elementIcon)
app.mount('#app')
