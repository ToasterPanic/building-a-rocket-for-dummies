extends Node3D


func _process(delta: float) -> void:
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
