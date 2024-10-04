# 使用官方 Node.js 作为构建阶段的基础镜像
FROM node:18-alpine AS build

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json（如果有）
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制项目文件到工作目录
COPY . .

# 构建生产版本
RUN npm run build

# 使用官方 Nginx 作为运行阶段的基础镜像
FROM nginx:stable-alpine

# 将构建的文件复制到 Nginx 的默认目录
COPY --from=build /app/build /usr/share/nginx/html

# 复制自定义的 Nginx 配置文件（可选）
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
