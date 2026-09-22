# 真值产线
> 原始数据之外，我们在同一条流水线上补齐定位、建图、深度、人手、标定与脱敏等真值：算子自动产出，人工精标与审核兜底，通过数据平台、可视化与 SDK 交付。

:::meta
eyebrow: GROUND TRUTH · 真值产线
:::

## 空间定位与建图
把第一视角视频还原到三维空间：设备在哪、看到了什么、离多远。

### SLAM 定位 · 单设备与跨设备
:::meta
id: slam
image: assets/slam_poses.jpg
fit: cover
spotlight: yes
owner: 兰莎郧
badge: 定位
tags: Ego-Air | 视觉惯性融合 | 因子图 | 跨设备
spec: 输入 | Ego-Air 多路相机 + 500 Hz IMU；手部相机
spec: 方法 | 特征点检测 + IMU 融合 + 因子图优化
spec: 地图特征 | ORB / SuperPoint
spec: 产出 | 设备位姿、3D 路标地图
spec: 质量检查 | 特征重投影误差（可视化查看）
spec: Benchmark | 待补充
:::
为每一段采集数据恢复设备的 6-DoF 轨迹。Ego-Air 头戴设备做视觉惯性定位，定位后构建 3D 路标地图；手部相机通过特征匹配定位到同一地图中，头部与手部的位姿统一在一个坐标系下。上图为头部双目与左右腕部相机中投影出的设备位姿。

#### Ego-Air 定位
- 特征点检测
- IMU 融合
- 因子图构造与优化
- 在可视化界面中查看特征重投影误差

#### 3D 路标建图
定位完成后构建 3D landmark 地图，特征可选 ORB 或 SuperPoint。

#### 手部单目定位
- 与地图做特征匹配，得到手部相机位姿
- 在可视化界面中查看特征重投影误差

#### Benchmark
待补充。计划对着标靶采集数据，建立定位精度的评测基准。

### Ego-Air 区域稠密点云建图
:::meta
id: dense-mapping
image: assets/dense_map.jpg
fit: cover
owner: 兰莎郧
badge: 建图
tags: Ego-Air | 稠密点云 | 区域级
spec: 输入 | Ego-Air 定位结果 + 深度
spec: 产出 | 采集区域的彩色稠密点云
:::
基于 Ego-Air 的定位结果，为采集区域重建彩色稠密点云，还原作业场景的完整三维结构。定位建图算子同时产出设备位姿与稠密地图。

#### 内容
待补充。

### 双目视差与深度
:::meta
id: stereo-depth
image: assets/depth.jpg
image: assets/stereo_rectify.jpg
fit: cover
owner: 兰莎郧
badge: 深度
tags: 立体矫正 | 视差 | 深度网络 | RGB-D 点云
spec: 相机模型 | 双目内外参
spec: 深度来源 | 立体视差 + 深度网络
spec: 输出 | 视差图、深度图、RGB-D 点云
spec: 深度元信息 | 来源、相机、时间、单位、尺度类型、有效区域
spec: 后处理 | 噪点过滤
:::
从双目图像得到逐帧深度：先完成双目标定与立体矫正，再计算视差图并结合深度网络输出深度，最后与 RGB 融合重建 RGB-D 点云并过滤噪点。每份深度都注明来源、对应相机、时间、单位、尺度类型与有效区域，并区分相对深度与米制深度。

#### 处理流程
1. 双目内外参模型
2. 立体矫正：校正后左右图像行对齐（第二张图）
3. 视差图计算
4. 深度网络
5. RGB + 深度重建 RGB-D 点云（第一张图）
6. 噪点过滤

#### 噪点过滤策略
待补充。

### 虚拟相机
:::meta
id: virtual-camera
image: assets/virtual_camera.jpg
owner: 兰莎郧
badge: 视角
tags: 新视角 | 跨本体 | 重渲染
spec: 输入 | 定位结果 + 三维重建
spec: 输出 | 目标相机视角下的虚拟图像
spec: 示例视角 | Ego-Air 头戴相机、Unitree G1D 头部相机
:::
基于定位与三维重建结果，从新的虚拟视角重新生成观测数据：同一段采集可以渲染成不同设备或本体的相机视角。图左为 Ego-Air 视角的虚拟图像，图右为同一场景在 Unitree G1D 视角下的虚拟图像。

