extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var file_path := "user://Saves/Save "+str(1)+"/gameProgress.bat"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path,FileAccess.READ)
		var a = file.get_var(Variables.level)
		$Control/FirstFileSelect.text += "\n\nlevel "+str(a)
	else:
		$Control/FirstFileSelect.text += "\n\nempty"
	
	file_path = "user://Saves/Save "+str(2)+"/gameProgress.bat"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path,FileAccess.READ)
		var a = file.get_var(Variables.level)
		$Control/SecondFileSelect.text += "\n\nlevel "+str(a)
	else:
		$Control/SecondFileSelect.text += "\n\nempty"
	
	file_path = "user://Saves/Save "+str(3)+"/gameProgress.bat"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path,FileAccess.READ)
		var a = file.get_var(Variables.level)
		$Control/ThirdFileSelect.text += "\n\nlevel "+str(a)
	else:
		$Control/ThirdFileSelect.text += "\n\nempty"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")

func change_current_save(num:int,reset:bool):
		
	Variables.current_save_file = num
	GameFiles.create_save_files()
	GameFiles.last_user_save()
	if reset:
		GameFiles.game_progress_save(true)
	else:
		GameFiles.game_progress_load()
	# send to level
	get_tree().change_scene_to_file("res://Scenes/level/level.tscn")
	LevelClass.load_level(Variables.level)

func _on_first_file_pressed():
	change_current_save(1,true)


func _on_second_file_pressed():
	change_current_save(2,true)
	
func _on_third_file_pressed():
	change_current_save(3,true)


func _on_first_file_select_pressed():
	change_current_save(1,false)


func _on_second_file_select_pressed():
	change_current_save(2,false)


func _on_third_file_select_pressed():
	change_current_save(3,false)
