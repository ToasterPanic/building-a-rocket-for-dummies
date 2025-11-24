extends Node3D

var mode = "menu"

func _ready() -> void:
	$UI/ColorRect.color.a = 1

func _process(delta: float) -> void:
	if mode == "menu":
		$UI/ColorRect.mouse_filter = 2
		$UI/ColorRect.color.a -= delta * 1
		if $UI/ColorRect.color.a < 0:
			$UI/ColorRect.color.a = 0
			
		$UI/Settings.visible = false
		$UI/Credits.visible = false
	else:
		$UI/ColorRect.mouse_filter = 0
		$UI/ColorRect.color.a += delta * 1
		if $UI/ColorRect.color.a > 1:
			$UI/ColorRect.color.a = 1
			
			if mode == "play":
				get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_play_pressed() -> void:
	mode = "play"

func _on_return_button_pressed() -> void:
	mode = "menu"


func _on_credits_pressed() -> void:
	mode = "credits"
	$UI/Credits.visible = true


func _on_settings_pressed() -> void:
	mode = "settings"
	$UI/Settings.visible = true
