// index.js
import path from "./path"
import axios from "../utils/request"
export default {
    submitNewTask(task){
        return axios.post(path.baseUrl + path.submitNewTask, JSON.stringify(task), {headers: {'Content-Type':'application/json'}})
    },

    getLastTasks(num){
        return axios.get(path.baseUrl + path.getLastTasks + '?num=' + num)
    },
    getTaskFiles(taskID){
        return axios.get(path.baseUrl + path.getTaskFiles +'?task_id='+taskID)
    },
    
    getResultFileURL(file) {
        return path.baseUrl + path.resultFileDownload + '?file='+encodeURIComponent(file)
    },
    getUploadURL(){
        return path.baseUrl +path.fileUpload
    }
}