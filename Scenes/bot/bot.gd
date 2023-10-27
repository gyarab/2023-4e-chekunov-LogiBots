extends CharacterBody2D

var active: int = 0
var memory: int = 0
var pos:Vector2
var available:bool = true
var iterator:int = 0
var code_lines:Array
var saying:bool = false
var listening:bool = false

# better functions
var move_count := 0
var new_move_count_down := true

var id:int
signal move(direction:String,count:int)
signal listen(direction:String)
signal say(direction:String)
signal was_listened()
signal jump(type:String,anchor:String)
signal add(number:int)
signal swap()
signal save()
# jumps
# 1 if positive
# 0 if zero
#-1 if negative
#42 while true
var code_jumps:Dictionary # Vector2(1 or 0 or -1 or 42,anchor)
var code_anchors:Dictionary # Vector2(self.name,self.radek)

var update_iterator_bool:bool = false
var is_doing:bool = false
var direction:String
func _ready():
	$AnimationPlayer.play("number")
	#id on create
	id = Variables.bot_ids
	Variables.bot_ids+=1
	active = 0
	#pos = Vector2(floor(self.position.x/64),floor(self.position.y/64))
	update_position()

func _process(delta):
	
	#debug
	#print($bodyLight.enabled)
	
	# cosmetics
	if id == Variables.current_code and not Variables.running:
		$bodyLight.energy = 9
		$bodyLight.color = Color("ff6600")
		$bodyLight.enabled = true
	elif not Variables.running:
		$bodyLight.energy = 4
		$bodyLight.color = Color("ff660083")
		$bodyLight.enabled = true
		
	
	if Variables.running and self.available == false:
		$bodyLight.energy = 10
		$bodyLight.color = Color("red", 5)
		$bodyLight.enabled = true
	
	
	
	if not Variables.running:
		$Active.text = str(id+1)
	else:
		$Active.text = str(active)
	$Memory.text = str(id+1)
	
	if is_doing:
		$AnimationPlayer.play(direction)
		if direction == "left":
			velocity = Vector2.LEFT * delta * 64 * 60 / Variables.tick_time
		if direction == "right":
			velocity = Vector2.RIGHT * delta * 64 * 60 / Variables.tick_time
		if direction == "up":
			velocity = Vector2.UP * delta * 64 * 60 / Variables.tick_time
		if direction == "down":
			velocity = Vector2.DOWN * delta * 64 * 60 / Variables.tick_time
		move_and_slide()

func iterator_update():
	if iterator < len(code_lines)-1:
		iterator += 1
		for i in range(iterator,len(code_lines)):
			if not code_anchors.has(code_lines[i].split(":",0)[0]):
				iterator = i
				return
		$AnimationPlayer.play("down")
		self.available = false
	else:
		$AnimationPlayer.play("down")
		self.available = false

func _on_listen(direction):
	
	var destination:Vector2
	var saying_bot = -1
	if direction == "up":
		destination = Vector2(pos.x,pos.y-1)
		saying_bot = 13
	if direction == "down":
		destination = Vector2(pos.x,pos.y+1)
		saying_bot = 12
	if direction == "left":
		destination = Vector2(pos.x-1,pos.y)
		saying_bot = 11
	if direction == "right":
		destination = Vector2(pos.x+1,pos.y)
		saying_bot = 10
	
	# borders
	if  destination.x > 15 or destination.y > 9 or destination.x < 0 or destination.y < 0:
		self.available = false
		return
	# listen to box, huh?
	if Variables.map[destination.x][destination.y] == 2:
		self.available = false
		return
	if Variables.map[destination.x][destination.y] == 1:
		Variables.hoping_bots.append(self)
	
	# microphone
	if Variables.map[destination.x][destination.y] == 3:
		# search right microphone
		var right_mic
		for mic in Variables.mics:
			if mic.pos == destination:
				right_mic = mic
				#chybi
				self.active = right_mic.number
				await get_parent().get_parent().all_bots_ready
				iterator_update()
				return
	# speaker
	if Variables.map[destination.x][destination.y] == 4:
		# search right microphone
		var right_spk
		for spk in Variables.speakers:
			if spk.pos == destination:
				right_spk = spk
				#chybi
				self.active = right_spk.number
				await get_parent().get_parent().all_bots_ready
				iterator_update()
				return
	if Variables.map[destination.x][destination.y] == saying_bot:
		#search right bot
		var right_bot
		for bot in Variables.bots:
			if bot.pos == destination:
				right_bot = bot
				#chybi
				bot.emit_signal("was_listened")
				await get_parent().get_parent().all_bots_ready
				self.active = right_bot.active
				iterator_update()
				return
