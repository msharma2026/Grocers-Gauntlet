# ItemConfig.gd

class_name ItemConfig
extends Resource

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

var sell_price: float
