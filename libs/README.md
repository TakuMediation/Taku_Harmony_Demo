# GroMore 集成说明

## 穿山甲 / GroMore SDK

- 建议使用 **@csj/openadsdk 7.6.5**（与本包 GroMore 适配器一致）。
- 若改用其他版本，**C2S 竞价与预估收益**可能异常，影响排序与报表。

## GroMore 内配置快手

- 在 GroMore 聚合中启用快手子 ADN 时，快手 SDK 须使用 **3.0.6**。
- 须同时集成本包提供的 **@csj/adapter_ks**（3.0.6 桥接 HAR），勿在 GM 链路混用 3.0.10 等其它快手版本。

