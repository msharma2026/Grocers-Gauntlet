extends Node

var music : Dictionary
var sfx : Dictionary

var current_song: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music = {
		'theme':$Theme,
		'fun':$Fun,
		'candy':$Candy,
		'alcohol':$Alcohol
	}
	sfx = {
		'hurt':$Hurt,
		'success':$Success,
	}


func play_music(song_name: String) -> void: 
	var song_to_play: AudioStreamPlayer
	if  not music.has(song_name):
		return
	song_to_play = music[song_name] 
	
	if current_song == song_to_play:
		return
		
	if current_song:
		await fade_out(current_song,1.2)
		current_song.stop()
	
	song_to_play.play()
	current_song = song_to_play


func stop_music() -> void:
	if current_song:
		current_song.stop()
		current_song = null


func play_sfx(sfx_name: String) -> void:
	var sfx_to_play = sfx[sfx_name]
	sfx_to_play.play()


func fade_out(player: AudioStreamPlayer, duration: float = 1) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(player, "volume_db", -80, duration)
	await tween.finished
