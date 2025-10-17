# Ki2API - Claude Sonnet 4 OpenAI兼容API

一个简单易用的Docker化OpenAI兼容API服务，专门用于Claude Sonnet 4.5模型。

## 功能特点

- 🐳 **Docker傻瓜式运行** - 一行命令启动服务
- 🔑 **固定API密钥** - 使用 `ki2api-key-2024`
- 🎯 **单一模型** - 仅支持 `claude-sonnet-4-5-20250929`
- 🌐 **OpenAI兼容** - 完全兼容OpenAI API格式
- 📡 **流式传输** - 支持SSE流式响应
- 🔄 **自动token刷新** - 支持token过期自动刷新

## 快速开始

### 零配置启动（推荐）

只需确保已登录Kiro，然后一键启动：

```bash
docker-compose up -d
```

服务将在 http://localhost:8989 启动

### 自动读取token

容器会自动读取你本地的token文件：
- **macOS/Linux**: `~/.aws/sso/cache/kiro-auth-token.json`
- **Windows**: `%USERPROFILE%\.aws\sso\cache\kiro-auth-token.json`

### 3. 测试API

#### 获取模型列表
```bash
curl -H "Authorization: Bearer ki2api-key-2024" \
     http://localhost:8989/v1/models
```

#### 非流式对话
```bash
curl -X POST http://localhost:8989/v1/chat/completions \
  -H "Authorization: Bearer ki2api-key-2024" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-sonnet-4-5-20250929",
    "messages": [
      {"role": "user", "content": "你好，请介绍一下自己"}
    ],
    "max_tokens": 1000
  }'
```

#### 流式对话
```bash
curl -X POST http://localhost:8989/v1/chat/completions \
  -H "Authorization: Bearer ki2api-key-2024" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-sonnet-4-5-20250929",
    "messages": [
      {"role": "user", "content": "写一首关于春天的诗"}
    ],
    "stream": true,
    "max_tokens": 500
  }'
```

## Docker使用方法

### 使用Docker Compose（推荐）
```bash
# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

### 使用Docker命令
```bash
# 构建镜像
docker build -t ki2api .

# 运行容器
docker run -d \
  -p 8989:8989 \
  -e KIRO_ACCESS_TOKEN=your_token \
  -e KIRO_REFRESH_TOKEN=your_refresh_token \
  --name ki2api \
  ki2api
```

## API端点

### GET /v1/models
获取可用模型列表

### POST /v1/chat/completions
创建聊天完成

### GET /health
健康检查端点

## 环境变量

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| API_KEY | ki2api-key-2024 | API访问密钥 |
| KIRO_ACCESS_TOKEN | - | Kiro访问令牌（必需） |
| KIRO_REFRESH_TOKEN | - | Kiro刷新令牌（必需） |

## 开发模式

### 本地运行
```bash
# 安装依赖
pip install -r requirements.txt

# 设置环境变量
export KIRO_ACCESS_TOKEN=your_token
export KIRO_REFRESH_TOKEN=your_refresh_token

# 启动服务
python app.py
```

## 故障排除

### 常见问题

1. **Token过期**
   - 确保refresh token有效
   - 重新获取最新的token

2. **连接失败**
   - 检查端口8989是否被占用
   - 确认Docker容器正常运行

3. **API返回401**
   - 确认使用了正确的API密钥：`ki2api-key-2024`
   - 检查token是否有效

### 查看日志
```bash
# Docker日志
docker-compose logs -f ki2api

# 本地日志
python app.py 2>&1 | tee ki2api.log
```

## 项目结构
```
ki2api/
├── app.py              # 主应用文件
├── Dockerfile          # Docker镜像定义
├── docker-compose.yml  # Docker Compose配置
├── requirements.txt    # Python依赖
└── README.md          # 本文档
```

## 许可证

MIT License

# Cherry Studio
```
提供商类型 : OPENAI
API Key  : ki2api-key-2024
API 地址  : http://127.0.0.1:8989
模型      ： claude-3-5-haiku-20241022 \ claude-sonnet-4-5-20250929
```

# Claude Code Router

```
>　idea $HOME/.claude-code-router/config.json

{
  "Providers": [
    {
      "name": "kiro",
      "api_base_url": "http://127.0.0.1:8989/v1/chat/completions",
      "api_key": "ki2api-key-2024",
      "models": [
        "claude-sonnet-4-5-20250929"
      ]
    }
  ],
  "Router": {
    "default": "kiro"
  }
}
```