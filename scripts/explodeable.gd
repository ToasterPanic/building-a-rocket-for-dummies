extends CSGBox3D




func _on_hitbox_body_entered(body: Node3D) -> void:
	$CSGBox3D.queue_free()
	
	$Hitbox.queue_free()
	
	$Explode.play()
	
	visible = false 
	use_collision = false
	
	body.freeze = true
	
	body.get_node("CollisionShape3D").queue_free()
	body.get_node("MeshInstance3D").queue_free()
	
	body.get_node("Explosion1").restart()
	body.get_node("Explosion2").restart()
	
	await get_tree().create_timer(1.1).timeout
	
	body.queue_free()
	queue_free()