#### 内容
待补充。

## 人手、本体与语义
人手怎么动、机器人本体在哪、画面里发生了什么：人类演示与机器人数据的动作与语义真值。

### 具身本体手眼标定
:::meta
id: hand-eye-calibration
image: assets/handeye_tuner.jpg
image: assets/handeye_3d.jpg
fit: cover
spotlight: yes
owner: 兰莎郧
badge: 标定
tags: 固定相机 | 手眼标定 | FK 可视化
spec: 标定类型 | 固定相机标定、手眼标定
spec: 支持本体 | FR3、UR7、Piper、BXI（UD）、G1 等
spec: 标定方式 | 模型叠加多帧图像，逐轴微调旋转与平移
spec: 结果查看 | 三维视图：机械臂坐标系、相机位姿、标定板
spec: 结果规格 | 内外参（格式待补充）
spec: 验证 | FK 结果可视化
:::
标定相机与机器人本体之间的外参。按当前外参把机器人模型叠加到多帧相机图像上，逐轴微调旋转与平移，直到模型与图像对齐后保存；标定结果可以在三维视图中查看机械臂坐标系、相机位姿与标定板。

#### 标定内容
- 固定相机标定
- 手眼标定

#### 涉及本体
FR3、UR7、Piper、BXI（即 UD）、G1 等。

#### 内外参结果规格
待补充。

#### FK 结果可视化
待补充。

### 手部检测
:::meta
id: hand-detection
image: assets/hand_pose.jpg
fit: cover
owner: 付垚
badge: 人手
tags: Hand Pose | 三角化 | 多人跟踪
spec: 输出 | 左右手、骨架、关节 2D / 3D 坐标、腕部位姿
spec: 三维化 | 多视角三角化
spec: 可见性 | 逐关节记录，不可见关节不当作零值
spec: 多人场景 | 检测、跟踪、人手归属关联
:::
检测画面中的手，经多视角三角化得到三维手部骨架与腕部位姿，并投影回各路图像。每只手记录左右、骨架定义、关节顺序、坐标、单位与可见性；多人同时出镜时，持续跟踪每只手并关联到对应的人。

#### 模型链路
待补充。

#### 三角化
待补充。

#### 多人检测、跟踪与人手关联
待补充。

#### 能力对比
待补充，将参考阿里云当前的相关能力。

### 时序切分与语义综述
:::meta
id: semantic
visual: chart
badge: 语义
tags: 动作区间 | 环境综述 | 动作综述 | 3D Box
spec: 时序切分 | 按连续动作单元生成区间与局部描述
spec: 环境综述 | Visual Context Caption
spec: 动作综述 | Observed Action Summary
spec: 局部细节 | Action Caption、Observed Action Details
spec: 3D Box | 位置、尺寸、朝向、跟踪标识、坐标系
:::
自动标注算子产出的语义与时序真值：把一段操作切成有意义的动作区间，描述画面环境和实际发生的动作，并为物体生成三维包络框。

#### Temporal Segment
基于连续动作单元生成逻辑时间区间及局部描述；不按固定时长或预设 Skill ID 机械切分，默认不物理切视频。

#### 画面环境综述
以代表帧描述背景、工作区域、光照、杂乱和遮挡，形成 Visual Context Caption。

#### 实际动作综述
基于全程视频及可用信号生成 Observed Action Summary，描述主要动作、对象、结果及明显的重试。

#### 局部细节与 Skill
以 Action Caption、Observed Action Details 和证据承载具体事实；Skill 通过受词表约束的映射辅助理解与检索。

#### 3D Box
记录对象的三维位置、尺寸、朝向、局部跟踪标识及坐标系，并保存观测时间、可见性和生成来源。

