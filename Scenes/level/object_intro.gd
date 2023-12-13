extends Node2D

var object_to_presend = -1
"""
1 - bot
2 - box
3 - speaker red
4 - microphone green
5 - paddle
"""
# Called when the node enters the scene tree for the first time.
func _ready():
	var box_scene = preload("res://Scenes/objects/box.tscn")
	var microphone_scene = preload("res://Scenes/objects/microphone.tscn")
	var speaker_scene = preload("res://Scenes/objects/speaker.tscn")
	var plate_scene = preload("res://Scenes/objects/plate.tscn")
	show_object(Variables.object_to_show)
	var tween = get_tree().create_tween()
	var animation_time = len($Control/TextPanel/RichTextLabel.text)/30
	
	tween.tween_property($Control/TextPanel/RichTextLabel,"visible_ratio", 1,animation_time)
	tween.play()
	
func show_object(object:int):
	object = 1
	match object:
		
		1:
			var bot_scene = preload("res://Scenes/bot/bot.tscn")
			var bot = bot_scene.instantiate()
			bot.pos = Vector2(5,3)
			add_child(bot)
			
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			pass
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
