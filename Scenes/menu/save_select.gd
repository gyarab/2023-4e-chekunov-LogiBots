extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")

func change_current_save(num:int):
	Variables.current_save_file = num
	GameFiles.create_save_files()
	GameFiles.last_user_save()
	GameFiles.last_user_load()
	GameFiles.game_progress_load()
	# send to level
	get_tree().change_scene_to_file("res://Scenes/level/level.tscn")
	LevelClass.load_level(Variables.level)

func _on_first_file_pressed():
	change_current_save(1)


func _on_second_file_pressed():
	change_current_save(2)
	
func _on_third_file_pressed():
	change_current_save(3)
