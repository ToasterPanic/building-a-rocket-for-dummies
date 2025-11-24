extends Node3D

var mode = "menu"

func _ready() -> void:
	$UI/ColorRect.color.a = 1
	
	
	$UI/Settings/HBoxContainer/MasterVolume.value = AudioServer.get_bus_volume_linear(0)
	$UI/Settings/HBoxContainer/MusicVolume.value = AudioServer.get_bus_volume_linear(1)
	$UI/Settings/HBoxContainer/SoundEffectVolume.value = AudioServer.get_bus_volume_linear(2)
	
	$UI/Settings/HBoxContainer/Modifiers/EasyMode.button_pressed = global.easy_mode
	$UI/Settings/HBoxContainer/Modifiers/UberProcrastination.button_pressed = global.uber_procrastination
	$UI/Settings/HBoxContainer/Modifiers/TwoLeftFeet.button_pressed = global.two_left_feet
	$UI/Settings/HBoxContainer/Modifiers/HeavyBoxes.button_pressed = global.heavy_boxes
	$UI/Settings/HBoxContainer/Modifiers/Fat.button_pressed = global.fat
	$UI/Settings/HBoxContainer/Modifiers/Flat.button_pressed = global.flat
	$UI/Settings/HBoxContainer/Modifiers/BudgetFlash.button_pressed = global.budget_flash
	
	$UI/Settings/HBoxContainer/FieldOfView.value = global.field_of_view

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


func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)
	$UI/Settings/HBoxContainer/MasterVolume/Test.play()


func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(1, value)
	$UI/Settings/HBoxContainer/MusicVolume/Test.play()


func _on_sound_effect_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(2, value)
	$UI/Settings/HBoxContainer/SoundEffectVolume/Test.play()

func _on_uber_procrastination_toggled(toggled_on: bool) -> void: global.uber_procrastination = toggled_on


func _on_easy_mode_toggled(toggled_on: bool) -> void: global.easy_mode = toggled_on

func _on_two_left_feet_toggled(toggled_on: bool) -> void: global.two_left_feet = toggled_on

func _on_heavy_boxes_toggled(toggled_on: bool) -> void: global.heavy_boxes = toggled_on

func _on_fat_toggled(toggled_on: bool) -> void: global.fat = toggled_on

func _on_flat_toggled(toggled_on: bool) -> void: global.flat = toggled_on

func _on_budget_flash_toggled(toggled_on: bool) -> void: global.budget_flash = toggled_on

func _on_field_of_view_value_changed(value: float) -> void: global.field_of_view = value
