class_name BossFight
extends Screen

var dialogue_overlay: DialogueOverlay

const DIALOGUE_SCENE: PackedScene = preload("res://scenes/user interface/dialogue_overlay.tscn")

func _ready() -> void:
	var player = get_parent().get_node_or_null("GlobalPlayer")
	if player:
		# Ensure player is visible and active
		player.visible = true
		player.process_mode = Node.PROCESS_MODE_INHERIT
		
		# Set player position to the spawn marker
		var spawn_point = Vector2(576, 500)
		if has_node("PlayerSpawn"):
			spawn_point = get_node("PlayerSpawn").global_position
		player.global_position = spawn_point
	
	var boss_camera = get_node_or_null("Camera2D")
	if boss_camera:
		boss_camera.make_current()

func _start_on_transition_end() -> void:
	# Previously this started dialogue immediately. 
	# Now we leave it empty so the player is free to move.
	pass

# [New] Connected from the BossArea Area2D signal in the editor
func _on_boss_area_body_entered(body: Node2D) -> void:
	# DEBUG: Print what entered the area to the Output console
	print("Body entered boss area: ", body.name)
	
	if body is Player:
		# DEBUG: Confirm it found the script class correctly
		print("Body identified as Player!")
		
		# Check if dialogue is already running to prevent double triggers
		if dialogue_overlay == null:
			start_boss_dialogue()

func start_boss_dialogue() -> void:
	dialogue_overlay = DIALOGUE_SCENE.instantiate() as DialogueOverlay
	add_child(dialogue_overlay)
	
	dialogue_overlay.start_dialogue("Manager", ["STOP!"])
	dialogue_overlay.dialogue_finished.connect(_dialogue_step_1, CONNECT_ONE_SHOT)

func _dialogue_step_1() -> void:
	dialogue_overlay.start_dialogue("Manager", ["You are cheating yourself again."])
	dialogue_overlay.dialogue_finished.connect(_dialogue_step_2, CONNECT_ONE_SHOT)

func _dialogue_step_2() -> void:
	dialogue_overlay.start_dialogue("Player", ["Again?"])
	dialogue_overlay.dialogue_finished.connect(_dialogue_step_3, CONNECT_ONE_SHOT)

func _dialogue_step_3() -> void:
	dialogue_overlay.start_dialogue("Manager", ["You take the easy way out to help yourself."])
	dialogue_overlay.dialogue_finished.connect(_dialogue_step_4, CONNECT_ONE_SHOT)

func _dialogue_step_4() -> void:
	dialogue_overlay.start_dialogue("Player", ["I was given bad cards, give me a break."])
	dialogue_overlay.dialogue_finished.connect(_dialogue_step_5, CONNECT_ONE_SHOT)

func _dialogue_step_5() -> void:
	dialogue_overlay.start_dialogue("Manager", ["Would your own daughter accept that excuse?"])
	dialogue_overlay.dialogue_finished.connect(_dialogue_step_6, CONNECT_ONE_SHOT)

func _dialogue_step_6() -> void:
	dialogue_overlay.start_dialogue("Player", ["My daughter?"])
	dialogue_overlay.dialogue_finished.connect(_dialogue_step_7, CONNECT_ONE_SHOT)

func _dialogue_step_7() -> void:
	dialogue_overlay.start_dialogue("Manager", ["You are dense. Did you not read her note?"])
	dialogue_overlay.dialogue_finished.connect(_dialogue_step_8, CONNECT_ONE_SHOT)

func _dialogue_step_8() -> void:
	dialogue_overlay.start_dialogue("Player", ["I'm not taking this anymore.", "I'm done with this weird grocery store."])
	dialogue_overlay.dialogue_finished.connect(_dialogue_finished, CONNECT_ONE_SHOT)

func _dialogue_finished() -> void:
	if dialogue_overlay:
		dialogue_overlay.close()
		dialogue_overlay = null
	# Here you can add logic for what happens after the fight (e.g., transition to credits)
	# change_screen.emit("credits")
