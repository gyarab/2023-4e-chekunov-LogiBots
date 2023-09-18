extends Node2D


var running:bool = false
var tick:bool = false

#bots
var bots:Array
var code_lines:Array
var iterators:Array
var bot_count:int
func _ready():
	
	bot_count = len($bots.get_children())
	Variables.current_bot_count = bot_count
	
	for i in range(0,bot_count):
		$interface/botsSelect.add_item("Bot "+str(i+1))
		Variables.codes.append("")
	# Saves
	Variables.code_load()
	$interface/CodeEdit.text = Variables.codes[Variables.current_code]

func _on_save_button_pressed():
	Variables.code_save()

func _on_run_button_pressed():
	if running:
		set_normal_mode()
	else:
		set_running_mode()
	
func _on_code_edit_text_changed():
	Variables.codes[Variables.current_code] =$interface/CodeEdit.text
	
func _on_bots_select_item_selected(index):
	Variables.current_code = index
	$interface/CodeEdit.text = Variables.codes[Variables.current_code]

func _on_tick_timer_timeout():
	tick = true
	print("tick!")

func set_running_mode():
	Variables.code_save()
	running = true
	tick = true
	bots = $bots.get_children()
	code_lines = []
	for i in range(0,bot_count):
		if len(Variables.codes[i].rsplit("\n", false)) == 0:
			bots[i].available = false
		code_lines.append(Variables.codes[i].rsplit("\n", false))
		iterators.append(0)
	$TickTimer.start(2)
	$interface/RunButton.text = "Stop"
	$interface/CodeEdit.editable = false
	$interface/botsSelect.disabled = true
	$interface/SaveButton.disabled = true
func set_normal_mode():
	running = false
	tick = false
	$TickTimer.stop()
	$interface/RunButton.text = "Run"
	$interface/CodeEdit.editable = true
	$interface/botsSelect.disabled = false
	$interface/SaveButton.disabled = false
	
func _process(delta):
	if running and tick:
		for i in range(0,Variables.current_bot_count):
			
			# check if bot is available
			if not bots[i].available:
				continue
			var line:String = code_lines[i][iterators[i]]		
			if len(line.rsplit(" ")) <=2:
				# move
				var first:String = line.rsplit(" ")[0]
				var second:String = ""
				if len(line.rsplit(" ")) > 1:
					second = line.rsplit(" ")[1]
				
				if first == "move" or first == "say" or first == "listen":
					if second == "left" or second == "right" or second == "up" or second == "down":
						# z bota iterator_update(i)
						# todo! emit signal
						pass
					else:
						show_error(iterators[i],i,"wrong argument",second)
				elif first == "add" or first == "sub":
					if second.to_int() != null:
						# z bota iterator_update(i)
						# todo! emit signal
						pass
					else:
						show_error(iterators[i],i,"wrong number",second)
				else:
					show_error(iterators[i],i,"wrong command",line)
				
			else:
				show_error(iterators[i],i,"too many arguments",line)
		tick = false
		
func show_error(line_number:int,bot_number:int,error_name:String,text:String):
	set_normal_mode()
	$ErrorWindow/Label.text ="'"+error_name+"'\n at line "+str(line_number+1)+"\n in bot "+str(bot_number+1)+", caused by '"+text+"'"
	$ErrorWindow.visible = true

func _on_error_button_pressed():
	$ErrorWindow.visible = false

func iterator_update(index:int):
	if iterators[index] < len(code_lines[index])-1:
		iterators[index] += 1
	else:
		bots[index].available = false
