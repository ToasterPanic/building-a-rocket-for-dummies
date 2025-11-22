extends CSGBox3D




func _on_hitbox_body_entered(body: Node3D) -> void:
	body.queue_free()
	queue_free()
