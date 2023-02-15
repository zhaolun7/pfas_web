<template id="detail">
<div style="padding-left: 2%; padding-right: 2%;">
  <h3 style="text-align:center;">Query Task</h3>

  <el-select v-model="currentTask" value-key="id" class="m-2" placeholder="Select" @change="changeSelect">
    <el-option
      v-for="item in history_tasks"
      :key=item.id
      :label=item.task_name
      :value=item
    />
  </el-select>


  <el-link 
    v-if="result.msg === 'succ'"
    :href="result.url" 
    type="success" 
    icon="Download"  
    style="margin-left:10px"
  >
    Download
  </el-link>
  <div v-if="details.length > 0">

    <div v-for="subtask in details" :key="subtask">
      <br/>
      <el-tag 
        style="border:0;" 
        effect="plain"
        type="success"
      >{{subtask.name}}</el-tag><br/>
      <el-progress 
        :percentage=parseInt((100/6*subtask.step).toFixed(0))
        :text-inside="true"
        :stroke-width="20"

        :status="subtask.status>0?'exception':'success'"
        />
    </div>

  </div>
</div>
</template>

<script>
/*
step:
0 scheduled,
1 verifying,
2 read data
3 filter with blank
4 filter with intensitys
5 group analyse
6 sucess

status: 0 normal 1 error
*/
import * as api from '../api/index'
import {ElMessage} from 'element-plus';
import {mapGetters} from "vuex";
// import { Download } from '@element-plus/icons-vue';
export default {
  name: 'detail',
  methods: {
    urlencode (str) {
      str = (str + '').toString();
      return encodeURIComponent(str).replace(/!/g, '%21').replace(/'/g, '%27').replace(/\(/g, '%28'). replace(/\)/g, '%29').replace(/\*/g, '%2A').replace(/%20/g, '+');
    },
    changeSelect(item) {
      this.timerFlag = true;
      // console.log("item.id:",item.id);
      api.default.getTaskFiles(item.id).then(res=>{
        if(res.data.code === 0 && res.data.msg == "succ") {

          // this.details = res.data.task.details;
          // we want to update details, not to replace it directly to avoid flashing.
          if(this.details.length != res.data.task.details.length) {
            this.details = res.data.task.details;
            this.result = res.data.task.result;
          } else {
            for(let idx in this.details) {
              if(this.details[idx].name !== res.data.task.details[idx].name) {
                this.details[idx].name = res.data.task.details[idx].name
              }
              this.details[idx].step = res.data.task.details[idx].step
              this.details[idx].status = res.data.task.details[idx].status
            }
            if(res.data.task.result ) {
              if(this.result.msg != res.data.task.result.msg || this.result.file != res.data.task.result.file) {
                this.result.msg = res.data.task.result.msg
                this.result.file = res.data.task.result.file
              }
              if(this.result.msg === 'succ') {
                this.timerFlag = false;
                  let url = api.default.getResultFileURL(this.result.file);
                  if(this.result.url !== url) {
                    this.result.url = url;
                  }
              } else {
                this.result.url = undefined;
              }
            } else {
              this.result = {}
            }
          }
        } else {
          ElMessage.error('query task failed')
        }
      });
    },
    loadRecentTasks(newTaskID) {
      api.default.getLastTasks(10).then(res=>{
        if(res.data.code === 0 && res.data.msg === "succ") {
          this.history_tasks = res.data.tasks
          if(newTaskID) {
            for(let task of this.history_tasks) {
              if(newTaskID === task.task_id) {
                this.currentTask = task;
                this.changeSelect(this.currentTask);
                break;
              }
            }
          } else if(this.history_tasks.length > 0){
            this.currentTask = this.history_tasks[0];
            this.changeSelect(this.currentTask);
          }
        }
      });
    },
    updateDetails() {
      if(this.currentTask.id.length > 0) {
        this.changeSelect(this.currentTask);
        // console.log("update....")
      }
    }
  },
  computed:{
    ...mapGetters(["getTaskID"])
  },
  watch: {
    getTaskID : function(newTaskID) {
      this.loadRecentTasks(newTaskID)
    }
  },
  mounted() {
    this.loadRecentTasks()

    this.timer = setInterval(() => {
      if(this.timerFlag) {
        setTimeout(this.updateDetails, 0)
      }
       
   }, 1000*3)
  },
  data(){
    return {
      history_tasks: [],
      currentTask: {"id":"","task_name":"example"},
      details: [],
      result:{},
      timer: null,
      timerFlag: true,
    }
  }
}

</script>
