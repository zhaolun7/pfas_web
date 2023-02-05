<template id="detail">
<div>
  <h3 style="text-align:center;">Query Task</h3>

  <span>Task id:{{ task.taskID }}</span><br/>
  <span>Task name:{{ task.taskName }}</span>
  <div v-for="subtask in task.details" :key="subtask">
    <br/>
    <el-tag 
      style="border:0;" 
      effect="plain"
      type="success"
    >{{subtask.name}}</el-tag><br/>
    <el-progress 
      :percentage="(100/6*subtask.step).toFixed(0)"
      :text-inside="true"
      :stroke-width="20"

      :status="subtask.status>0?'exception':'success'"
      />
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
export default {
  name: 'detail',
  data(){
    return {
      task: {
        taskID:"testID1111",
        taskName: "testName111",
        details: [
          {
            name:"file0.xlsx", 
            step: 0,
            status: 0
          },
          {
            name:"file1.xlsx", 
            step: 1,
            status: 0
          },
          {
            name:"file2.xlsx", 
            step: 2,
            status: 0
          },
          {
            name:"file3.xlsx", 
            step: 6,
            status: 0
          },
          {
            name:"file4.xlsx", 
            step: 5,
            status: 1
          },
        ]
      }
    }
  }
}


</script>


<style scoped>



</style>
