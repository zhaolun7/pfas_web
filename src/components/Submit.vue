<template id="submitTask">
<div>
  <h3 style="text-align:center;">Submit Task</h3>
  <el-form 
  inline
  ref="ruleFormRef"
  :model="ruleForm"
  :rules="rules"
  label-width="130px"
  :size="formSize"
  status-icon
  >
    <div style="width: 95%;">
      <el-form-item label="Task name"  prop="TASK_NAME">
        <el-input v-model="ruleForm.TASK_NAME" placeholder="Please input"/>
      </el-form-item>
      <el-form-item label="Email"  prop="EMAIL">
        <el-input v-model="ruleForm.EMAIL"  placeholder="example@gmail.com"/>
      </el-form-item>
    </div>
    <el-form-item label="KMD width"  prop="KMD_WIDTH">
      <el-input v-model="ruleForm.KMD_WIDTH"/>
    </el-form-item>
    <el-form-item label="m/z width"  prop="MZ_WIDTH">
      <el-input v-model="ruleForm.MZ_WIDTH"/>
    </el-form-item>
    <el-form-item label="Filter precision">
      <el-select v-model="ruleForm.PRECISION">
        <el-option label="1" value=1 />
        <el-option label="2" value=2 />
        <el-option label="3" value=3 />
        <el-option label="4" value=4 />
      </el-select>
    </el-form-item>
    <el-form-item label="Same m/z precision">
      <el-select v-model="ruleForm.PRECISION_APPEAR_IN_ALL_SAMPLES">
        <el-option label="1" value=1 />
        <el-option label="2" value=2 />
        <el-option label="3" value=3 />
        <el-option label="4" value=4 />
      </el-select>
    </el-form-item>
    <el-form-item label="Intensitys"  style="width: 95%;">
      <el-tag
        v-for="intensity in ruleForm.INTENSITY_LIST"
        :key="intensity"
        closable
        :disable-transitions="false"
        @close="handleClose(intensity)"
        
      >
      {{ intensity }}
      </el-tag>
      <el-input
        v-if="inputVisible"
        ref="InputRef"
        v-model="inputValue"
        size="small"
        class="ml-1 w-20"
        @keyup.enter="handleInputConfirm"
        @blur="handleInputConfirm"
        style="width: 80px"
      ></el-input>
      <el-button v-else class="button-new-tag ml-1" size="small" @click="showInput">
        + New Tag
      </el-button>
    </el-form-item>
    <el-form-item style="width: 95%; align-self: center;" label="Upload files">

      <el-tag v-if="reminderFile" type="danger" closeable>We need to upload at least one file</el-tag>

      <el-upload
        drag
        v-model:file-list="fileList"
        action="http://localhost:28233/upload" 
        multiple
        style="width: 100%"
        name="file"
        accept=".xlsx,.xls"
        :on-success="handleSuccess"
        >
        <el-icon class="el-icon--upload">
          <upload-filled />
        </el-icon>
        <div class="el-upload__text">
          Drop file here or <em>click to upload</em>
        </div>
        
        <template #tip>
          <div class="el-upload__tip">
            xls/xlsx files with a size less than 50mb.
          </div>
        </template>
      </el-upload>
    </el-form-item>
    <el-form-item style="width: 95%;">
        <el-button type="primary" @click="submitForm(ruleFormRef)" style="margin-left: 30%;" >Submit Task</el-button>
        <el-button type="primary" @click="resetConfig()" style="margin-left: 10%;">Reset</el-button>
    </el-form-item>

  </el-form>

</div>
</template>

<script lang="ts" setup>
import { reactive, ref , nextTick} from 'vue'

// import { Vue, Component } from 'vue-property-decorator'
// import { Getter, Action } from 'vuex-class'

import type { FormInstance, FormRules, ElInput, UploadUserFile, UploadFile, UploadFiles} from 'element-plus'
import {ElMessage} from 'element-plus';
import { UploadFilled } from '@element-plus/icons-vue'
import * as api from '../api'

import {useStore} from '../store'
const store=useStore();

// store.setters.SET_TaskID('123123');
// console.log('store.getters.getTaskID->',store.getters.getTaskID)

const fileList = ref<UploadUserFile[]>([]);

const handleSuccess = (response: any, uploadFile: UploadFile, uploadFiles: UploadFiles) => {
  // console.log(response)
  // if(response.code === '0' && response.msg === 'succ') {
  //   console.log(uploadFile)
  //   uploadFile
  //   // uploadFile.subPath = response.file;
  // }
}
// others
const formSize = ref('default')
const reminderFile = ref(false)
const ruleFormRef = ref<FormInstance>()
const checkFloat = (rule: any, value: any, callback: any) => {
  // console.log("value",value)
  if (!value) {
    return callback(new Error('Please input the value'))
  }
  let regs=/^(\d+)(\.\d+)?$/
  setTimeout(() => {
    if (!regs.test(value)) {
      callback(new Error('Input should be a float'))
    } else {
      callback()
    }
  }, 1000)
};


