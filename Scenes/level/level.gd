extends Node2D


signal all_bots_ready
#bots
var bot_count:int
var bot_scene = preload("res://Scenes/bot/bot.tscn")
var box_scene = preload("res://Scenes/objects/box.tscn")
var microphone_scene = preload("res://Scenes/objects/microphone.tscn")
var speaker_scene = preload("res://Scenes/objects/speaker.tscn")
var plate_scene = preload("res://Scenes/objects/plate.tscn")
var step:int = 0
var level_end:bool = false
var is_code_hide:bool = false


func _ready():
	lvl_load()

func _on_run_button_pressed():
	if not level_end:
		if Variables.running:
			set_normal_mode()
		else:
			set_running_mode()
	
func _on_code_edit_text_changed():
	Variables.codes[Variables.current_code] =$interface/Panel/CodeEdit.text
	
func _on_bots_select_item_selected(index):
	Variables.current_code = index
	$interface/Panel/CodeEdit.text = Variables.codes[Variables.current_code]

func _on_tick_timer_timeout():
	
	Variables.tick = true

func set_running_mode():
	GameFiles.code_save()
	Variables.running = true
	Variables.tick = true
	Variables.bots = $bots.get_children()
	$ErrorWindow.visible = false
	for i in range(0,bot_count):
		Variables.bots[i].id = i
		if len(Variables.codes[i].rsplit("\n", false)) == 0:
			Variables.bots[i].available = false
		else:
			Variables.bots[i].available = true
		Variables.bots[i].code_lines =(Variables.codes[i].rsplit("\n", false))
		# white space editor
		for j in range(0,len(Variables.bots[i].code_lines)):
			var g = 0
			while(g<len(Variables.bots[i].code_lines[j])):
				if Variables.bots[i].code_lines[j][g] == " ":
					if g == 0 or g ==len(Variables.bots[i].code_lines[j])-1:
						print(Variables.bots[i].code_lines[j][g])
						Variables.bots[i].code_lines[j] = Variables.bots[i].code_lines[j].erase(g)
						g-=1
					elif g > 0:
						if Variables.bots[i].code_lines[j][g-1] == " ":
							Variables.bots[i].code_lines[j] = Variables.bots[i].code_lines[j].erase(g)
							g-=2
				g+=1
				Variables.bots[i].code_lines[j] = Variables.bots[i].code_lines[j].rstrip(" ")
		Variables.bots[i].iterator = 0
		print(Variables.bots[i].code_lines)
		# adding anchors
		for j  in range(0,len(Variables.bots[i].code_lines)):
			var line = Variables.bots[i].code_lines[j]
			if len(line.rsplit(" ")) == 1:
				if line[len(line)-1] == ":":
					Variables.bots[i].code_anchors[line.get_slice(":",0)] = j
				else:
					show_error(j,i,"wrong anchor",line)
					return
					
	$interface/Panel/RunButton.text = "Stop"
	$interface/Panel/CodeEdit.editable = false
	$interface/Panel/botsSelect.disabled = true
	$interface/Panel/HSlider.editable = false
	$TickTimer.start(Variables.tick_time)
	
func set_normal_mode():
	Variables.running = false
	Variables.tick = false
	lvl_load()
	$TickTimer.stop()
	$interface/Panel/HSlider.editable = true
	$interface/Panel/RunButton.text = "Run"
	$interface/Panel/CodeEdit.editable = true
	$interface/Panel/botsSelect.disabled = false
	
func _process(delta):
	# selected bot light
	
	#debug
	#$DebugWindow/Text.text = str(Variables.map).replace("],","], \n")
	$DebugWindow/Text.text = str(Variables.level)
	if Variables.running and Variables.tick and not Variables.sleep:
		#$DebugWindow/Text.text = str(bots[0].iterator)
		for i in range(0,Variables.current_bot_count):
			
			if not Variables.running:
				break
			if not Variables.bots[i].available:
				continue
			bot_porcess(Variables.bots[i],i)
		
		for bot in Variables.hoping_bots:
			bot_porcess(bot,bot.id)
			Variables.hoping_bots.erase(bot)
		Variables.hoping_bots = []
		emit_signal("all_bots_ready")
		if not level_end:
			step += 1
			print("tick! "+ str(step))
		Variables.tick = false
		Variables.sleep = true
		
	var all_finished = true
	var end:bool = true
	
	for bot in Variables.bots:
		
		if bot.is_doing:
			all_finished = false
		if bot.available:
			end = false
	if all_finished:
		Variables.sleep = false
		
	if end:
		check_level(Variables.level)

func check_level(level):
	if level == 1:
		show_end_window(Variables.map[10][5] == 1)
	if level == 2:
		show_end_window(Variables.map[6][3] == 1 && Variables.map[10][1] == 1)
func  show_end_window(win):
	level_end = true
	$WinLoseWindow.visible = true
	$WinLoseWindow/Panel/NextLevelButton.visible = win
	if win:
		$WinLoseWindow/Panel/WinLoseLabel.text = "Great Job!"
		$WinLoseWindow/Panel/InfoLabel.text = "You complete level with "+str(step)+ " steps! \n is it possible to do it better?"
		
	else:
		$WinLoseWindow/Panel/WinLoseLabel.text = "Opsie wopsie.."
		$WinLoseWindow/Panel/InfoLabel.text = "You need to fix it!"

