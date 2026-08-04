extends RefCounted

## 改装界面文案集中管理（与 settings_text.gd 同思路，便于后续本地化）

const TITLE := "武器改装"
const SUBTITLE := "点击引线标注的挂载点卡片，安装或卸下配件 · 应用后生效"
const RESET_VIEW := "复位视角"
const OPTION_COUNT := "%d 个可用配件"
const INSTALL := "安装"
const DETACH_SHORT := "卸下"
const NO_MODIFIER := "无数值修正"

const NO_WEAPON := "当前没有装备武器"
const NO_WEAPON_HINT := "装备一把武器后再打开改装界面"
const NO_SLOTS := "该武器没有可用挂载点"

const SLOT_EMPTY := "空"
const SLOT_LOCKED := "不可拆卸"

const LIST_EMPTY := "没有适配此挂载点的配件"
const DETACH := "卸下当前配件"
const INSTALLED := "已安装"
const SIDE_RAIL := "侧导轨"
const SIDE_RAIL_LEFT := "左侧"
const SIDE_RAIL_RIGHT := "右侧"
const SIDE_RAIL_STATUS := "已安装 %d / 2"
const RAIL_POSITION := "导轨位置"
const RAIL_POSITION_HINT := "拖动调整配件在导轨上的前后位置"

const CLOSE := "关闭"
const APPLY := "应用更改"
const REVERT := "放弃更改"
const REPLACE := "更换"
const FOOTER_HINT := "改装先在预览中生效，点「应用更改」写入武器 · ESC 关闭"

# 核心配件（握把 / 护木 / 机匣盖）：缺一不可，否则枪无法正常持握使用
const CORE_TAG := "· 核心"
const CORE_MISSING := "缺少核心配件"
const CORE_HINT := "核心配件可暂时卸下，但应用前必须装回"
const CORE_BLOCKED := "无法应用：以下核心挂载点为空 — %s"

const STAT_HEADER := "武器参数"
const STAT_SPREAD_HIP := "腰射散布"
const STAT_SPREAD_ADS := "机瞄散布"
const STAT_RECOIL_V := "单发俯仰角速度(°/s)"
const STAT_RECOIL_H := "单发偏航角速度(°/s)"
const STAT_WEIGHT := "总重量"
const STAT_LENGTH := "全长"

const EQUIP_FAILED := "安装失败：%s"
const SLOT_REQUIRES := "需要先安装：%s"
