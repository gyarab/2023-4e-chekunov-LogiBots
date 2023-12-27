extends Node2D
"""
1 - bot
2 - box
3 - speaker red
4 - microphone green
5 - paddle
"""
# Called when the node enters the scene tree for the first time.
func _ready():
	
	show_object(Variables.object_to_show)
	
	

func clear_show():
	for node in $Show_object.get_children():
		node.queue_free()

func show_object(object:int):
	clear_show()
	match object:
		
		1:
			var bot_scene = preload("res://Scenes/bot/bot.tscn")
			var bot = bot_scene.instantiate()
			bot.pos = Vector2(5,3)
			$Show_object.add_child(bot)
			$Control/TextPanel/RichTextLabel.text = "Bot 1.0 \n Main character in this game.\n (For more info see 'Docs')\n :)"
		2:
			
			var box_scene = preload("res://Scenes/objects/box.tscn")
			var box = box_scene.instantiate()
			box.pos = Vector2(5,3)
			$Show_object.add_child(box)
			$Control/TextPanel/RichTextLabel.text = "Box\n Simple obstacle"
		3:
			var speaker_scene = preload("res://Scenes/objects/speaker.tscn")
			var spk = speaker_scene.instantiate()
			spk.pos = Vector2(5,3)
			spk.number = randi_range(1,99)
			$Show_object.add_child(spk)
			$Control/TextPanel/RichTextLabel.text = "Speaker \n	Box with random number.\n	Bot CAN'T say anything to it."
		4:
			var microphone_scene = preload("res://Scenes/objects/microphone.tscn")
			var mic = microphone_scene.instantiate()
			mic.pos = Vector2(5,3)
			mic.number = randi_range(1,99)
			$Show_object.add_child(mic)
			$Control/TextPanel/RichTextLabel.text = "Microphone \n	Box with random number.\n	Bot CAN say anything to it."
		5:
			var plate_scene = preload("res://Scenes/objects/plate.tscn")
			var plate = plate_scene.instantiate()
			plate.pos = Vector2(5,3)
			$Show_object.add_child(plate)
			$Control/TextPanel/RichTextLabel.text = "Plate \n	Simple object. :)"
	show_text()
	
func show_text():
	$Control/TextPanel/RichTextLabel.visible_ratio = 0
	var tween = get_tree().create_tween()
	var animation_time = 2
	tween.tween_property($Control/TextPanel/RichTextLabel,"visible_ratio", 1,animation_time)
	tween.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_back_pressed():
	if Variables.current_screen == "level":
		get_tree().change_scene_to_file("res://Scenes/level/level.tscn")
		LevelClass.load_level(Variables.level)
	else:
		get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")

func _on_button_next_pressed():
	Variables.object_to_show += 1
	if Variables.object_to_show == 6:
		Variables.object_to_show = 1
	show_object(Variables.object_to_show)


func _on_button_prev_pressed():
	Variables.object_to_show -= 1
	if Variables.object_to_show == 0:
		Variables.object_to_show = 5
	show_object(Variables.object_to_show)
