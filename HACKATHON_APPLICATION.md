# PaletteGuard 项目任务报告书

## 基本信息

- 项目名称：PaletteGuard
- 项目简介：MoonBit 原生调色板无障碍对比度检查库
- 参赛者：丁健
- 联系方式：16655175824 / 2676247321@qq.com
- GitHub 仓库链接：https://github.com/Jay7724/paletteguard
- Mooncakes 包名：Jay7724/paletteguard
- 项目方向：MoonBit 原生开源库、开发工具、CI 质量检查组件
- 是否为移植项目：否，原创 MoonBit 开源项目
- 开源许可证：MIT

## 项目简介

PaletteGuard 是一个使用 MoonBit 实现的调色板无障碍审计库，用于检查
设计系统、文档站、终端主题、图表主题或 WebAssembly 应用中的颜色组合
是否满足 WCAG 对比度要求。项目提供颜色 token 解析、前景/背景角色建模、
AA/AAA 对比度策略检查、审计结果分级、修复建议和 Markdown 报告导出能力。

该项目解决的问题是：颜色配置通常分散在设计 token、主题代码或文档中，
人工 review 容易遗漏低对比度组合。PaletteGuard 将对比度检查沉淀为
可复用的 MoonBit 库能力，可以被单元测试、CLI 示例、CI 流程和后续
文件格式适配器共同复用。

## 适用场景

- MoonBit UI、图表、文档或 Wasm 项目中的主题色验收。
- 设计系统发布前的颜色 token 对比度检查。
- README、发布记录、Pull Request 中生成可追踪的 Markdown 审计报告。
- 作为后续 JSON/TOML/Markdown 设计 token 解析工具的核心算法库。

## 核心功能

- RGB 颜色模型：使用 8 位通道表示颜色，并提供标准十六进制导出。
- 颜色解析：支持 `#RGB`、`#RRGGBB`、`rgb(r, g, b)` 和常用命名色。
- 角色建模：区分 text、accent、background、surface、border 等色板角色。
- WCAG 算法：实现相对亮度和对比度计算，支持 AA/AAA、普通文本/大文本阈值。
- 审计报告：自动检查前景色与背景色组合，输出 pass/fail、等级和修复建议。
- 示例工程：提供 `moon run cmd/main` 可直接运行的最小示例。
- 工程保障：提供测试、README、CI、设计说明、测试记录、发布说明和许可证文件。

## 当前完成情况

项目已完成 MoonBit 包配置、核心源码、黑盒测试、白盒测试、可运行示例、
GitHub Actions CI、README、MIT License、API 文档、设计说明、调研记录、
测试记录、变更日志和 Mooncakes 发布说明。代码仓库本地已有超过 5 个有效提交，
开发过程可以通过 Git 记录追踪。

本地已验证命令：

```bash
moon check
moon build
moon test
moon run cmd/main
moon package
```

测试覆盖了正常输入、错误输入、边界情况、数据结构转换、核心对比度算法、
报告导出和示例运行路径。当前测试结果为：

```text
Total tests: 9, passed: 9, failed: 0.
```

## 原创与开源合规说明

PaletteGuard 为原创 MoonBit 实现，不移植第三方项目源码，不包含来源不明
的图片、音频、字体、私有代码或测试数据。项目使用公开的 WCAG 对比度公式
作为标准算法依据，代码和文档以 MIT 许可证开源。

## 发布状态与后续事项

项目已完成 Mooncakes 发布前配置和本地打包检查。由于正式发布需要参赛者
自己的 Mooncakes 登录凭据，后续需要由参赛者执行：

```bash
moon login
moon publish --dry-run
moon publish
```

当前 `moon.mod` 已使用 GitHub 仓库地址 `https://github.com/Jay7724/paletteguard.git`
和 Mooncakes 包名 `Jay7724/paletteguard`。如果 Mooncakes 登录后显示的 owner
与 `Jay7724` 不一致，需要先同步修改 `moon.mod`、README 和本文档。正式发布后，
应在报告中补充：

- GitHub 仓库链接
- Mooncakes 文档地址
- Mooncakes manifest 地址
- CI 通过记录
