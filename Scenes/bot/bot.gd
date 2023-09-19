extends CharacterBody2D

@export var active: int = 0
@export var memory: int = 0
@export var pos:Vector2
@export var available:bool = true
@export var iterator:int = 0
@export var code_lines:Array
@export var id:int
signal move(direction:String)
signal listen(direction:String)
signal say(direction:String)

var update_iterator_bool:bool = false
var is_doing:bool = false
var direction:String
func _ready():
	pos = Vector2(floor(self.position.x/64),floor(self.position.y/64))
	Variables.map[pos.x][pos.y] = 1
	position =Vector2(pos.x * 64 + 32,pos.y * 64 + 32)

func _process(delta):
	$Active.text = str(iterator)
	$Memory.text = str(id)
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
	if direction == "up":
		if Variables.map[pos.x][pos.y-1] == 1:
			print("nud blin")
			Variables.hoping_bots.append(self)
		if Variables.map[pos.x][pos.y-1] == 0:
			map[pos.x][pos.y-1] = 1
			map[pos.x][pos.y] = 0
			pos.y-=1
			update_iterator_bool = true
			self_move("up")
	if direction == "down":
		if Variables.map[pos.x][pos.y+1] == 1:
			print("nud blin")
			Variables.hoping_bots.append(self)
		if Variables.map[pos.x][pos.y+1] == 0:
			map[pos.x][pos.y+1] = 1
			map[pos.x][pos.y] = 0
			pos.y+=1
			update_iterator_bool = true
			self_move("down")
	if direction == "left":
		if Variables.map[pos.x-1][pos.y] == 1:
			print("nud blin")
			Variables.hoping_bots.append(self)
		if Variables.map[pos.x-1][pos.y] == 0:
			map[pos.x-1][pos.y] = 1
			map[pos.x][pos.y] = 0
			pos.x-=1
			update_iterator_bool = true
			self_move("left")
	if direction == "right":
		if Variables.map[pos.x+1][pos.y] == 1:
			print("nud blin")
			Variables.hoping_bots.append(self)
		if Variables.map[pos.x+1][pos.y] == 0:
			map[pos.x+1][pos.y] = 1
			map[pos.x][pos.y] = 0
			pos.x+=1
			update_iterator_bool = true
			self_move("right")
	Variables.map = map
	
func self_move(dir:String):
	await get_parent().get_parent().all_bots_ready
	print("pohnul")
	print(iterator)
	is_doing = true
	direction = dir
	$WorkTimer.start(Variables.tick_time)
func _on_say(direction):
	pass # Replace with function body.


func _on_work_timer_timeout():
	
	# position sync
	position =Vector2(pos.x * 64 + 32,pos.y * 64 + 32)
	
	is_doing = false
	direction = " "
	if update_iterator_bool:
		iterator_update()
		update_iterator_bool = false
