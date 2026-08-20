# PaletteGuard 项目申报书

## 基本信息

- 项目名称：PaletteGuard
- 参赛者：丁健
- 联系方式：在官方报名问卷中填写
- GitHub：https://github.com/Jay7724/paletteguard
- Mooncakes 包名：Jay7724/paletteguard
- 项目类型：原创 MoonBit 开源库与 CI 质量检查组件
- 开源许可证：MIT

## 项目基础与目标

PaletteGuard 是使用 MoonBit 实现的调色板无障碍审计库，面向设计系统、
文档站、终端主题、图表主题和 Wasm 应用。它把颜色 token 解析、前景/背景
角色建模、WCAG 对比度检查、修复建议和 Markdown 报告整合成可复用库，
解决颜色配置分散、人工 review 容易漏检的问题。

项目不是其他语言项目的移植，核心实现和内置语义色板均为本项目原创。与
通用颜色转换库相比，PaletteGuard 的边界集中在“角色感知的可读性审计”和
“可进入 CI 的确定性报告”，便于 MoonBit 项目直接复用和长期维护。

## 本次开发内容与技术路线

本次完成 RGB 颜色模型、`#RGB`/`#RRGGBB`/`rgb(...)`/命名色解析、AA/AAA
策略、角色化色板审计、HSL 变换、前景/背景修复搜索、行式 token 文档诊断、
调色板统计、色阶审计、对比矩阵、Markdown 导出和 26 组原创语义色板目录。

技术路线是以纯 MoonBit 数据模型承载颜色和审计结果，使用 WCAG 相对亮度
公式计算对比度，通过确定性的明暗路径搜索修复候选，并把解析错误保留为
结构化诊断。核心库不读文件、不访问网络，不包含浏览器、图片或 JavaScript
运行时依赖；JSON/TOML/完整 CSS 适配器留作后续边界包。

## 功能、测试与文档

仓库提供 `moon run cmd/main` 可运行示例，输出 Markdown 审计报告、目录摘要
和对比矩阵。测试覆盖解析、边界值、WCAG 算法、颜色变换、自动修复、token
诊断、色板目录、色阶审计、矩阵导出和报告导出；当前本地结果为 21 个测试
全部通过。项目包含 README、API 说明、设计说明、测试记录、AI 辅助开发说明、
变更日志、发布流程、验收清单、Issue 记录和第三方许可证说明。

本地有效 MoonBit 代码共 5,836 行，其中生产代码 5,550 行、测试代码 286
行。GitHub Actions 会执行 `moon fmt --check`、`moon check --target all --deny-warn`、
`moon build`、`moon test --deny-warn`、`moon package` 和示例运行。

## 发布状态

本地代码、测试、构建、示例、打包和 CI 配置已准备完成。`Jay7724/paletteguard`
版本 `0.1.0` 已发布至 Mooncakes，文档页和 manifest 均已返回 HTTP 200。提交
的公开 `main` 分支已推送，GitHub Actions 已成功通过。现在可把公开仓库、
CI 记录、Mooncakes 文档页和 manifest 地址一并提交到比赛问卷。
