extends CharacterBody2D

var active: int = 0
var memory: int = 0
var pos:Vector2
var available:bool = true
var iterator:int = 0
var code_lines:Array
var id:int
signal move(direction:String)
signal listen(direction:String)
signal say(direction:String)
signal jump(type,anchor)
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
	
	$Active.text = str(iterator)
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
	else:
		self.available = false


func _on_listen(direction):
	pass # Replace with function body.


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
	
	if Variables.map[destination.x][destination.y] == 2:
		self.available = false
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
func _on_say(dir):
	pass # Replace with function body.


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
	pass
