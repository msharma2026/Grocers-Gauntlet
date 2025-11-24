class_name AisleNavigation
extends Screen

@onready var npc: CharacterBody2D = $NPC

func _ready() -> void:
	print("AisleNavigation: Scene Loaded")
	# Position player at the bottom entrance
	var player = get_parent().get_node_or_null("GlobalPlayer")
	if player:
		player.global_position = Vector2(576, 550)
		# Ensure player is visible and active (redundant check, handled in game.gd but good safety)
		player.visible = true
		player.process_mode = Node.PROCESS_MODE_INHERIT

func _process(_delta: float) -> void:
	var player = get_parent().get_node_or_null("GlobalPlayer")
	if player and npc:
		var distance = player.global_position.distance_to(npc.global_position)
		
		# Trigger encounter when close
		if distance < 80.0: 
			start_encounter()

func start_encounter() -> void:
	print("Encounter Started!")
	set_process(false) # Stop checking
	# Future: change_screen.emit("combat") or similar
