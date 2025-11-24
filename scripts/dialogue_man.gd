extends CharacterBody3D


var go_away = false

func _physics_process(delta: float) -> void:
	velocity.y = -15
	if go_away:
		velocity.y = 2
	move_and_slide()