### 全身本体遥操作数据
:::meta
id: wholebody-teleop
image: assets/teleop.jpg
fit: cover
owner: 王一舟
badge: 本体数据
tags: 全身 | 遥操作 | 多相机
spec: 示例本体 | Galaxea R1 Lite
spec: 数据载荷 | 头部左 / 右相机、左 / 右腕部相机、关节状态
spec: 三维视图 | 机器人模型与各关节坐标系
:::
全身机器人本体的遥操作数据及其真值。图为 Galaxea R1 Lite 遥操作采集的数据载荷：头部左右相机与左右腕部相机图像，以及三维视图中的机器人模型与各关节坐标系。

#### 内容
待补充。

### 灵巧手数据
:::meta
id: dexterous-hand
image: assets/dexhand.jpg
plate: dark
owner: 王一舟
badge: 本体数据
tags: 灵巧手 | 手部网格 | 重定向
spec: 输入 | 人手视频（示例为单目网络摄像头）
spec: 手部重建 | WiLoR 三维手部网格
spec: 重定向 | 灵巧手 URDF 逆运动学（示例：DH116-L000-A1）
spec: 已支持型号 | Letron、Wuji、Cobrain
:::
从人手视频得到灵巧手可执行的关节数据：先检测手部并重建三维手部网格，再通过灵巧手 URDF 的逆运动学把人手姿态重定向到机器人手上。图中从左到右依次为输入画面、WiLoR 三维手部网格、DH116-L000-A1 灵巧手的逆运动学结果。

#### 内容
待补充。

## 平台与交付
数据怎么查看、怎么下载、怎么处理，以及怎么保证合规。

### 可视化功能
:::meta
id: visualization
image: assets/visualization.jpg
fit: cover
spotlight: yes
owner: 王一舟
badge: 可视化
tags: 原始数据 | 真值叠加 | 自动布局
spec: 布局 | 按设备类型自动配置面板
spec: 三维视图 | RGB-D 点云、设备位姿、传感器内外参、3D 真值
spec: 图像视图 | 校正后双目图像，叠加投影的 3D 真值
spec: 其他面板 | 深度图、灰度鱼眼、IMU 曲线、相机标定
spec: 使用场景 | 数据采集、数据交易的样本评估
:::
在一个界面中快速浏览原始数据与真值，数据采集与数据交易时都可以使用。图为 Ego-Air 成品数据：系统按设备自动配置布局，三维视图显示 RGB-D 点云、设备瞬时位姿与传感器内外参，以及手腕位姿、手部骨架、未来轨迹等 3D 真值。

#### 画面构成（Ego-Air）
- 布局：系统自动配置（Ego 头环布局）
- 三维视图：RGB-D 点云、设备瞬时位姿与传感器内外参，以及 3D 真值（手腕位姿、手部骨架、未来轨迹）
- 双目左 / 右图像（已校正），叠加投影到图像上的 3D 真值
- 深度图（自动标注）
- 四路灰度鱼眼图像，用于视觉惯性里程计
- IMU 角速度曲线与相机标定等消息明细

#### 内容
待补充。

### 数据、预标注与可视化下载 · SDK
:::meta
id: download-sdk
image: assets/platform_episodes.jpg
fit: cover
owner: 孙青
badge: 交付
tags: 数据平台 | 下载 | SDK
spec: 下载内容 | 原始数据、预标注与真值、可视化结果
spec: 训练集格式 | 原生包、LeRobotDataset、RLDS
spec: 筛选 | 数据集、任务描述、机器人 / 夹爪类型、是否成功、频率、帧数
spec: SDK | 使用方法待补充
:::
在数据平台的 Episode 列表中筛选数据，逐条下载或进入数据可视化。下载内容分三类：原始数据、预标注与真值结果、可视化结果；训练集可以导出为原生包、LeRobotDataset 与 RLDS。

#### 下载内容的组织方式
- 原始数据
- 预标注与真值结果
- 可视化结果

#### SDK 使用方法
待补充。

