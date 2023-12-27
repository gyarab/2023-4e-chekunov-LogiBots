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
var debug_mode:bool = false
var test_case:int = 1
var max_test_case:int = 1

func _ready():
	
	Variables.current_screen = "level"
	lights_up()
	lvl_load(0)
	
	
	


func lights_up():
	var tween = get_tree().create_tween()
	$DirectionalLight2D.energy = 2
	tween.tween_property($DirectionalLight2D,'energy',0.45,4)
	tween.play()
	
	
func _on_run_button_pressed():
	
	if not level_end:
		if Variables.running:
			set_normal_mode()
			test_case = 1
		else:
			test_case = 1
			set_running_mode()
	
func _on_code_edit_text_changed():
	Variables.codes[Variables.current_code] =$CanvasLayer/interface/Panel/CodeEdit.text
	
func _on_bots_select_item_selected(index):
	Variables.current_code = index
	$CanvasLayer/interface/Panel/CodeEdit.text = Variables.codes[Variables.current_code]

func _on_tick_timer_timeout():
	
	Variables.tick = true

func set_running_mode():
	blind_random_numbers(false)
	GameFiles.code_save()
	Variables.running = true
	Variables.tick = true
	Variables.bots = $bots.get_children()
	$ErrorWindow.visible = false
	$HelpWindow.visible = false
	
		
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
						Variables.bots[i].code_lines[j] = Variables.bots[i].code_lines[j].erase(g)
						g-=1
					elif g > 0:
						if Variables.bots[i].code_lines[j][g-1] == " ":
							Variables.bots[i].code_lines[j] = Variables.bots[i].code_lines[j].erase(g)
							g-=2
				g+=1
				Variables.bots[i].code_lines[j] = Variables.bots[i].code_lines[j].rstrip(" ")
		Variables.bots[i].iterator = 0
		
		# adding functions and end functions
		var last_func = null
		for j in range(0,len(Variables.bots[i].code_lines)):
			var line = Variables.bots[i].code_lines[j]
			if len(line.rsplit(" ")) == 2:
				if line.rsplit(" ")[0] == "func":
					var second = line.rsplit(" ")[1]
					if second[len(second)-1] == ":":
						if Variables.bots[i].code_funcs.has(second.get_slice(":",0)):
							show_error(j,i,"duplicate function",line)
							return
						if last_func != null:
							show_error(j,i,"nested functions are NOT allowed!",line)
							return
						Variables.bots[i].code_funcs[second.get_slice(":",0)] = j
						last_func = second.get_slice(":",0)
						
			if len(line.rsplit(" ")) == 1:
				if line == "endfunc":
					if last_func != null:
						Variables.bots[i].code_end_funcs[last_func] = j
						last_func = null
					else:
						show_error(j,i,"no function to end",line)
						return
					
		# adding anchors
		for j in range(0,len(Variables.bots[i].code_lines)):
			var line = Variables.bots[i].code_lines[j]
			if len(line.rsplit(" ")) == 1:
				if line[len(line)-1] == ":":
					if Variables.bots[i].code_anchors.has(line.get_slice(":",0)):
						show_error(j,i,"duplicate anchor",line)
						return
					Variables.bots[i].code_anchors[line.get_slice(":",0)] = j
					
	$CanvasLayer/interface/Panel/RunButton.text = "Stop"
	$CanvasLayer/interface/Panel/CodeEdit.editable = false
	$CanvasLayer/interface/Panel/botsSelect.disabled = true
	$CanvasLayer/interface/Panel/HSlider.editable = false
	$TickTimer.start(Variables.tick_time)
	
func blind_random_numbers(blind:bool):
	
	for mic in $Microphones.get_children():
		if mic.number ==  -12057:
			mic.show_questionmark = blind
	
	for spk in $Speakers.get_children():
		if spk.show_questionmark:
			spk.show_questionmark = blind
	
func set_normal_mode():

	Variables.running = false
	Variables.tick = false
	lvl_load(0)
	blind_random_numbers(true)
	$TickTimer.stop()
	$CanvasLayer/interface/Panel/HSlider.editable = true
	$CanvasLayer/interface/Panel/RunButton.text = "Run"
	$CanvasLayer/interface/Panel/CodeEdit.editable = true
	$CanvasLayer/interface/Panel/botsSelect.disabled = false
	
