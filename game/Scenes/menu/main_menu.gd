extends Node2D

var can_send_to_level:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Control/Audio/Panel/HSlider.value = Variables.volume
	
	if Variables.volume == 69:
		var tween = get_tree().create_tween()
		$Control/Audio/Panel/HSlider.value = 0
		tween.tween_property($Control/Audio/Panel/HSlider,"value",50,3)
		
		tween.play()
	
	Variables.current_screen = "menu"
	
	GameFiles.last_user_load()
	GameFiles.game_progress_load()
	
	if Variables.current_save_file != -1:
		can_send_to_level = true
		$Control/ContinueButton.text = "CONTINUE \n level "+str(Variables.level)

func play_click():
	$AudioStreamPlayer.stream = load("res://music/click.mp3")
	$AudioStreamPlayer.play()
	
func _process(delta):
	$AudioStreamPlayer.volume_db = 20 * (Variables.volume/100.0)-20
func _on_quit_button_pressed():
	get_tree().quit()

func _on_continue_button_pressed():
	if can_send_to_level:
		play_click()
		get_tree().change_scene_to_file("res://Scenes/level/level.tscn")
		LevelClass.load_level(Variables.level)

func _on_new_game_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/save_select.tscn")


func _on_selsect_level_button_pressed():
	if can_send_to_level:
		
		get_tree().change_scene_to_file("res://Scenes/menu/level_select.tscn")


func _on_object_help_button_pressed():
	Variables.object_to_show = 1
	get_tree().change_scene_to_file("res://Scenes/level/object_intro.tscn")

func _on_help_window_close_requested():
	$HelpWindow.visible = false

func _on_docs_button_pressed():
	$HelpWindow.visible = !$HelpWindow.visible


func _on_online_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/online_menu.tscn")


func _on_h_slider_value_changed(value):
	Variables.volume = value
	
