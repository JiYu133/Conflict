extends RefCounted

## 改装界面文案集中管理（与 settings_text.gd 同思路，便于后续本地化）

const TITLE := "武器改装"
const SUBTITLE := "选择左侧挂载点，再从右侧列表安装或卸下配件"

const NO_WEAPON := "当前没有装备武器"
const NO_WEAPON_HINT := "装备一把武器后再打开改装界面"
const NO_SLOTS := "该武器没有可用挂载点"

const SLOT_EMPTY := "空"
const SLOT_LOCKED := "不可拆卸"

const LIST_EMPTY := "没有适配此挂载点的配件"
const DETACH := "卸下当前配件"
const INSTALLED := "已安装"

const CLOSE := "关闭"
const FOOTER_HINT := "ESC 关闭 · 改装即时生效"

const STAT_HEADER := "武器参数"
const STAT_SPREAD_HIP := "腰射散布"
const STAT_SPREAD_ADS := "机瞄散布"
const STAT_RECOIL_V := "垂直后座"
const STAT_RECOIL_H := "水平后座"
const STAT_WEIGHT := "总重量"
const STAT_LENGTH := "全长"

const EQUIP_FAILED := "安装失败：%s"
const SLOT_REQUIRES := "需要先安装：%s"
