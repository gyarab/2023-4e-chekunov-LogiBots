extends Node
# Scripts that iteracts with file system, saving and loading
var data:Dictionary

func create_save_files():
	if !DirAccess.dir_exists_absolute("user://Saves"):
		var dir = DirAccess.open("user://")
		dir.make_dir("Saves")
		
	if !DirAccess.dir_exists_absolute("user://Saves/Save "+str(Variables.current_save_file)):
		var current_save_dir = DirAccess.open("user://Saves")
		current_save_dir.make_dir("Save "+str(Variables.current_save_file))
	
	if !DirAccess.dir_exists_absolute("user://Saves/online"):
		var dir = DirAccess.open("user://Saves")
		dir.make_dir("online")
		randomize()
		var characters = 'abcdefghijklmnopqrstuvwxyz1234567890*!@#$%^&*'
		var key:String = "LogiKey: "
		for i in range(512):
			key+= characters[randi_range(0,len(characters)-1)]
		
		var file_path := "user://Saves/online/.secret.key"
		var file = FileAccess.open(file_path,FileAccess.WRITE)
		file.store_var(key)
		file.close()
		
		file_path = "user://Saves/online/.username.txt"
		file = FileAccess.open(file_path,FileAccess.WRITE)
		file.store_var("Anonymous")
		file.close()
		
		file_path = "user://Saves/online/.points.bat"
		file = FileAccess.open(file_path,FileAccess.WRITE)
		file.store_var(Variables.points)
		file.close()
	
	#CodeSave dir
	if !DirAccess.dir_exists_absolute("user://Saves/Save "+str(Variables.current_save_file)+"/CodeSaves/"):
		var dir = DirAccess.open("user://Saves/Save "+str(Variables.current_save_file))
		dir.make_dir("CodeSaves")
		

func load_points():
	var file_path = "user://Saves/online/.points.bat"
	var file = FileAccess.open(file_path,FileAccess.READ)
	Variables.points = file.get_var(Variables.points)
	file.close()

func save_points():
	var points:= 0
	var points_per_level 
	for i in range(data["latest_level"]):
		points += (i+1) * 50
		
	
	for i in data["level_code_lines"]:
		if i != INF:
			points-=i
			
	for i in data["level_tick_count"]:
		if i != INF:
			points-=i
	
	
	Variables.points = points
	var file_path = "user://Saves/online/.points.bat"
	var file = FileAccess.open(file_path,FileAccess.WRITE)
	file.store_var(Variables.points)
	file.close()



		
func last_user_save():
	var file_path := "user://Saves/settings.bat"
	var file = FileAccess.open(file_path,FileAccess.WRITE)
	file.store_var(Variables.current_save_file)
	file.close()

func last_user_load():
	var file_path := "user://Saves/settings.bat"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path,FileAccess.READ)
		Variables.current_save_file = file.get_var(Variables.current_save_file)
		file.close()

func game_progress_save(new:bool):
	# current level
	# 
	var file_path := "user://Saves/Save "+str(Variables.current_save_file)+"/gameProgress.bat"
	var file = FileAccess.open(file_path,FileAccess.WRITE)
	if new:
		# reset CodeSaves
		# Deleting Saves
		remove_files_in_folder("user://Saves/Save "+str(Variables.current_save_file)+"/CodeSaves/")
		DirAccess.remove_absolute("user://Saves/Save "+str(Variables.current_save_file)+"/CodeSaves/")
		DirAccess.remove_absolute(file_path)
		file = FileAccess.open(file_path,FileAccess.WRITE)
		# reseting vars
		var lines := []
		lines.resize(20)
		lines.fill(INF)
		var ticks := []
		ticks.resize(20)
		ticks.fill(INF)
		
		data = {
		"latest_level": 1,
		"current_level":1,
		"level_code_lines":lines,
		"level_tick_count":ticks,
		}
		Variables.level = 1
	file.store_var(data)
	file.close()


func remove_files_in_folder(folder_path):
	var dir = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		while true:
			var file = dir.get_next()
			if file == "":
				break
			var file_path = folder_path+"/"+file
			if dir.current_is_dir():
				remove_files_in_folder(file_path)
			else:
				dir.remove(file_path)
		dir.list_dir_end()
	else:
		pass
func game_progress_load():
	var file_path := "user://Saves/Save "+str(Variables.current_save_file)+"/gameProgress.bat"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path,FileAccess.READ)
		data = file.get_var()
		Variables.level = data["current_level"]
		file.close()

func code_save():
	GameFiles.create_save_files()
	GameFiles.game_progress_save(false)
	
	if !FileAccess.file_exists("user://Saves/Save "+str(Variables.current_save_file)+"/CodeSaves/"+"Level "+str(Variables.level)):
		var dir = DirAccess.open("user://Saves/Save "+str(Variables.current_save_file)+"/CodeSaves/")
		dir.make_dir("Level "+str(Variables.level))
	for i in range(0,Variables.current_bot_count):
		
		var file = FileAccess.open("user://Saves/Save "+str(Variables.current_save_file)+"/CodeSaves/"+"Level "+str(Variables.level)+"/Bot "+str(i)+".txt", FileAccess.WRITE)
		file.store_string(Variables.codes[i])
		file.close()

func code_load():
	for i in range(0,Variables.current_bot_count):
		var content:String
		var bot_path := "user://Saves/Save "+str(Variables.current_save_file)+"/CodeSaves/"+"Level "+str(Variables.level)+"/Bot "+str(i)+".txt"
		if FileAccess.file_exists(bot_path):
			var file = FileAccess.open(bot_path, FileAccess.READ)
			content = file.get_as_text()
			file.close()
		else:
			content = ""
		Variables.codes[i] = content
		
