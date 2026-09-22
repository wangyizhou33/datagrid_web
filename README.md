# DataGrid 官网示例

页面结构与样式在 `index.html`，**所有文字内容都在 `content/*.md`**，改 markdown 刷新即可，不用碰代码。

| 文件 | 对应位置 |
|---|---|
| `content/site.md` | 顶部 hero、四个指标、页脚 |
| `content/devices/devices.md` | Tab「设备产能」，图片放 `content/devices/assets/` |
| `content/truth/truth.md` | Tab「真值产线」 |
| `content/scenes/scenes.md` | Tab「场景产能」 |

## 本地预览

页面运行时读取 .md 文件，**不能双击 index.html 打开**（浏览器禁止 file:// 读本地文件），需要起一个静态服务：

```bash
python3 -m http.server 8000
# 打开 http://localhost:8000
```

## 写法约定

```md
# Tab 名称（导航上显示的就是它）
> 页面导语，一行

:::meta
eyebrow: DEVICE FLEET · 采集本体
:::

## 分组名称
分组说明段落。

### 卡片标题
:::meta
id: dg-station-d2            ← 详情链接用，#/devices/dg-station-d2；只用英文、数字、连字符
image: assets/device1.png    ← 可选：产品图，路径相对于这个 md 文件；可写多行，弹窗里左右滑动查看
fit: cover                   ← 可选：截图类图片铺满卡片（会裁掉边缘）；不写则完整显示在白底上，适合产品图
plate: dark                  ← 可选：完整显示时用深色底板，适合深色界面的宽截图
visual: rig                  ← 没有 image 时使用的程序化缩略图，见下表
spotlight: yes               ← 可选：显示为整行大卡，每组建议最多 1 个
badge: 一方设备               ← 卡片左上角高亮标签
owner: 王一舟                ← 可选：内容负责人，显示为「撰写 · 王一舟」标签；定稿后删掉即可
tags: 双臂 | 静态台面 | 主从遥操
spec: 自由度 | 7 × 2 + 平行夹爪    ← 可重复多行；卡片上显示前 2 条，弹窗显示全部
spec: 采集频率 | 30 Hz
:::
第一段 = 卡片上的摘要（最多显示 3 行）。

#### 小标题
这里往下的所有内容只在点开详情弹窗时显示，支持列表、**加粗**、有序列表等常规 markdown。
```

- 新增卡片：复制一整段 `### … :::meta … :::` 改内容即可。
- 新增分组：写一个新的 `## 分组名`。
- 分组内卡片数建议 3 或 6（整行排满）；4 张会自动排成 2×2。

### `visual` 可选值

| 值 | 图元 | 适合 |
|---|---|---|
| `rig` | 机械臂运动链 + 关节曲线 | 本体、机械臂 |
| `traj` | 世界坐标系下的轨迹 | 移动平台、重定向 |
| `points` | 点云 | 手持采集、重建、接触点 |
| `depth` | 深度色带 | 深度真值、传感器、力序列 |
| `mask` | 实例分割掩码 | 分割、灵巧手、隐私处理 |
| `grid` | 标定棋盘格 | 标定、6D 位姿、资产 |
| `plan` | 场地平面图 + 工位路径 | 场景 |
| `chart` | 分层时间轴 + 柱状 | 语言标注、切分、质量评分 |

缩略图按卡片标题做随机种子生成，同一标题每次都一样。写了 `image:` 就优先显示图片（白底展示，按比例完整显示，不裁切）。

### `site.md` 特殊约定

- `## 指标` 下每行 `- 名称 | 数字 单位`，建议 4 条。
- `## 页脚` 下是普通 markdown。

## 新增一个 Tab

在 `index.html` 脚本顶部的 `TABS` 数组里加一行 `{ id:'xxx', file:'content/xxx/xxx.md' }`，再新建对应 md 文件。发布 Artifact 时记得把新文件一起带上。
