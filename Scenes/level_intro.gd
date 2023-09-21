extends Node2D


var running:bool = false
signal all_bots_ready
#bots
var bot_count:int
var bot_scene = preload("res://Scenes/bot/bot.tscn")

func _ready():
	lvl_load()
	
	
func _on_save_button_pressed():
	Variables.code_save()

func _on_run_button_pressed():
	if running:
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
	print("tick!")

func set_running_mode():
	Variables.code_save()
	running = true
	Variables.tick = true
	Variables.bots = $bots.get_children()
	for i in range(0,bot_count):
		Variables.bots[i].id = i
		if len(Variables.codes[i].rsplit("\n", false)) == 0:
			Variables.bots[i].available = false
		else:
			Variables.bots[i].available = true
		Variables.bots[i].code_lines =(Variables.codes[i].rsplit("\n", false))
		Variables.bots[i].iterator = 0
	$interface/RunButton.text = "Stop"
	$interface/Panel/CodeEdit.editable = false
	$interface/Panel/botsSelect.disabled = true
	$interface/SaveButton.disabled = true
	$TickTimer.start(Variables.tick_time)
	
func set_normal_mode():
	lvl_load()
	running = false
	Variables.tick = false
	$TickTimer.stop()
	$interface/RunButton.text = "Run"
	$interface/Panel/CodeEdit.editable = true
	$interface/Panel/botsSelect.disabled = false
	$interface/SaveButton.disabled = false
	
func _process(delta):
	#debug
	#$DebugWindow/Text.text = str(Variables.map).replace("],","], \n")
	$DebugWindow/Text.text = str(Variables.hoping_bots)
	if running and Variables.tick and not Variables.sleep:
		#$DebugWindow/Text.text = str(bots[0].iterator)
		for i in range(0,Variables.current_bot_count):
			
			if not Variables.bots[i].available:
				continue
			bot_porcess(Variables.bots[i],i)
		
		
		for bot in Variables.hoping_bots:
			bot_porcess(bot,bot.id)
			Variables.hoping_bots.erase(bot)
		Variables.hoping_bots = []
		emit_signal("all_bots_ready")
		Variables.tick = false
		Variables.sleep = true
		
	var all_finished = true
	for bot in Variables.bots:
		if bot.is_doing:
			all_finished = false
	if all_finished:
		Variables.sleep = false
		
	
func bot_porcess(bot,i):
			# check if bot is available
			
			var line:String = bot.code_lines[bot.iterator]
			if len(line.rsplit(" ")) <=2:
				# move
				var first:String = line.rsplit(" ")[0]
				var second:String = ""
				if len(line.rsplit(" ")) > 1:
					second = line.rsplit(" ")[1]
				
				if first == "move" or first == "say" or first == "listen":
					if second == "left" or second == "right" or second == "up" or second == "down":
						bot.emit_signal("move",second)
						pass
					else:
						show_error(bot.iterator,i,"wrong argument",second)
				elif first == "add" or first == "sub":
					if second.to_int() != null:
						# z bota iterator_update(i)
						# todo! emit signal
						pass
					else:
						show_error(bot.iterator,i,"wrong number",second)
				else:
					show_error(bot.iterator,i,"wrong command",line)
				
			else:
				show_error(bot.iterator,i,"too many arguments",line)
				
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
		
	Variables.hoping_bots = []
	# clear all buttons	
	$interface/Panel/botsSelect.clear()
	
	
	var lvl:int = Variables.level
	for i in range(0,20):
		for j in range(0,11):
			# adding player
			if Variables.lvl_maps[i][j] == 1:
				var bot = bot_scene.instantiate()
				bot.pos = Vector2(i,j)
				bot.update_position()
				$bots.add_child(bot)
	
	# bots update
	bot_count = len($bots.get_children())
	Variables.current_bot_count = bot_count
	Variables.bots = $bots.get_children()
	# code files
	for i in range(0,bot_count):
		$interface/Panel/botsSelect.add_item("Bot "+str(i+1))
		Variables.codes.append("")
	# Saves
	Variables.code_load()
	$interface/Panel/CodeEdit.text = Variables.codes[Variables.current_code]
				
				
				
