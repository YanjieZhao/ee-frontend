#!/bin/bash

# 检查输入的源文件夹和目标文件夹
if [ "$#" -ne 2 ]; then
    echo "用法: $0 <源文件夹路径> <目标文件夹路径>"
    exit 1
fi

SOURCE_FOLDER=$1
TARGET_FOLDER=$2

# 1. 进入源文件夹
echo "进入源文件夹: $SOURCE_FOLDER"
cd "$SOURCE_FOLDER" || { echo "无法进入源文件夹: $SOURCE_FOLDER"; exit 1; }

# 2. 执行 yarn build
echo "正在执行 yarn build..."
yarn build || { echo "yarn build 失败"; exit 1; }

# 3. 将 dist 文件夹拷贝到目标文件夹
echo "拷贝 dist 文件夹到目标文件夹: $TARGET_FOLDER"
rm -rf "$TARGET_FOLDER/dist"
cp -r dist "$TARGET_FOLDER/" || { echo "拷贝 dist 文件夹失败"; exit 1; }

# 4. 进入目标文件夹并执行 Git 操作
echo "进入目标文件夹: $TARGET_FOLDER"
cd "$TARGET_FOLDER" || { echo "无法进入目标文件夹: $TARGET_FOLDER"; exit 1; }

echo "执行 git add ."
git add .

echo "执行 git commit -m 'dist'"
git commit -m "dist" || { echo "git commit 失败"; exit 1; }

echo "执行 git push"
git push || { echo "git push 失败"; exit 1; }

echo "操作完成"