func _on_move(direction,count):
	print("move_cont ")
	print(move_count)
	if move_count == 0 and new_move_count_down:
		new_move_count_down = false
		move_count = count - 1
	else:
		move_count -= 1
		
	var map = Variables.map
	var destination:Vector2
	if direction == "up":
		destination = Vector2(pos.x,pos.y-1)
	if direction == "down":
		destination = Vector2(pos.x,pos.y+1)
	if direction == "left":
		destination = Vector2(pos.x-1,pos.y)
	if direction == "right":
		destination = Vector2(pos.x+1,pos.y)
	
	if  destination.x > 19 or destination.y > 9 or destination.x < 0 or destination.y < 0:
		self.available = false
		return
	
	if Variables.map[destination.x][destination.y] == 2:
		self.available = false
		return
	if Variables.map[destination.x][destination.y] == 1:
		Variables.hoping_bots.append(self)
	if Variables.map[destination.x][destination.y] == 0:
		map[destination.x][destination.y] = 1
		map[pos.x][pos.y] = 0
		pos = destination
		self_move(direction)
	Variables.map = map
	
func self_move(dir:String):
	await get_parent().get_parent().all_bots_ready
	print("gotovo!")
	is_doing = true
	direction = dir
	$WorkTimer.start(Variables.tick_time)
	
func _on_say(direction):
	var destination:Vector2
	var say = -1
	if direction == "up":
		destination = Vector2(pos.x,pos.y-1)
		say = 12
	if direction == "down":
		destination = Vector2(pos.x,pos.y+1)
		say = 13
	if direction == "left":
		destination = Vector2(pos.x-1,pos.y)
		say = 10
	if direction == "right":
		destination = Vector2(pos.x+1,pos.y)
		say = 11
	Variables.map[pos.x][pos.y] = say
	
	# borders
	if  destination.x > 19 or destination.y > 10 or destination.x < 0 or destination.y < 0:
		self.available = false
		return
	# saying to box, huh?
	if Variables.map[destination.x][destination.y] == 2 or Variables.map[destination.x][destination.y] == 4:
		self.available = false
		return
	# microphone
	if Variables.map[destination.x][destination.y] == 3:
		var right_mic
		for mic in Variables.mics:
			if mic.pos == destination:
				right_mic = mic
				#chybi
				right_mic.number = self.active
				await get_parent().get_parent().all_bots_ready
				iterator_update()
				return
	await was_listened
	print("uz rekl")
	Variables.map[pos.x][pos.y] = 1
	await get_parent().get_parent().all_bots_ready
	iterator_update()
	return

func _on_work_timer_timeout():
	# position sync
	position =Vector2(pos.x * 64 + 32,pos.y * 64 + 32 +64)
	is_doing = false
	direction = " "
	if move_count == 0:
		update_iterator_bool = true
		new_move_count_down = true
	if update_iterator_bool:
		iterator_update()
		update_iterator_bool = false
func update_position():
	position =Vector2(pos.x * 64 + 32,pos.y * 64 + 32 + 64)
func self_destroy():
	self.queue_free()
func _on_jump(type, anchor):
	var jump:bool = false
	if type == "jump":
		jump = true
	elif type == "jumpl":
			jump = active < 0
	elif type == "jumpz":
		jump = active == 0
	elif type == "jumpg":
		jump = active > 0 
		
	if jump:
		code_jump(anchor)
	else:
		#print("halo!")
		await get_parent().get_parent().all_bots_ready
		iterator_update()
func code_jump(anchor:String):
	await get_parent().get_parent().all_bots_ready
	# seek for the first line that is not anchor
	self.iterator = code_anchors[anchor] - 1
	iterator_update()
	

func _on_was_listened():
	pass # Replace with function body.


func _on_add(number):
	$AnimationPlayer.play("number")
	active += number
	await get_parent().get_parent().all_bots_ready
	iterator_update()


func _on_swap():
	var c:int = active
	active = memory
	memory = c
	$AnimationPlayer.play("number")
	await get_parent().get_parent().all_bots_ready
	iterator_update()


func _on_save():
	$AnimationPlayer.play("number")
	memory = active
	await get_parent().get_parent().all_bots_ready
	iterator_update()
