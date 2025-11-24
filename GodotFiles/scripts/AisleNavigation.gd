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

const DIALOGUE_SCENE: PackedScene = preload("res://scenes/user interface/DialogueOverlay.tscn")

func start_encounter() -> void:
	print("Encounter Started!")
	set_process(false) # Stop checking
	
	var dialogue = DIALOGUE_SCENE.instantiate()
	add_child(dialogue)
	
	var lines: Array[String] = [
		"Hey there, traveler...", 
		"Looking for some fresh produce?", 
		"I've got the best deals in the dungeon."
	]
	dialogue.start_dialogue("Merchant", lines)
	
	dialogue.dialogue_finished.connect(_on_encounter_finished)

func _on_encounter_finished() -> void:
	print("Encounter Finished - Returning to Map or Starting Combat")
	# For now, we just reset the process so you can walk away (or trigger it again if we didn't disable it)
	# In the future, this is where we'd switch to the Haggle/Combat screen.
