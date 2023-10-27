extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = DirAccess.open("res://levels")
	var levels = dir.get_files()
	for level in range(0,len(levels)):
		var lvl_button = Button.new()
		lvl_button.text = "level "+ str(level+1)
		lvl_button.button_down.connect(_change_level.bind(lvl_button))
		lvl_button.custom_minimum_size = Vector2(120,100)
		$Control/GridContainer.add_child(lvl_button)


func _change_level(btn):
	get_tree().change_scene_to_file("res://Scenes/level/level.tscn")
	Variables.level = int(btn.text.split(" ",1)[1])
	LevelClass.load_level(Variables.level)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass