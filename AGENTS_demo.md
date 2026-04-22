# AGENTS.md - AI 智能体开发指南

本文档为在 km-horde 代码库上工作的 AI 智能体提供必要的信息。

## 项目概述

- **语言**: Go 1.22
- **模块**: `<your-module-path>`
- **服务**: web、admin、web、rpc 服务，异步任务，定时任务
- **核心组件**: router、cron、starter（可执行文件）

## 构建命令

```bash
# 构建所有可执行文件
make all

# 构建单个可执行文件
make router   # 消息路由服务
make cron     # 定时任务服务
make starter  # 启动器服务

# 运行测试并生成覆盖率报告
go test -coverprofile=coverage.out ./pkg/...
# 或者: make test

# 运行代码检查
golangci-lint run ./pkg/... --verbose
# 或者: make lint

# 生成代码（protoc、thrift、enums 等）
go generate ./pkg/...
# 或者: make gen

# 生成 thrift 代码
make thrift

# 运行单个测试
go test -v ./pkg/controller/app_tracking_callback/process_context/... -run TestCallbackProcessContext
# 或者使用 -run 参数指定任意测试路径
```

## 目录结构

```
cmd/           - 应用入口（main.go 文件）
pkg/           - 核心包
  config/      - 所有外部依赖组件配置应用包
  controller/  - 业务逻辑控制 1. 主要完成对于业务逻辑的处理以及复杂逻辑的策略处理（缓存批量等等）2. 根据业务场景抽象具体行为，作为多态实现并统一管理
  dao/         - 数据访问层
  model/       - 数据模型
  schema/      - 请求/响应结构
  errs/        - 错误定义
  consts/      - 常量
  util/        - 工具函数
  rpc/         - RPC 客户端
  service/     - thrift 协议 RPC 服务
  task/        - 异步服务
  web/         - 对外提供的 http 服务
  admin/       - 内部后台服务 http 服务
gen-go/        - 生成的 Thrift 代码
proto/         - Thrift 定义
openspec/      - OPSX 制品
bin/           - 编译后的可执行文件
```

## 代码风格指南

### 命名规范
**应尽量使用单个或者多个单词短语并充分体现功能的作用*
- **文件**: snake_case（例如 `app_tracking.go`、`check_convert.go`）
- **包**: 小写、短名称（例如 `controller`、`dao`、`model`、`errs`）, 需要使用多个单词时候 snake_case 风格
- **接口/函数/变量/接口体**: PascalCase 风格，并且根据所在包名追加响应后缀名称，比如 `MemberModel`, `LoginController`, `ReviewHandler`, `MemberDao`
- **常量**: 导出的用 PascalCase，未导出的用 camelCase
  
### 导入组织
用空行分隔导入组：
1. 标准库（`context`、`fmt`、`time` 等）
2. 来自同一模块的外部包
3. 第三方外部包

### 接口使用
- 为`controller`, `dao`, `rpc` 定义接口，包含清晰的方法签名
- 通过构造函数使用依赖注入
- 从构造函数返回具体类型，面向接口编程

示例：
```go
//  AppTrackingController 接口方法定义
type AppTrackingController interface {
    AppTrackingEventProcess(ctx context.Context, param schema.AppTrackingEventProcessSchema) (bool, bool, *schema.AppTrackingResultSchema, error)
}

// AppTrackingController 结构体实现
type AppTrackingControllerImpl struct{}

// defaultAccountDao 全局单例实现
var defaultAppTrackingController AppTrackingController

// init 初始化全局单例
func init() {
    defaultAppTrackingController = NewAppTrackingController()
}

// NewAppTrackingController 新创建实例使用
func NewAppTrackingController() AppTrackingController {
    return &AppTrackingControllerImpl{}
}

// GetAppTrackingController 外部调用全局单例使用
func GetAppTrackingController() AppTrackingController {
    return defaultAppTrackingController
}
```

- 接口方法定义
```go
// 方法注释说明其功能
// 返回值: 返回值描述
func (ctrl *XxxControllerImpl) MethodName(ctx context.Context, param schema.XxxSchema) (bool, bool, *schema.ResultSchema, error) {
    statsdPrefix := "module.process.method"
    config.StatsdClient.Increment(statsdPrefix + ".entry")
    logFields := log.Fields{"param": param}

    // ... 实现

    return success, alreadyTracked, result, nil
}
```

### 日志处理
- 必须使用 `git.in.zhihu.com/go/base/telemetry/log`
- 使用带上下文的结构化日志：
```go
log.Errorf(ctx, "[AppTrackingControllerImpl:MethodName] error: %v", err)
log.WithFields(ctx, logFields).Errorf("message: %v", err)
```
- 在复杂流程中使用 `logFields` 进行上下文日志记录：
```go
logFields := log.Fields{"param": param, "clientID": clientID}
log.WithFields(ctx, logFields).Infof(...)
```
- 日志格式：`[包名:方法名] 消息`

### 错误变量模式
```go
// 包级错误变量，用于常见错误
var (
    ErrNotFound = errors.New("not found")
    ErrInvalidParam = errors.New("invalid parameter")
)

// 错误工厂，用于参数化错误
func NewXxxError(msg string) *exception.KmHordeError {
    return &exception.KmHordeError{
        Code:    40001,
        Message: msg,
    }
}
```

### 数据库操作
- 使用 `borm`（内部 ORM）进行数据库操作
- 使用 `borm.HasRecordNotFoundError(err)` 检查记录未找到
- 通过 getter 函数使用 DAO 模式：`dao.GetXxxDao().Method()`

### 监控
- 使用 statsd 进行指标统计：
```go
config.StatsdClient.Increment("metric_name.entry")
```

### **重要** 禁止使用
- 代码中禁止使用 `panic` 处理
- 禁止裸使用 `go func` 语法，所有 goroutine 使用必须要使用 `<your-errgroup-package>` 处理

## 代码检查

项目使用 golangci-lint，包含以下检查器：
- errcheck, bodyclose, gofmt, typecheck, ineffassign, staticcheck, govet, unused

配置文件：`.golangci.yaml`

## 提交规范

使用 commitlint 配合 cz-git。提交类型：
- `Feat`: 新功能
- `Fix`: Bug 修复
- `Docs`: 文档
- `Style`: 代码格式化
- `Refactor`: 代码重构
- `Perf`: 性能优化
- `Test`: 测试相关
- `Build`: 构建系统
- `CI`: CI/CD
- `Revert`: 回滚更改
- `Chose`: 其他

作用域：admin, cron, router, web, worker, service, all

使用交互式提交：`git commit`（触发 cz-git 提示）
