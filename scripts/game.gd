extends Node3D

var clock = 60 * 5

func _process(delta: float) -> void:
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
	
	if body.name == "Screws":
		$Rocket/Screws.visible = true
	elif body.name == "ExteriorWalls":
		$Rocket/ExteriorWalls.visible = true
