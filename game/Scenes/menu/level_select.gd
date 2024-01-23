extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$AudioStreamPlayer.volume_db = 20 * (Variables.volume/100.0)-20-10
	
	var dir = DirAccess.open("user://levels")
	var levels = dir.get_files()
	for level in range(0,len(levels)):
		var lvl_button = Button.new()
		if level == 17:
			lvl_button.text = "sandbox"
		elif level >15 and level != 17:
			if level<17:
				lvl_button.text = "Bonus\nlevel "+ str((level+1)%17+1)
			else:
				lvl_button.text = "Bonus\nlevel "+ str((level+1)%17)
		else:
			lvl_button.text = "level "+ str(level+1)
		lvl_button.button_down.connect(_change_level.bind(lvl_button))
		lvl_button.custom_minimum_size = Vector2(120,100)
		if level == 17:
			lvl_button.disabled = false
		else:
			lvl_button.disabled = level > GameFiles.data["latest_level"] - 1
		# colors
		if level <5:
			var sb_normal = $Control/BackButton.get_theme_stylebox("normal").duplicate()
			var sb_hover = $Control/BackButton.get_theme_stylebox("normal").duplicate()
			sb_normal.bg_color = Color("009400")
			sb_hover.bg_color = Color("003c00")
			lvl_button.add_theme_color_override("font_color",Color(0,0,0))
			lvl_button.add_theme_stylebox_override("normal", sb_normal)
			lvl_button.add_theme_stylebox_override("hover", sb_hover)
		if level >=5 and level <= 9:
			var sb_normal = $Control/BackButton.get_theme_stylebox("normal").duplicate()
			var sb_hover = $Control/BackButton.get_theme_stylebox("normal").duplicate()
			sb_normal.bg_color = Color("FF8C00")
			sb_hover.bg_color = Color("5e3400")
			lvl_button.add_theme_color_override("font_color",Color(0,0,0))
			lvl_button.add_theme_stylebox_override("normal", sb_normal)
			lvl_button.add_theme_stylebox_override("hover", sb_hover)
		if level >=10 and level <=15:
			var sb_normal = $Control/BackButton.get_theme_stylebox("normal").duplicate()
			var sb_hover = $Control/BackButton.get_theme_stylebox("normal").duplicate()
			sb_normal.bg_color = Color("cc0000")
			sb_hover.bg_color = Color("610000")
			lvl_button.add_theme_color_override("font_color",Color(0,0,0))
			lvl_button.add_theme_stylebox_override("normal", sb_normal)
			lvl_button.add_theme_stylebox_override("hover", sb_hover)
		if level >=16:
			var sb_normal = $Control/BackButton.get_theme_stylebox("normal").duplicate()
			var sb_hover = $Control/BackButton.get_theme_stylebox("normal").duplicate()
			sb_normal.bg_color = Color("#FFD700")
			sb_hover.bg_color = Color("857100")
			lvl_button.add_theme_color_override("font_color",Color(0,0,0))
			lvl_button.add_theme_stylebox_override("normal", sb_normal)
			lvl_button.add_theme_stylebox_override("hover", sb_hover)
	
		$Control/GridContainer.add_child(lvl_button)


func _change_level(btn):
	
	if btn.text =="sandbox":
		Variables.level =18
	else:
		Variables.level = int(btn.text.split(" ",1)[1])
	GameFiles.data["current_level"] =Variables.level
	LevelClass.load_level(Variables.level)
	get_tree().change_scene_to_file("res://Scenes/level/level.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")
