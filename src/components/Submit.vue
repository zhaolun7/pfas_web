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
        <el-input v-model="ruleForm.TASK_NAME"/>
      </el-form-item>
      <el-form-item label="Email"  prop="EMAIL">
        <el-input v-model="ruleForm.EMAIL"/>
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
        action="http:///" 
        multiple
        style="width: 100%"
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
        <el-button type="primary" @click="" style="margin-left: 10%;">Reset</el-button>
    </el-form-item>

  </el-form>

</div>
</template>

<script lang="ts" setup>
import { reactive, ref , nextTick} from 'vue'
import type { FormInstance, FormRules, ElInput, ElMessage, ElMessageBox, UploadUserFile, UploadProps} from 'element-plus'
import { UploadFilled } from '@element-plus/icons-vue'

const fileList = ref<UploadUserFile[]>([]);
// const handleRemove: UploadProps['onRemove'] = (file, uploadFiles) => {
//   console.log(file, uploadFiles)
// }

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
}

const submitForm = async (formEl: FormInstance | undefined)=>{
  if(!formEl) return
  await formEl.validate((valid, fields) => {
    if(valid) {
      if(fileList.value.length === 0) {
        console.log('we need one file uploaded at least.')
        console.log('won\'t submit!')
        reminderFile.value = true;
      } else {
        console.log('submit!!!')
      }
      
    } else {
      console.log('error submit!', fields)
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
