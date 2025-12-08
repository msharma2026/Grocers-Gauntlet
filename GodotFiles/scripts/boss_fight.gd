class_name BossFight
extends Screen

var dialogue_overlay: DialogueOverlay
const DIALOGUE_SCENE: PackedScene = preload("res://scenes/user interface/dialogue_overlay.tscn")

# Boss Stats
var boss_name: String = "Manager"
var boss_health: int = 75
var boss_max_health: int = 75
var boss_attack: int = 60
var boss_defense: int = 20
var boss_speed: int = 30

# Battle State
var is_player_blocking: bool = false
var is_boss_blocking: bool = false
var battle_active: bool = false
var player: Player

func _ready() -> void:
	player = get_parent().get_node_or_null("GlobalPlayer")
	
	if player:
		player.visible = true
		player.process_mode = Node.PROCESS_MODE_INHERIT
		var spawn_point = Vector2(576, 500)
		if has_node("PlayerSpawn"):
			spawn_point = get_node("PlayerSpawn").global_position
		player.global_position = spawn_point
	
	var boss_camera = get_node_or_null("Camera2D")
	if boss_camera:
		boss_camera.make_current()

func _start_on_transition_end() -> void:
	pass

func _on_boss_area_body_entered(body: Node2D) -> void:
	if body is Player and not battle_active:
		if player:
			player.set_physics_process(false)
			player.velocity = Vector2.ZERO
			if player.sprite:
				player.sprite.play("idle_straight")
		
		if dialogue_overlay == null:
			start_boss_dialogue()

# Intro
func start_boss_dialogue() -> void:
	dialogue_overlay = DIALOGUE_SCENE.instantiate() as DialogueOverlay
	add_child(dialogue_overlay)
	dialogue_overlay.choice_selected.connect(_on_battle_choice_made)
	
	dialogue_overlay.start_dialogue(boss_name, ["STOP!", "You are cheating yourself again."])
	dialogue_overlay.dialogue_finished.connect(_start_battle_sequence, CONNECT_ONE_SHOT)

# Battle Implementation
func _start_battle_sequence() -> void:
	battle_active = true
	
	# Logic for locking movement removed here because it was moved to _on_boss_area_body_entered

	if dialogue_overlay.dialogue_finished.is_connected(_start_battle_sequence):
		dialogue_overlay.dialogue_finished.disconnect(_start_battle_sequence)
	
	_start_new_turn()

func _start_new_turn() -> void:
	is_player_blocking = false
	is_boss_blocking = false
	
	if game_data.dexterity >= boss_speed:
		_player_choice_menu()
	else:
		_boss_turn()

func _player_choice_menu() -> void:
	var hp_text = "Boss HP: %d / %d" % [boss_health, boss_max_health]
	var options: Array[String] = [
		"Strike (Attack)", 
		"Block (Defense)", 
		"Outmaneuver (Speed)"
	]
	dialogue_overlay.show_choices(hp_text + "\nIt's your turn! Choose an action:", options)

func _on_battle_choice_made(index: int) -> void:
	if not battle_active: return
	
	match index:
		0: _player_attack()
		1: _player_defend()
		2: _player_speed_move()

# Player Actions
func _player_attack() -> void:
	var raw_damage = game_data.attack * 2.0 
	var mitigation = boss_defense / 2.0
	
	if is_boss_blocking:
		mitigation = boss_defense * 1.5 
		
	var actual_damage = int(max(1, raw_damage - mitigation))
	boss_health -= actual_damage
	
	_narrate_action("Player", "You threw a can of beans!", "Dealt %d damage to the Manager." % actual_damage)
	
	await dialogue_overlay.dialogue_finished
	_check_win_condition(false)

func _player_defend() -> void:
	is_player_blocking = true
	_narrate_action("Player", "You raise your shopping cart shield!", "Blocking next attack.")
	
	await dialogue_overlay.dialogue_finished
	_end_player_turn()

func _player_speed_move() -> void:
	var success_chance = float(game_data.dexterity) / 100.0
	success_chance = clamp(success_chance, 0.3, 0.9)
	
	if randf() < success_chance:
		var damage = int(max(1, game_data.dexterity * 0.4))
		boss_health -= damage
		is_player_blocking = true 
		_narrate_action("Player", "You zipped past him!", "Dealt %d damage and prepared to dodge." % damage)
	else:
		_narrate_action("Player", "You tried to run but slipped!", "The move failed!")
		
	await dialogue_overlay.dialogue_finished
	_check_win_condition(false)

# Boss Actions
func _boss_turn() -> void:
	if randf() < 0.2:
		is_boss_blocking = true
		_narrate_action(boss_name, "The Manager braces himself.", "He is guarding against your next hit.")
	else:
		_boss_attack()
	
	await dialogue_overlay.dialogue_finished

	if game_data.health_percentage <= 0:
		_handle_game_over()
		return
	
	if game_data.dexterity >= boss_speed:
		_start_new_turn()
	else:
		_player_choice_menu()

func _boss_attack() -> void:
	var raw_damage = boss_attack
	var mitigation = game_data.defense / 2.0
	
	if is_player_blocking:
		mitigation = game_data.defense 
		
	var actual_damage = int(max(1, raw_damage - mitigation))
	
	if player:
		player.take_damage(actual_damage)
	
	_narrate_action(boss_name, "The Manager shouts 'PRICE CHECK!'", "You took %d damage." % actual_damage)

func _end_player_turn() -> void:
	if game_data.dexterity >= boss_speed:
		_boss_turn()
	else:
		_start_new_turn()

func _narrate_action(speaker: String, line1: String, line2: String) -> void:
	var signals = dialogue_overlay.dialogue_finished.get_connections()
	for conn in signals:
		dialogue_overlay.dialogue_finished.disconnect(conn.callable)
		
	dialogue_overlay.start_dialogue(speaker, [line1, line2])

func _check_win_condition(is_boss_turn: bool) -> void:
	var signals = dialogue_overlay.dialogue_finished.get_connections()
	for conn in signals:
		dialogue_overlay.dialogue_finished.disconnect(conn.callable)

	if boss_health <= 0:
		_win_battle()
	elif game_data.health_percentage <= 0:
		_handle_game_over()
	else:
		if is_boss_turn:
			_start_new_turn()
		else:
			_end_player_turn()

func _win_battle() -> void:
	battle_active = false
	
	if player:
		player.set_physics_process(true)
		
	dialogue_overlay.start_dialogue(boss_name, ["Impossible...", "You... you actually saved money?"])
	dialogue_overlay.dialogue_finished.connect(func(): 
		dialogue_overlay.close()
		change_screen.emit("end_scene") 
	)

func _handle_game_over() -> void:
	if player:
		player.set_physics_process(true)
	player.take_damage(-100)
	change_screen.emit("game_over")
