<template>
    <el-form :model="form" :rules="rules" label-width="120px">
      <!-- 科目选择 -->
      <el-form-item label="科目" prop="subject">
        <el-select v-model="form.subject" placeholder="请选择科目">
          <el-option v-for="item in subjects" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
  
      <!-- 标题输入框 -->
      <el-form-item label="标题" prop="title">
        <el-input v-model="form.title" placeholder="请输入标题" />
      </el-form-item>
  
      <!-- 作业描述输入框 -->
      <el-form-item label="作业描述" prop="description">
        <el-input v-model="form.description" type="textarea" placeholder="请输入作业描述" />
      </el-form-item>
  
      <!-- 所属用户输入框 -->
      <el-form-item label="所属用户" prop="user">
        <el-input v-model="form.user" placeholder="请输入所属用户" />
      </el-form-item>
  
      <!-- 备注输入框 -->
      <el-form-item label="备注" prop="remarks">
        <el-input v-model="form.remarks" placeholder="请输入备注" />
      </el-form-item>
  
      <!-- 确认按钮 -->
      <el-form-item>
        <el-button type="primary" @click="submitForm">确认</el-button>
      </el-form-item>
    </el-form>
  </template>
  
  <script setup lang="ts">
  import { ref } from 'vue';
  import { ElMessage } from 'element-plus';
  import axios from 'axios';
  
  // 定义科目列表
  const subjects = [
    { label: '语文', value: '语文' },
    { label: '数学', value: '数学' },
    { label: '英语', value: '英语' },
    { label: '科学', value: '科学' },
    { label: '其他', value: '其他' },
  ];
  
  // 表单数据
  const form = ref({
    subject: '',
    title: '',
    description: '',
    user: '',
    remarks: '',
  });
  
  // 表单验证规则
  const rules = {
    subject: [{ required: true, message: '请选择科目', trigger: 'change' }],
    title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
    description: [{ required: true, message: '请输入作业描述', trigger: 'blur' }],
    user: [{ required: true, message: '请输入所属用户', trigger: 'blur' }],
  };
  
  // 表单引用
  const formRef = ref(null);
  
  // 提交表单
  const submitForm = () => {
    console.log(form.value);
    axios.post('http://120.26.88.175:81/homework', {
    "title": form.value.title,
    "time": getCurrentDate(),
    "description": form.value.description,
    "subject": form.value.subject,
    "isCompleted": false,
    "userId": parseInt(form.value.user, 10),
    "duration": 60,
    "quality": 80
  }).then(res => {
    console.log(res.data)
  })
  };

  const getCurrentDate = () => {
    const date = new Date();
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
};

</script>