func bot_porcess(bot,i):
			# line
			var lns = bot.code_lines
			var ite = bot.iterator
			var line:String = bot.code_lines[bot.iterator]
			
			# one word commands
			# anchor
			if len(line.rsplit(" ")) == 1:
				if line[len(line)-1] == ":":
					bot.iterator_update()
				if line == "swap" or line == "save":
					bot.emit_signal(line)
					print("zloba!")
			# two word commands
			if len(line.rsplit(" ")) == 2:
				
				var first:String = line.rsplit(" ")[0]
				var second:String = "no argument"
				if len(line.rsplit(" ")) > 1:
					second = line.rsplit(" ")[1]
				# jumps
				if first == "jump" or first == "jumpz" or first == "jumpl" or first == "jumpg":
					if bot.code_anchors.has(second):
						bot.emit_signal("jump",first,second)
						return
					else:
						show_error(bot.iterator,i,"wrong anchor",second)
						return
				# move
				if first == "move" or first == "say" or first == "listen":
					if second == "left" or second == "right" or second == "up" or second == "down":
						bot.emit_signal(first,second)
						return
					else:
						show_error(bot.iterator,i,"wrong argument",second)
						return
				# add sub
				elif first == "add" or first == "sub":
					if second.to_int() != null or second == "active":
						var num:int
						if second == "active":
							num = bot.active
						else:
							num = second.to_int()
						if first == "sub":
							num *= -1
						bot.emit_signal("add",num)
						return
					else:
						show_error(bot.iterator,i,"wrong number",second)
						return
				else:
					show_error(bot.iterator,i,"wrong command",line)
					return
				
			elif  len(line.rsplit(" ")) > 2:
				show_error(bot.iterator,i,"too many arguments",line)
				return
func show_error(line_number:int,bot_number:int,error_name:String,text:String):
	
	set_normal_mode()
	$ErrorWindow/Label.text ="'"+error_name+"'\n at line "+str(line_number+1)+"\n in bot "+str(bot_number+1)+", caused by '"+text+"'"
	$ErrorWindow.visible = true

func _on_error_button_pressed():
	$ErrorWindow.visible = false

func lvl_load():
	# removing all previous bots
	if len($bots.get_children()) >= 1:
		for bot in $bots.get_children():
			$bots.remove_child(bot)
			bot.self_destroy()
		#$bots.get_children() = null
		pass
	if len($boxes.get_children()) >= 1:
		for box in $boxes.get_children():
			$boxes.remove_child(box)
			box.queue_free()
	if len($Microphones.get_children()) >= 1:
		for mic in $Microphones.get_children():
			$Microphones.remove_child(mic)
			mic.queue_free()
	if len($Speakers.get_children()) >= 1:
		for spk in $Speakers.get_children():
			$Speakers.remove_child(spk)
			spk.queue_free()
			
	if len($Plates.get_children()) >= 1:
		for plate in $Plates.get_children():
			$Plates.remove_child(plate)
			plate.queue_free()
			
	Variables.hoping_bots = []
	Variables.bot_ids = 0
	Variables.mics = []
	Variables.speakers = []
	# clear all buttons
	$interface/Panel/botsSelect.clear()
	$interface/Description.text = Variables.description
	$interface/Title.text = "level "+str(Variables.level)+" - "+Variables.title
	# step
	step = 0
	
	for i in range(0,16):
		for j in range(0,10):
			# updating map
			Variables.map[i][j] = Variables.lvl_maps[i][j]
			# adding player
			if Variables.lvl_maps[i][j] == 1:
				var bot = bot_scene.instantiate()
				bot.pos = Vector2(i,j)
				bot.update_position()
				$bots.add_child(bot)
			# adding objects
			# box
			if Variables.lvl_maps[i][j] == 2:
				var box = box_scene.instantiate()
				box.pos = Vector2(i,j)
				$boxes.add_child(box)
			# microphones
			if Variables.lvl_maps[i][j] == 3:
				var microphone = microphone_scene.instantiate()
				microphone.pos = Vector2(i,j)
				microphone.number = 24
				$Microphones.add_child(microphone)
			# speaker
			if Variables.lvl_maps[i][j] == 4:
				var speaker = speaker_scene.instantiate()
				speaker.pos = Vector2(i,j)
				speaker.number = 120
				$Speakers.add_child(speaker)
				
	print(Variables.plates)
	for plt in Variables.plates:
		var plate = plate_scene.instantiate()
		plate.pos = Vector2(plt.x,plt.y)
		$Plates.add_child(plate)
		print("pridal!")
		
	#Variables.map = Variables.lvl_maps
	# bots update
	bot_count = len($bots.get_children())
	Variables.current_bot_count = bot_count
	Variables.bots = $bots.get_children()
	Variables.mics = $Microphones.get_children()
	Variables.speakers = $Speakers.get_children()
	
	# code files
	for i in range(0,bot_count):
		$interface/Panel/botsSelect.add_item("Bot "+str(i+1))
		Variables.codes.append("")
	
	# Saves
	GameFiles.code_load()
	$interface/Panel/botsSelect.select(Variables.current_code)
	$interface/Panel/CodeEdit.text = Variables.codes[Variables.current_code]


func _on_h_slider_drag_ended(value_changed):
	Variables.tick_time = 10/$interface/Panel/HSlider.value



func _on_exit_button_pressed():
	get_tree().quit()


func _on_full_screen_button_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2(1280,704))
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_restart_button_pressed():
	$WinLoseWindow.visible = false
	level_end = false
	set_normal_mode()


func _on_exit_to_menu_button_pressed():
	$WinLoseWindow.visible = false
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")


func _on_next_level_button_pressed():
	$WinLoseWindow.visible = false
	level_end = false
	Variables.level+=1
	GameFiles.data["current_level"] = Variables.level
	if GameFiles.data.get("latest_level") < Variables.level:
		GameFiles.data["latest_level"] = Variables.level
	LevelClass.load_level(Variables.level)
	set_normal_mode()
	GameFiles.code_save()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")