const submitForm = async (formEl: FormInstance | undefined)=>{
  if(!formEl) return
  await formEl.validate((valid, fields) => {
    if(valid) {
      if(fileList.value.length === 0) {
        ElMessage.warning('we need one file uploaded at least.')
        reminderFile.value = true;
      } else {
        let files = [];
        for(let idx in fileList.value) {
          let response = fileList.value[idx].response;
          let file = JSON.parse(JSON.stringify(response as object)).file
          if (file) {
            files.push(file)
          }
        }
        let task = {
          "task_name"      : ruleForm.TASK_NAME,
          "email"          : ruleForm.EMAIL,
          "intensity_list" : ruleForm.INTENSITY_LIST,
          "kmd_width"      : ruleForm.KMD_WIDTH,
          "mz_width"       : ruleForm.MZ_WIDTH,
          "precision"      : ruleForm.PRECISION,
          "precision_appear_in_all_samples": ruleForm.PRECISION_APPEAR_IN_ALL_SAMPLES,
          "files"          : files,
        }
        // console.log("fileList.value:",task)
        api.default.submitNewTask(task).then(res=>{
          if(res.data.code === 0 && res.data.msg === "succ") {
            ElMessage.success('Congrats, your submit is accepted successfully.')
            resetConfig()
            store.state.taskID = res.data.task_id
          } else {
            ElMessage.error('submit failed. return msg from server:' + res.data.msg)
          }
        })
      }
      
    } else {
      ElMessage.warning('form need to be completed.')
    }
  })
  
}

const rules = reactive<FormRules>({
  TASK_NAME: [
    { 
      required: true, 
      message: 'Please input Task name', 
      trigger: 'blur' 
    },
    {
        min: 2, 
        max: 30, 
        message: 'Length should be 2 to 30', 
        trigger: 'blur' 
    },
  ],
  EMAIL: [
    { 
      required: true, 
      message: 'Please input email address', 
      trigger: 'blur' 
    },
    { 
      type: 'email',
      trigger: 'blur' 
    },
  ],
  KMD_WIDTH: [
    {
      validator: checkFloat,
      trigger: 'blur'
    },
  ],  
  MZ_WIDTH: [
    {
      validator: checkFloat,
      trigger: 'blur'
    },
  ],
})

const taskDefaultConfig = {
      TASK_ID:"",
      EMAIL:"",
      TASK_NAME:"",
      INTENSITY_LIST: ['5000', '10000', '20000','50000','100000','200000'],
      KMD_WIDTH: 0.0095,
      MZ_WIDTH: 0.01,
      PRECISION: 2,
      PRECISION_APPEAR_IN_ALL_SAMPLES: 3,
}

const ruleForm = reactive({
      TASK_ID:"",
      EMAIL:"",
      TASK_NAME:"",
      INTENSITY_LIST: ref(['5000', '10000', '20000','50000','100000','200000']),
      KMD_WIDTH: 0.0095,
      MZ_WIDTH: 0.01,
      PRECISION: 2,
      PRECISION_APPEAR_IN_ALL_SAMPLES: 3,
})

const resetConfig = ()=>{
  ruleForm.TASK_ID = taskDefaultConfig.TASK_ID;
  ruleForm.EMAIL = taskDefaultConfig.EMAIL;
  ruleForm.TASK_NAME = taskDefaultConfig.TASK_NAME;
  ruleForm.INTENSITY_LIST.length = 0;
  for (let intensity of taskDefaultConfig.INTENSITY_LIST) {
    ruleForm.INTENSITY_LIST.push(intensity)
  }
  ruleForm.KMD_WIDTH = taskDefaultConfig.KMD_WIDTH;
  ruleForm.MZ_WIDTH = taskDefaultConfig.MZ_WIDTH;
  ruleForm.TASK_ID = taskDefaultConfig.TASK_ID;
  ruleForm.PRECISION = taskDefaultConfig.PRECISION;
  ruleForm.PRECISION_APPEAR_IN_ALL_SAMPLES = taskDefaultConfig.PRECISION_APPEAR_IN_ALL_SAMPLES;
  fileList.value.length = 0;
  
}

// for tag editable
const inputValue = ref('')
const inputVisible = ref(false)
const InputRef = ref<InstanceType<typeof ElInput>>()
const handleClose = (tag: string) => {
  ruleForm.INTENSITY_LIST.splice(ruleForm.INTENSITY_LIST.indexOf(tag), 1)
}
const showInput = () => {
  inputVisible.value = true
  nextTick(() => {
    InputRef.value!.input!.focus()
  })
}

const handleInputConfirm = () => {
  if (inputValue.value) {
    ruleForm.INTENSITY_LIST.push(inputValue.value)
  }
  inputVisible.value = false
  inputValue.value = ''
}
</script>


<style scoped>

</style>
