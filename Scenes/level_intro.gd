extends Node2D


var running:bool = false


#bots
var bots:Array
var bot_count:int
func _ready():
	
	bot_count = len($bots.get_children())
	Variables.current_bot_count = bot_count
	
	# code files
	for i in range(0,bot_count):
		$interface/Panel/botsSelect.add_item("Bot "+str(i+1))
		Variables.codes.append("")
	# Saves
	Variables.code_load()
	$interface/Panel/CodeEdit.text = Variables.codes[Variables.current_code]

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
	bots = $bots.get_children()
	for i in range(0,bot_count):
		if len(Variables.codes[i].rsplit("\n", false)) == 0:
			bots[i].available = false
		else:
			bots[i].available = true
		bots[i].code_lines =(Variables.codes[i].rsplit("\n", false))
		bots[i].iterator = 0
	$interface/RunButton.text = "Stop"
	$interface/Panel/CodeEdit.editable = false
	$interface/Panel/botsSelect.disabled = true
	$interface/SaveButton.disabled = true
	$TickTimer.start(Variables.tick_time)
	
func set_normal_mode():
	running = false
	Variables.tick = false
	$TickTimer.stop()
	$interface/RunButton.text = "Run"
	$interface/Panel/CodeEdit.editable = true
	$interface/Panel/botsSelect.disabled = false
	$interface/SaveButton.disabled = false
	
func _process(delta):
	#debug
	$DebugWindow/Text.text = str(Variables.map).replace("],","], \n")
	
	if running and Variables.tick and not Variables.sleep:
		#$DebugWindow/Text.text = str(bots[0].iterator)
		for i in range(0,Variables.current_bot_count):
			
			# check if bot is available
			if not bots[i].available:
				continue
			
			var line:String = bots[i].code_lines[bots[i].iterator]
			print("bot "+str(i)+line)
			if len(line.rsplit(" ")) <=2:
				# move
				var first:String = line.rsplit(" ")[0]
				var second:String = ""
				if len(line.rsplit(" ")) > 1:
					second = line.rsplit(" ")[1]
				
				if first == "move" or first == "say" or first == "listen":
					if second == "left" or second == "right" or second == "up" or second == "down":
						bots[i].emit_signal("move",second)
						pass
					else:
						show_error(bots[i].iterator,i,"wrong argument",second)
				elif first == "add" or first == "sub":
					if second.to_int() != null:
						# z bota iterator_update(i)
						# todo! emit signal
						pass
					else:
						show_error(bots[i].iterator,i,"wrong number",second)
				else:
					show_error(bots[i].iterator,i,"wrong command",line)
				
			else:
				show_error(bots[i].iterator,i,"too many arguments",line)
		Variables.tick = false
		Variables.sleep = true
		
	var all_finished = true
	for bot in bots:
		if bot.is_doing:
			all_finished = false
	if all_finished:
		Variables.sleep = false
		
	
	
func show_error(line_number:int,bot_number:int,error_name:String,text:String):
	set_normal_mode()
	$ErrorWindow/Label.text ="'"+error_name+"'\n at line "+str(line_number+1)+"\n in bot "+str(bot_number+1)+", caused by '"+text+"'"
	$ErrorWindow.visible = true

func _on_error_button_pressed():
	$ErrorWindow.visible = false

