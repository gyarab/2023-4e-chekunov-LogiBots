extends CharacterBody2D

var active: int = 0
var memory: int = 0
var pos:Vector2
var available:bool = true
var iterator:int = 0
var code_lines:Array
var saying:bool = false
var listening:bool = false

var id:int
signal move(direction:String)
signal listen(direction:String)
signal say(direction:String)
signal was_listened()
signal jump(type:String,anchor:String)
signal add(number:int)
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
	#id on create
	id = Variables.bot_ids
	Variables.bot_ids+=1
	active = id
	#pos = Vector2(floor(self.position.x/64),floor(self.position.y/64))
	update_position()

func _process(delta):
	# cosmetics
	if id == Variables.current_code and not Variables.running:
		$light.energy = 9
		$light.color = Color(0, 255, 1)
		$light.enabled = true
	else:
		$light.enabled = false
	if Variables.running and self.available == false:
		$light.energy = 3
		$light.color = Color(255, 0, 0, 0.5)
		$light.enabled = true
	
	$Active.text = str(active)
	$Memory.text = str(id+1)
	if is_doing:
		if direction == "left":
			velocity = Vector2.LEFT * delta * 64 * 60 / Variables.tick_time
			move_and_slide()
		if direction == "right":
			velocity = Vector2.RIGHT * delta * 64 * 60 / Variables.tick_time
			move_and_slide()
		if direction == "up":
			velocity = Vector2.UP * delta * 64 * 60 / Variables.tick_time
			move_and_slide()
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
		
		self.available = false
	else:
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
	if  destination.x > 19 or destination.y > 10 or destination.x < 0 or destination.y < 0:
		self.available = false
		return
	# listen to box, huh?
	if Variables.map[destination.x][destination.y] == 2:
		self.available = false
		return
	print(Variables.map[destination.x][destination.y])
	print("neni?")
	print(saying_bot)
	if Variables.map[destination.x][destination.y] == 1:
		Variables.hoping_bots.append(self)
	if Variables.map[destination.x][destination.y] == saying_bot:
		print("pridavam")
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

func _on_move(direction):
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
	
	if  destination.x > 19 or destination.y > 10 or destination.x < 0 or destination.y < 0:
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
		update_iterator_bool = true
		self_move(direction)
	Variables.map = map
	
func self_move(dir:String):
	await get_parent().get_parent().all_bots_ready
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
	if Variables.map[destination.x][destination.y] == 2:
		self.available = false
		return
	print("rikam")
	await was_listened
	print("uz rekl")
	Variables.map[pos.x][pos.y] = 1
	await get_parent().get_parent().all_bots_ready
	iterator_update()
	return

func _on_work_timer_timeout():
	# position sync
	position =Vector2(pos.x * 64 + 32,pos.y * 64 + 32)
	is_doing = false
	direction = " "
	if update_iterator_bool:
		iterator_update()
		update_iterator_bool = false
func update_position():
	position =Vector2(pos.x * 64 + 32,pos.y * 64 + 32)
func self_destroy():
	self.queue_free()
func _on_jump(type, anchor):
	var jump:bool = false
	if type == "jump":
		jump = true
	elif type == "jumpn":
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
	active += number
	await get_parent().get_parent().all_bots_ready
	iterator_update()
