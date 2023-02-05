import { createApp } from 'vue'
import App from './App.vue'
import store from './store'

import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import elementIcon from "./plugins/icons";
// import  { FormInstance, FormRules } from 'element-plus'
// app.use(FormInstance)
// app.use(FormRules)
// import axios from "axios";

const app = createApp(App);
// app.config.globalProperties.$axios = axios

app.use(store)
app.use(ElementPlus)
app.use(elementIcon)
app.mount('#app')
