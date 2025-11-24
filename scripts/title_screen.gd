extends Node3D

var mode = "menu"

func _ready() -> void:
	$UI/ColorRect.color.a = 1

func _process(delta: float) -> void:
	if mode == "menu":
		$UI/ColorRect.color.a -= delta * 1
		if $UI/ColorRect.color.a < 0:
			$UI/ColorRect.color.a = 0
	else:
		$UI/ColorRect.color.a += delta * 1
		if $UI/ColorRect.color.a > 1:
			$UI/ColorRect.color.a = 1
			
			if mode == "play":
				get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_play_pressed() -> void:
	mode = "play"
