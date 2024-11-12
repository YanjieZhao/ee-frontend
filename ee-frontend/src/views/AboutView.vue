

<style>
@media (min-width: 1024px) {
  .about {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
  }
}
</style>

<script setup lang="ts">
import  axios from 'axios'
import type { AxiosResponse } from 'axios';
import { ref, onMounted } from 'vue';
import instance from '@/request'; // 引入配置好的 Axios 实例
import { nextTick } from 'vue';

const selectedFile = ref<File | null>(null);
const message = ref<string>('');

// 处理文件选择事件
const onFileChange = (event: Event, row: any) => {
  const target = event.target as HTMLInputElement;
  if (target.files && target.files[0]) {
    selectedFile.value = target.files[0];
  }
};

// 上传文件函数
const uploadFile = async () => {
  if (!selectedFile.value) return;

  const formData = new FormData();
  formData.append('file', selectedFile.value);

  try {
    const response = await instance.post('/homework/upload', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    });
    //message.value = response.message;
  } catch (error) {
    message.value = 'File upload failed';
    console.error(error);
  }
};

const homeworks = ref<any[]>([]); // 定义作业数据的类型

const updateCompleted = async (id: number, isCompleted: number) => {
  try {
    await instance.get(`/homework/1/${id}/toggle`);
  } catch (error) {
    console.error('Error updating homework:', error);
  }
};

const fetchHomeworks = async () => {
  try {
    const response: any[] = await instance.get('/homework/0'); // 请求代理地址
    console.log(response)
    homeworks.value = response;
    console.log(homeworks.value)
    await nextTick();
  } catch (error) {
    console.error('Error fetching homework:', error);
  }
};

onMounted(fetchHomeworks); // 组件挂载时调用获取作业函数

const toLogin = () => {
  console.log('test')
  axios.get('/api/data?id=0&date=2021-10-10').then(res => {
    console.log(res.data)
  })
}


//添加作业，作业的列分别为subject, userid, date, title, desc, isFinished


//添加作业
const addHomework = () => {
  axios.post('/homework', {
    "title": "Math Homework",
    "time": "2024-10-26T10:00:00Z",
    "description": "Complete exercises 1-10 on page 23",
    "subject": "Math",
    "isCompleted": false,
    "userId": 1,
    "duration": 60,
    "quality": 80
  }).then(res => {
    console.log(res.data)
  })
}

//根据id查询作业
const getHomework = async () => {
  try {
    const response = await instance.get('/homework/0'); // 请求代理地址
    //homeworks.value = response.data;
    //console.log(homeworks.value.value)
  } catch (error) {
    console.error('Error fetching homework:', error);
  }
}

const update = () => {
  axios.post('/api/update', {
    id: 7
  }).then(res => {
    console.log(res.data)
  })
}

const triggerFileInput = (id: number) => {
  const fileInput = document.getElementById(`file-input-${id}`) as HTMLInputElement;
  if (fileInput) {
    fileInput.click();
  }
};

const handleCheckboxChange = (row : any, checked: Boolean) => {
      // 根据是否勾选更新为 1 或 0
      row.isCompleted = checked ? 1 : 0;

      console.log(`Item with ID ${row.id} is now ${row.isCompleted ? 'completed' : 'not completed'}`);
      // 可以在这里调用 API 更新服务器数据
      updateCompleted(row.id, row.isCompleted);
    };

</script>

<template>
  <div class="about">

    <el-table :data="homeworks">
      <el-table-column prop="title" label="Title" width="180"></el-table-column>
      <el-table-column prop="description" label="Description" width="300"></el-table-column>
      <el-table-column prop="subject" label="Subject" width="120"></el-table-column>
      <el-table-column
        prop="time"
        label="Time"
        width="180"
        
      ></el-table-column>
      <el-table-column label="Completed" width="100">
        <template #default="{ row }">
          <el-checkbox
            :model-value="row.isCompleted === 1"
            @change="(checked: Boolean) => handleCheckboxChange(row, checked)"
          ></el-checkbox>
        </template>
      </el-table-column>
      <el-table-column label="Upload Photo" width="200">
        <template #default="{ row }">
          <input
            type="file"
            accept="image/*"
            @change="onFileChange($event, row)"
            style="display: none"
            :id="'file-input-' + row.id"
          />
          <button @click="triggerFileInput(row.id)">Choose File</button>
        </template>
      </el-table-column>
    </el-table>
    <div>
    
    <button @click="uploadFile" :disabled="!selectedFile">Upload</button>
    <p v-if="message">{{ message }}</p>
  </div>
  </div>
</template>