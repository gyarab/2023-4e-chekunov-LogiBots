extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$AudioStreamPlayer.volume_db = 20 * (Variables.volume/100.0)-20
	
	$HTTPRequestCreateUpdate.request_completed.connect(_on_request_completed)
	$HTTPRequestLeaderBoard.request_completed.connect(_on_request_completed_leader_board)
	$HTTPRequestSelfName.request_completed.connect(_on_request_completed_self_name)
	var headers = ["Content-Type: application/json"]
	var url = "https://logibot.svs.gyarab.cz/players/"
	$HTTPRequestLeaderBoard.request(url, headers, HTTPClient.METHOD_GET, "")
	$Control/Login/Username.text = get_username()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Control/Login/Username.text != "Anonymous":
		$Control/Login/Label.text = "Change username"
	else:
		$Control/Login/Label.text = "Create user"


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu/main_menu.tscn")


func _on_submit_button_pressed():
	var data_to_send:Dictionary
	var username = $Control/Login/Username.text
	if username == "":
		username = "Anonymous"
	data_to_send["username"] = username
	GameFiles.load_points()
	data_to_send["points"] = Variables.points
	
	var secret_key: String = get_secret_key()
	
	data_to_send["password"] = str(secret_key)
	
	var json = JSON.stringify(data_to_send)
	#print(json)
	var headers = ["Content-Type: application/json"]
	var url = "https://logibot.svs.gyarab.cz/players/"
	$HTTPRequestCreateUpdate.request(url, headers, HTTPClient.METHOD_POST, json)

func save_user_name():
	var file_path := "user://Saves/online/.username.txt"
	
	if FileAccess.file_exists(file_path):
		
		var file = FileAccess.open(file_path,FileAccess.WRITE)
		var key = $Control/Login/Username.text
		file.store_var(key)
		file.close()
	else:
		pass
	
func get_secret_key():
	var file_path := "user://Saves/online/.secret.key"
	
	if FileAccess.file_exists(file_path):
		
		var file = FileAccess.open(file_path,FileAccess.READ)
		var key = file.get_var()
		file.close()
		return key
	else:
		return ""
func get_username():
	var file_path := "user://Saves/online/.username.txt"
	
	if FileAccess.file_exists(file_path):
		
		var file = FileAccess.open(file_path,FileAccess.READ)
		var name = file.get_var()
		file.close()
		return name
	else:
		return ""

func _on_request_completed(result, response_code, headers, body):
	if response_code == 201:
		$Control/Login/ServerInfo.text = "Success!"
		save_user_name()
		update_leader_board()
	else:
		$Control/Login/ServerInfo.text = "This username is already taken"
		$Control/Login/Username.text = get_username()

func update_leader_board():
	var headers = ["Content-Type: application/json"]
	var url = "https://logibot.svs.gyarab.cz/players/"
	$HTTPRequestLeaderBoard.request(url, headers, HTTPClient.METHOD_GET, "")

func _on_request_completed_leader_board(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		var text: String
		for i in range(len(json)):
			text += "[left]"+str(i+1)+".\t\t[color=#ff9f1c]"+escape_bbcode(json[i]["username"])+ "[/color][/left]..........[color=#ff9f1c]"+str(json[i]["points"])+"[/color] points.\n"
		$Control/LeaderBoard/RichTextLabel.text = text
	else:
		$Control/LeaderBoard/RichTextLabel.text = "Internet Error"
	
func _on_request_completed_self_name(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		$Control/Login/Username.text =json["username"]
	
func escape_bbcode(bbcode_text):
	# We only need to replace opening brackets to prevent tags from being parsed.
	return bbcode_text.replace("[", "[lb]")
