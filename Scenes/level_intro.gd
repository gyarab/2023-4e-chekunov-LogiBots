extends Node2D


signal all_bots_ready
#bots
var bot_count:int
var bot_scene = preload("res://Scenes/bot/bot.tscn")
var box_scene = preload("res://Scenes/objects/box.tscn")

var step:int = 0


func _ready():
	lvl_load()

func _on_run_button_pressed():
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
	step+=1
	print("tick! "+ str(step))
	
	Variables.tick = true

func set_running_mode():
	Variables.code_save()
	Variables.running = true
	Variables.tick = true
	Variables.bots = $bots.get_children()
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
		# adding anchors
		for j  in range(0,len(Variables.bots[i].code_lines)):
			var line = Variables.bots[i].code_lines[j]
			if len(line.rsplit(" ")) == 1:
				if line[len(line)-1] == ":":
					Variables.bots[i].code_anchors[line.get_slice(":",0)] = j
					
	$interface/RunButton.text = "Stop"
	$interface/Panel/CodeEdit.editable = false
	$interface/Panel/botsSelect.disabled = true
	$interface/HSlider.editable = false
	$TickTimer.start(Variables.tick_time)
	
func set_normal_mode():
	Variables.running = false
	Variables.tick = false
	lvl_load()
	$TickTimer.stop()
	$interface/HSlider.editable = true
	$interface/RunButton.text = "Run"
	$interface/Panel/CodeEdit.editable = true
	$interface/Panel/botsSelect.disabled = false
	
func _process(delta):
	# selected bot light
	
	#debug
	$DebugWindow/Text.text = str(Variables.map).replace("],","], \n")
	#$DebugWindow/Text.text = str(Variables.current_code)
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
		Variables.tick = false
		Variables.sleep = true
		
	var all_finished = true
	for bot in Variables.bots:
		if bot.is_doing:
			all_finished = false
	if all_finished:
		Variables.sleep = false
		
	
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
			# two word commands
			if len(line.rsplit(" ")) == 2:
				
				var first:String = line.rsplit(" ")[0]
				var second:String = "no argument"
				if len(line.rsplit(" ")) > 1:
					second = line.rsplit(" ")[1]
				# jumps
				if first == "jump" or first == "jumpz" or first == "jumpn" or first == "jumpg":
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
	Variables.hoping_bots = []
	Variables.bot_ids = 0
	# clear all buttons
	$interface/Panel/botsSelect.clear()
	
	# step
	step = 0
	
	var lvl:int = Variables.level
	for i in range(0,20):
		for j in range(0,11):
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
	
	#Variables.map = Variables.lvl_maps
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
	$interface/Panel/botsSelect.select(Variables.current_code)
	$interface/Panel/CodeEdit.text = Variables.codes[Variables.current_code]


func _on_h_slider_drag_ended(value_changed):
	Variables.tick_time = 10/$interface/HSlider.value
