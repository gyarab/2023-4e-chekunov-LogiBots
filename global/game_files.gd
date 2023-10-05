extends Node
# Scripts that iteracts with file system, saving and loading

func create_save_files():
	if !DirAccess.dir_exists_absolute("user://Saves"):
		var dir = DirAccess.open("user://")
		dir.make_dir("Saves")
		
	if !DirAccess.dir_exists_absolute("user://Saves/Save "+str(Variables.current_save_file)):
		var current_save_dir = DirAccess.open("user://Saves")
		current_save_dir.make_dir("Save "+str(Variables.current_save_file))
		print("Save")
	else:
		print("exist!")
		
	#CodeSave dir
	if !DirAccess.dir_exists_absolute("user://Saves/Save "+str(Variables.current_save_file)+"/CodeSaves/"):
		var dir = DirAccess.open("user://Saves/Save "+str(Variables.current_save_file))
		dir.make_dir("CodeSaves")
		
func last_user_save():
	var file_path := "user://Saves/settings.bat"
	var file = FileAccess.open(file_path,FileAccess.WRITE)
	file.store_var(Variables.current_save_file)

func last_user_load():
	var file_path := "user://Saves/settings.bat"	
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path,FileAccess.READ)
		Variables.current_save_file = file.get_var(Variables.current_save_file)
		print(Variables.current_save_file)
	else:
		print("not exist")

func game_progress_save():
	# current level
	# 
	var file_path := "user://Saves/Save "+str(Variables.current_save_file)+"/gameProgress.bat"
	var file
	file = FileAccess.open(file_path,FileAccess.WRITE)
	file.store_var(Variables.level)
	
		
func game_progress_load():
	var file_path := "user://Saves/Save "+str(Variables.current_save_file)+"/gameProgress.bat"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path,FileAccess.READ)
		Variables.level = file.get_var(Variables.level)

func code_save():
	GameFiles.create_save_files()
	GameFiles.game_progress_save()
	
	if !FileAccess.file_exists("user://Saves/Save "+str(Variables.current_save_file)+"/CodeSaves/"+"Level "+str(Variables.level)):
		var dir = DirAccess.open("user://Saves/Save "+str(Variables.current_save_file)+"/CodeSaves/")
		dir.make_dir("Level "+str(Variables.level))
	for i in range(0,Variables.current_bot_count):
		
		var file = FileAccess.open("user://Saves/Save "+str(Variables.current_save_file)+"/CodeSaves/"+"Level "+str(Variables.level)+"/Bot "+str(i)+".txt", FileAccess.WRITE)
		file.store_string(Variables.codes[i])


func code_load():
	for i in range(0,Variables.current_bot_count):
		var content:String
		var bot_path := "user://Saves/Save "+str(Variables.current_save_file)+"/CodeSaves/"+"Level "+str(Variables.level)+"/Bot "+str(i)+".txt"
		if FileAccess.file_exists(bot_path):
			var file = FileAccess.open(bot_path, FileAccess.READ)
			content = file.get_as_text()
		else:
			content = ""
		Variables.codes[i] = content