### 任务调度架构
:::meta
id: task-scheduling
image: assets/platform_jobs.jpg
image: assets/scheduling_flow.svg
fit: cover
owner: 孙青
badge: 平台
tags: DAG | 集群并行 | 版本发布
spec: 编排 | 算子组成 DAG，表达依赖关系
spec: 执行 | 计算集群高并行批量运行，有限重试、取消
spec: 输入检查 | 通道、标定、同步、模型配置
spec: 发布 | 产物校验后发布，新版失败不影响已发布版本
:::
把定位建图、手部检测、人脸识别等算子组成有向无环图（DAG），在计算集群上高并行、高吞吐地批量运行。脱敏与质检同样以算子形式运行在这套调度上，共用编排、重试与版本机制。

#### 功能
- **DAG 编排**：固定流程模板 + 可复用算子
- **输入依赖检查**：运行前检查通道、标定、同步与模型配置
- **集群并行执行**：批量运行，支持有限重试、取消及成本控制
- **产物校验与版本发布**：可用性与运行状态分开，新版运行失败不影响已发布版本
- **人工衔接**：需要人工创建、修正或审核的内容进入送标流程

#### 内容
待补充。

### 人工精标与审核
:::meta
id: annotation
image: assets/annotation_hand.jpg
image: assets/annotation_box.jpg
fit: cover
badge: 标注
tags: 预标修正 | 审核返修 | 2D / 3D 框
spec: 作业内容 | 预标修正、人工创建、审核、返修
spec: 工具 | 手部关键点、腕部位姿、动作区间、2D / 3D 包络框
spec: 质量控制 | 全量审核、比例抽检、多人仲裁
spec: 回标 | 审核通过后生成固定版本，回到数据平台
:::
自动算子的结果作为预标送入标注编辑器，由标注员修正、审核与返修，人工修订另存结果，不覆盖自动预测。图一为手部关键点、腕部位姿与动作区间精标，图二为货架商品的 2D 与 3D 包络框标注。

### 个人信息脱敏
:::meta
id: privacy
image: assets/face_blur.webp
fit: cover
owner: 余良凯
badge: 合规
tags: 人脸 | 脱敏 | 准召率
spec: 处理对象 | 个人信息（定义待补充）
spec: 模型 | 人脸模型
spec: 产出 | 独立的脱敏版本，Raw 长期冷备且访问受限
spec: 评估指标 | 准确率 / 召回率
spec: 当前准召率 | 待补充
:::
对采集数据中的个人信息做脱敏处理：检测画面中的人脸并模糊，生成独立的脱敏版本并检查结果。下游的预览、增强、送标、检索与训练集都使用脱敏版本；原始数据长期冷备，访问额外受限。

#### 个人信息定义
待补充。

#### 人脸模型
待补充。

#### 性能指标定义
待补充。

#### 当前模型准召率
待补充。

### 支持的设备
:::meta
id: supported-devices
image: assets/devices.jpg
owner: 王一舟
badge: 设备
tags: 本体遥操作 | 无本体 | 末端执行器
spec: 本体遥操作 | 足式人形、轮式人形、固定机械臂
spec: 无本体 | 头环、头环 + 手环 / 指套 / 手套
spec: 末端执行器 | 夹爪、灵巧手
:::
真值产线目前支持处理的采集设备，分为本体遥操作、无本体与末端执行器三大类。采集设备详情见「设备产能」页。

#### 已支持型号
| 大类 | 小类 | 已支持型号 |
|---|---|---|
| 本体遥操作 | 足式人形 | Unitree G1、H2；AgiBot X2、A3；UD-W |
| 本体遥操作 | 轮式人形 | Unitree G1D、H2D；AgiBot G1；Galaxea R1 Lite；AD01 |
| 本体遥操作 | 固定 | Franka FR3；Universal Robots UR7；AgileX PiPER、NERO；UD-B |
| 末端执行器 | 夹爪 | Robotiq 2F-85、2F-140 |
| 末端执行器 | 灵巧手 | Letron、Wuji、Cobrain |
| 无本体 | 头环 | Ego-Air、Ego-4eye |
| 无本体 | 头环 + 手环 | Ego-Strap |
| 无本体 | 头环 + 指套 | Ego-Pro、UMI |
| 无本体 | 头环 + 手套 | 待补充 |
