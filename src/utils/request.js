import axios from "axios"
import qs from "querystring"


const errorHandle = (status,info) => {
    switch(status){
        case 400:
            console.log("semantic error");
            break;
        case 401:
            console.log("Server authentication failed");
            break;
        case 403:
            console.log("server denies access");
            break;
        case 404:
            console.log("wrong address");
            break;
        case 500:
            console.log("The server encountered an accident");
            break;
        case 502:
            console.log("server unresponsive");
            break;
        default:
            console.log(info);
            break;
    }
}


const instance = axios.create({
    baseURL: "",
    withCredentials: false,
    headers: {
        'Access-Control-Allow-Origin' : '*',
        'Access-Control-Allow-Methods':'GET,PUT,POST,DELETE,PATCH,OPTIONS',
    }
})

instance.interceptors.request.use(
    config =>{
        // if(config.method === "get"){
        //     config.data = qs.stringify(config.data)
        // }
        return config;
    },
    error => Promise.reject(error)
)

instance.interceptors.response.use(
    response => response.status === 200 ? Promise.resolve(response) : Promise.reject(response),
    error =>{
        const { response } = error;
        errorHandle(response.status,response.info)
    }
)

export default instance;