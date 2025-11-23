extends Node3D

var clock = 60 * 2
var game_end = false
var zooming_in = true

var start_dialogue = [
	"hey dude uhhhhhhhhhhh",
	"i know you haven't finished that rocket",
	"we need it ready in two minutes",
	"if we dont get it done boss is gonna be PEEVED",
	"also",
	"the parts SHOULD be in the building",
	"some of the parts for that are lost though",
	"so you might want to find them if you like having a job",
	"not my problem though i can just blame you for it",
	"good luck lolololololololololo"
]

func ending():
	game_end = true
	
	$CanvasLayer/Control/ThePanel.visible = false 
	$CanvasLayer/Control/PickUpPrompt.visible = false 
	$CanvasLayer/Control/ThrowPrompt.visible = false 
	$CanvasLayer/Control/Timer.visible = false
	
	$PaintTheTownRag.stop()
	
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
