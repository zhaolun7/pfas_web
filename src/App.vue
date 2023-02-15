<template>
    <el-container style="min-height: 600px; min-width: 800px;">
      <el-aside class="line"  style="width: 60%;"><Submit/></el-aside>
      <el-main class="line" style="padding-top: 0;"><Detail/></el-main>

    </el-container>

</template>

<script>
import Submit from './components/Submit.vue'
import Detail from './components/Detail.vue'

export default {
  name: 'App',
  components: {
    Submit,
    Detail,
  }
}
</script>

<style>
.line {
  border: 1px solid var(--el-border-color);
  padding: 0px;
  margin: 3px;
  height:97vh;
  box-shadow: var(--el-box-shadow-light);
}
</style>
