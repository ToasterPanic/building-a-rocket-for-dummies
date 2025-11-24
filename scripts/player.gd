extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 5
var jump_speed = 6.5
var mouse_sensitivity = 0.002

var held_object = null

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if get_parent().game_end:
		return 
		
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(89), deg_to_rad(89))
		
func _physics_process(delta):
	if get_parent().game_end:
		velocity = Vector3(0, -9.8, 0)
		move_and_slide()
		return 
		
	if Input.is_action_just_pressed("throw"):
		if held_object != null:
			held_object.linear_velocity = $Camera3D.global_basis * Vector3(0, 0, -11)
			held_object = null
	elif Input.is_action_just_pressed("interact"):
		if held_object != null: held_object = null
		elif $Camera3D/Interact.is_colliding(): held_object = $Camera3D/Interact.get_collider()
		
	print(held_object)
	
	if held_object != null:
		var target_pos = $Camera3D.global_transform.origin + ($Camera3D.global_basis * Vector3(0, 0, -2.5)) # 2.5 units in front of camera
		var object_pos = held_object.global_transform.origin # Held object position
		held_object.linear_velocity = (target_pos - object_pos) * 7 # Our desired position
		
		if held_object.global_position.distance_to($Camera3D.global_position) > 4:
			held_object = null
		
		
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
