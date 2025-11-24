extends Node3D

var clock = 60 + 60 + 5
var game_end = true
var zooming_in = true

var start_dialogue = [
	"hey dude uhhhhhhhhhhh",
	"i know you haven't finished that rocket",
	"we need it ready in two minutes",
	"if you dont get it done boss is gonna be PEEVED",
	"also",
	"the parts SHOULD be in the building",
	"some of the parts for that are lost though",
	"so you might want to find them if you like having a job",
	"not my problem though",
	"good luck lolololololololololol"
]

func ending():
	game_end = true
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	$Camera3D.fov = 50
	
	$CanvasLayer/Control/ThePanel.visible = false 
	$CanvasLayer/Control/PickUpPrompt.visible = false 
	$CanvasLayer/Control/ThrowPrompt.visible = false 
	$CanvasLayer/Control/Timer.visible = false
	
	$PaintTheTownRag.stop()
	
	$Player/Camera3D.current = true
	
	$Camera3D.current = true
	
	$Drumroll.play()
	
	await get_tree().create_timer(4.242).timeout
	
	zooming_in = false
	
	# The reason we set both of them is because of jank
	# Set them both or the failure screen looks weird
	$CanvasLayer/Control/Success.scale = Vector2(0, 0)
	$CanvasLayer/Control/Failure.scale = Vector2(0, 0)
	
	if false:
		$CanvasLayer/Control/Success.visible = true
	else:
		$CanvasLayer/Control/Failure.visible = true
		
		$Failure.play()
		
		if randi_range(1, 5) == 1:
			$YouStink.play()
			
func _ready() -> void:
	game_end = true 
	
	var i = 0
	while i < start_dialogue.size():
		var character = 0
		
		$DialogueMan/Label3D.text = ""
		
		while character < start_dialogue[i].length():
			$DialogueMan/Label3D.text = $DialogueMan/Label3D.text + start_dialogue[i][character]
			
			$DialogueMan/Voice.play()
		
			if Input.is_action_pressed("interact"):
				await get_tree().create_timer(0.002).timeout
			else:
				await get_tree().create_timer(0.025).timeout
			
			character += 1
			
		if i != start_dialogue.size() - 1:
			while Input.is_action_just_pressed("interact") == false:
				await get_tree().create_timer(0.01).timeout
		
		i += 1
		
	$DialogueMan.go_away = true 
	
	$CanvasLayer/Control/AdvanceDialogue.visible = false
	
	await get_tree().create_timer(1.5).timeout
	
	game_end = false
	
	$Player/Camera3D.current = true
	
	$PaintTheTownRag.play()

func _process(delta: float) -> void:
	if game_end: 
		if zooming_in:
			$Camera3D.fov -= delta * 7
		else:
			$CanvasLayer/Control/Success.scale.x += (1 - $CanvasLayer/Control/Success.scale.x) / 2
			$CanvasLayer/Control/Success.scale.y = $CanvasLayer/Control/Success.scale.x
			
			$CanvasLayer/Control/Failure.scale.x = $CanvasLayer/Control/Success.scale.x
			$CanvasLayer/Control/Failure.scale.y = $CanvasLayer/Control/Success.scale.x
			
			pass
		
		return
		
	var text = """[font size=32]Checklist[/font]\n\n"""
	
	var to_text = func(val):
		if val: return "X"
		else: return " "
	
	text = text + "[" + to_text.call($Rocket/Screws.visible) + "] Screws\n"
	text = text + "[" + to_text.call($Rocket/Thruster.visible) + "] Thruster\n"
	text = text + "[" + to_text.call($Rocket/Fins.visible) + "] Fins\n"
	text = text + "[" + to_text.call($Rocket/CockpitSeat.visible) + "] Cockpit Seat\n"
	text = text + "[" + to_text.call($Rocket/LifeSupport.visible) + "] Life Support\n"
	text = text + "[" + to_text.call($Rocket/ExteriorWalls.visible) + "] Exterior Walls\n"
	
	$CanvasLayer/Control/ThePanel/RichTextLabel.text = text
	
	if clock <= 0:
		ending()
	
	clock -= delta
	
	if roundi(clock)% 60 < 10: $CanvasLayer/Control/Timer.text = str(roundi(clock) / 60) + ":0" + str(roundi(clock) % 60)
	else: $CanvasLayer/Control/Timer.text = str(roundi(clock) / 60) + ":" + str(roundi(clock) % 60)
	
	if $Player.held_object == null:
		$CanvasLayer/Control/ThrowPrompt.visible = false
		$CanvasLayer/Control/PickUpPrompt.visible = $Player/Camera3D/Interact.is_colliding()
	else:
		$CanvasLayer/Control/ThrowPrompt.visible = true
		$CanvasLayer/Control/PickUpPrompt.visible = false

func _on_collision_area_body_entered(body: Node3D) -> void:
	body.queue_free()
	
	$Fix.play()
	
	if body.name == "Screws":
		$Rocket/Screws.visible = true
	elif body.name == "ExteriorWalls":
		$Rocket/ExteriorWalls.visible = true
	elif body.name == "Fins":
		$Rocket/Fins.visible = true
	elif body.name == "Thruster":
		$Rocket/Thruster.visible = true
	elif body.name == "CockpitSeat":
		$Rocket/CockpitSeat.visible = true
	elif body.name == "LifeSupport":
		$Rocket/LifeSupport.visible = true


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