func _process(_delta):
	#Bot Debug
	if debug_mode:
		# Color
		$CanvasLayer/interface/Panel/DebugButton.modulate = Color("ff9f1c")
		if not Variables.running:
			$CanvasLayer/interface/Panel/CodeEdit.size = Vector2(249,459)
			$CanvasLayer/interface/Panel/DebugRichTextLabel.visible = false
	else:
		$CanvasLayer/interface/Panel/DebugRichTextLabel.visible = false
		$CanvasLayer/interface/Panel/DebugButton.modulate = Color("ffffff")
	
	$CanvasLayer/interface/TestCase.text = "Test "+ str(test_case)+"/"+str(max_test_case)
	
	#debug
	#$DebugWindow/Text.text = str(Variables.map).replace("],","], \n")
	#$DebugWindow/Text.text = str(Variables.current_code)
	if Variables.running and Variables.tick and not Variables.sleep:
		#$DebugWindow/Text.text = str(bots[0].iterator)
		if debug_mode and Variables.running:
			$CanvasLayer/interface/Panel/CodeEdit.size = Vector2(249,459-200)
			# create text to show
			var debug_text = "[b]Debug[/b]\n"
			for bot in Variables.bots:
				if len(bot.code_lines)>0:
					debug_text+="[b][color=#11dfdf]Bot " + str(bot.id + 1) + ": [/color][/b][color=#FF9F1C]" + bot.code_lines[bot.iterator] + "[/color]\n"
				else:
					debug_text+="[b][color=#11dfdf]Bot " + str(bot.id + 1) + ": [/color][/b][color=#FF9F1C]" +"empty"+ "[/color]\n"
			$CanvasLayer/interface/Panel/DebugRichTextLabel.visible = true
			$CanvasLayer/interface/Panel/DebugRichTextLabel.text = debug_text
		else:
			$CanvasLayer/interface/Panel/CodeEdit.size = Vector2(249,459)
			$CanvasLayer/interface/Panel/DebugRichTextLabel.visible = false
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
	if level == 3:
		show_end_window($Microphones.get_child(0).number == $Speakers.get_child(0).number * 2)
	if level == 4:
		var spk_num = $Speakers.get_child(0).number
		var mic_num = $Microphones.get_child(0).number
		if spk_num<0 and mic_num == -1 or spk_num >0 and mic_num == 1:
			if test_case == max_test_case:
				show_end_window(true)
			else:
				test_case+=1
				lvl_load(step)
				set_running_mode()
		else:
			show_end_window(false)
	if level == 5:
		var spk_num1 = $Speakers.get_child(0).number
		var spk_num2 = $Speakers.get_child(1).number
		var mic_num = $Microphones.get_child(0).number
		if spk_num1+spk_num2>0 and mic_num == 1 or spk_num1+spk_num2==0 and mic_num == 0 or spk_num1+spk_num2<0 and mic_num == -1:
			if test_case == max_test_case:
				show_end_window(true)
			else:
				test_case+=1
				lvl_load(step)
				set_running_mode()
		else:
			show_end_window(false)
func show_end_window(win):
	test_case = 1
	level_end = true
	# Animation !
	
	
	var tween = get_tree().create_tween()
	$WinLoseWindow.position = Vector2($WinLoseWindow.position.x-250,$WinLoseWindow.position.y-150) 
	$WinLoseWindow.visible = true
	$WinLoseWindow.size = Vector2(0,0)
	tween.tween_property($WinLoseWindow, "size", Vector2i(500,0), 0.5)
	tween.play()
	tween.tween_property($WinLoseWindow, "size", Vector2i(500,300), 0.75)
	tween.play()
	
	$WinLoseWindow/Panel/NextLevelButton.visible = win
	if win:
		$WinLoseWindow.title = ["Great Job!","Great!","Well done!"].pick_random()
		$WinLoseWindow/Panel/InfoLabel.text = "You complete level with "+str(step)+ " steps!\nis it possible to do it better?"
		
	else:
		$WinLoseWindow.title = ["Opsie wopsie..","Unlucky","Try more","Bad luck!"].pick_random()
		$WinLoseWindow/Panel/InfoLabel.text = "You need to fix it!"
	set_normal_mode() #FLAG
	
func bot_porcess(bot,i):
			# line
			var line:String = bot.code_lines[bot.iterator]
			
			# one word commands
			# anchor
			if len(line.rsplit(" ")) == 1:
				if line[len(line)-1] == ":":
					bot.iterator_update()
			# one word
				if line == "swap" or line == "save":
					bot.emit_signal(line)
				if line == "return" or line == "endfunc":
					bot.emit_signal("return_signal")
				
				if bot.code_funcs.has(line):
					bot.emit_signal("jump_to_func",line)
			# func skip
			line = bot.code_lines[bot.iterator]
			while true:
				if len(line.rsplit(" ")) == 2 and line.rsplit(" ")[0] == "func":
					if bot.code_funcs.has(line.rsplit(" ")[1].get_slice(":",0)):
						bot.skip_func(line.rsplit(" ")[1].get_slice(":",0))
					else:
						show_error(bot.iterator,i,"wrong argument",line)
						return
				else:
					break
					
			
			# two word commands
			if len(line.rsplit(" ")) >= 2 and len(line.rsplit(" ")) <= 4:
				
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
						if first == "move":
							var third = 1
							if len(line.rsplit(" ")) == 3:
								if line.rsplit(" ")[2].to_int() > 0:
									third = line.rsplit(" ")[2].to_int()
								elif line.rsplit(" ")[2] == "active":
									if bot.active > 0:
										third = bot.active
									elif bot.active == 0:
										bot.iterator_update()
										return
									else:
										show_error(bot.iterator,i,"number is not positive","active")
										return
								elif line.rsplit(" ")[2] == "mem":
									if bot.memory > 0:
										third = bot.memory
									elif bot.memory == 0:
										bot.iterator_update()
										return
									else:
										show_error(bot.iterator,i,"number is not positive","memory")
										return
								elif line.rsplit(" ")[2].to_int() == 0:
									bot.iterator_update()
									return
								else:
									show_error(bot.iterator,i,"wrong number",line.rsplit(" ")[2])
									return
							elif  len(line.rsplit(" ")) > 3:
								show_error(bot.iterator,i,"more than 3 arguments",line)
								return
							bot.emit_signal("move",second,third)
							return
						bot.emit_signal(first,second)
						return
					else:
						show_error(bot.iterator,i,"wrong argument",second)
						return
				# add sub
				elif first == "add" or first == "sub":
					if second.to_int() != null or second == "active" or second == "pasive":
						var num:int
						if second == "active":
							num = bot.active
						elif second == "mem":
							num = bot.memory
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

