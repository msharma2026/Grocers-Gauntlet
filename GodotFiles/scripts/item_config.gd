# ItemConfig.gd

class_name ItemConfig
extends Resource

enum QUALITY {PERFECT,COMMON,ROUGH}

@export var item_id: String
@export var type: ItemTypeConfig
@export var size: int
@export var base_price: float
@export var max_price: float
@export var is_on_sale: bool
@export var haggle_potential: float
@export var health_increase: int
@export var charisma_increase: int
@export var dexterity_increase: int
@export var defense_increase: int
@export var budget_increase: float
@export var attack_increase: float
@export var description: String
@export var icon: Texture2D
var quality : QUALITY

var sell_price: float

func _init() -> void:
	var ran: float = randf()
	if ran > 0.9:
		quality = QUALITY.PERFECT
	elif ran > 0.8:
		quality = QUALITY.ROUGH
	else:
		quality = QUALITY.COMMON

func finalize_quality():
	if quality == QUALITY.PERFECT:
		_apply_quality_bonus(0.25)
	elif quality == QUALITY.ROUGH:
		_apply_quality_penalty(0.15)

func _apply_quality_bonus(percent: float) -> void:
	var stat_names = [
		"health_increase",
		"charisma_increase",
		"dexterity_increase",
		"defense_increase",
		"budget_increase",
		"attack_increase"
	]
	
	for stat in stat_names:
		var value = get(stat)
		if typeof(value) == TYPE_INT:
			set(stat, value + int(ceil(value * percent)))
		elif typeof(value) == TYPE_FLOAT:
			set(stat, value + ceil(value * percent))
		print(get(stat))


func _apply_quality_penalty(percent: float) -> void:
	var stat_names = [
		"health_increase",
		"charisma_increase",
		"dexterity_increase",
		"defense_increase",
		"budget_increase",
		"attack_increase"
	]
	
	for stat in stat_names:
		var value = get(stat)
		if typeof(value) == TYPE_INT:
			set(stat, value - int(ceil(value * percent)))
		elif typeof(value) == TYPE_FLOAT:
			set(stat, value - ceil(value * percent))
