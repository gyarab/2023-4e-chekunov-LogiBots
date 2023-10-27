extends Node2D

var can_send_to_level:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	GameFiles.last_user_load()
	GameFiles.game_progress_load()
	
	if Variables.current_save_file != -1:
		can_send_to_level = true
		$Control/ContinueButton.text = "CONTINUE \n level "+str(Variables.level)


func _on_quit_button_pressed():
	get_tree().quit()

func _on_continue_button_pressed():
	if can_send_to_level:
		get_tree().change_scene_to_file("res://Scenes/level/level.tscn")
		LevelClass.load_level(Variables.level)

func _on_new_game_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/save_select.tscn")


func _on_selsect_level_button_pressed():
	if can_send_to_level:
		get_tree().change_scene_to_file("res://Scenes/menu/level_select.tscn")