func lvl_load(_step):
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
	$CanvasLayer/interface/Panel/botsSelect.clear()
	$CanvasLayer/interface/Description.text = Variables.description
	$CanvasLayer/interface/Title.text = "level "+str(Variables.level)+" - "+Variables.title
	# step
	step = _step
	# Test cases
	if Variables.level == 4:
		max_test_case = 2
	elif Variables.level == 5:
		max_test_case = 3
		
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

	for mic in LevelClass.mics:
		var microphone = microphone_scene.instantiate()
		microphone.pos = Vector2(mic[0].x,mic[0].y)
		if mic[1] == -10000:
			microphone.show_questionmark = true
			microphone.number = randi_range(-99,99)
		elif mic[1] == -10001:
			microphone.show_questionmark = true
			microphone.number = randi_range(1,99)
		else:
			microphone.number = mic[1]
		$Microphones.add_child(microphone)
		
	for spkr in LevelClass.speakers:
		var speaker = speaker_scene.instantiate()
		speaker.pos = Vector2(spkr[0].x,spkr[0].y)
		if spkr[1] == -10000:
			speaker.show_questionmark = true
			speaker.number = randi_range(-99,99)
		elif spkr[1] == -10001:
			speaker.show_questionmark = true
			speaker.number = randi_range(1,99)
		else:
			speaker.number = spkr[1]
		$Speakers.add_child(speaker)
	
	for plt in Variables.plates:
		var plate = plate_scene.instantiate()
		plate.pos = Vector2(plt.x,plt.y)
		$Plates.add_child(plate)
	
	#levels test cases
	if Variables.level == 4:
			if test_case == 1:
				$Speakers.get_child(0).number = randi_range(1,99)
			elif test_case == 2:
				$Speakers.get_child(0).number = randi_range(-99,-1)
	
	if Variables.level == 5:
			if test_case == 1:
				var first = randi_range(-99,99)
				var second = randi_range(-99,99)
				print("prvni!")
				while (first+second<0):
					first = randi_range(-99,99)
					second = randi_range(-99,99)
				print(first)
				print(second)
				$Speakers.get_child(0).number = first
				$Speakers.get_child(1).number = second
				
			elif test_case == 2:
				var first = randi_range(-99,99)
				var second = -first
				
				$Speakers.get_child(0).number = first
				$Speakers.get_child(1).number = second
			elif test_case == 3:
				var first:int = randi_range(-99,99)
				var second:int = randi_range(-99,99)
				while (first+second>0):
					first = randi_range(-99,99)
					second = randi_range(-99,99)
				$Speakers.get_child(0).number = first
				$Speakers.get_child(1).number = second
		
	
	#Variables.map = Variables.lvl_maps
	# bots update
	bot_count = len($bots.get_children())
	Variables.current_bot_count = bot_count
	Variables.bots = $bots.get_children()
	Variables.mics = $Microphones.get_children()
	Variables.speakers = $Speakers.get_children()
	
	# code files
	for i in range(0,bot_count):
		$CanvasLayer/interface/Panel/botsSelect.add_item("Bot "+str(i+1))
		Variables.codes.append("")
	
	# Saves
	GameFiles.code_load()
	$CanvasLayer/interface/Panel/botsSelect.select(Variables.current_code)
	$CanvasLayer/interface/Panel/CodeEdit.text = Variables.codes[Variables.current_code]
	
func _on_h_slider_drag_ended(_value_changed):
	Variables.tick_time = 10/$CanvasLayer/interface/Panel/HSlider.value
	


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
	Variables.first_look = true
	if GameFiles.data["latest_level"]<Variables.level:
		GameFiles.data["latest_level"] = Variables.level
	GameFiles.data["current_level"] =Variables.level
	LevelClass.load_level(Variables.level)
	$TileMap.emit_signal("floor_reset")
	lights_up()
	set_normal_mode()
	
	


func _on_help_window_close_requested():
	$HelpWindow.visible = false

func _on_help_button_pressed():
	$HelpWindow.visible = !$HelpWindow.visible


func _on_debug_button_pressed():
	debug_mode = !debug_mode
