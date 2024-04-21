extends Node2D

@onready var camera_2d = $Camera2D
@onready var player = $Player
@onready var password_panel = $CanvasLayer/PasswordPanel
@onready var line_edit = $CanvasLayer/PasswordPanel/LineEdit
@onready var button = $Button
@onready var password_label = $CanvasLayer/Panel
@onready var click_sound = $ClickSound
@onready var _8_bit_ice_cave_music = $"8BitIceCaveMusic"
@onready var back_button = $CanvasLayer/BackButton
@onready var color_rect = $CanvasLayer/ColorRect

var password = 0

# Songs to credit:
#	https://opengameart.org/content/ice-cave
#	https://opengameart.org/content/8-bit-lofi-ice-cave

func _ready():
	randomize()
	password = randi_range(1000, 9999)
	
	_8_bit_ice_cave_music.play()
	
	color_rect.visible = true
	password_panel.visible = false
	button.visible = false
	password_label.visible = false
	back_button.visible = false

func _physics_process(delta):
	camera_2d.global_position.y = lerp(camera_2d.global_position.y, player.global_position.y - 48, 10 * delta)
	color_rect.color.a -= delta
	
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		back_button.visible = !back_button.visible

func _on_line_edit_text_changed(new_text):
	if !new_text.is_valid_float():
		line_edit.text = ""
	
	if line_edit.text == str(password):
		click_sound.play()
		_8_bit_ice_cave_music.stop()
		$Door/Timer.start()

func _on_button_body_entered(_body):
	if button.visible:
		if !password_label.visible:
			click_sound.play()
		password_label.visible = true
		$CanvasLayer/Panel/PasswordLabel.text = str(password)

func _on_timer_timeout():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Ending/ending.tscn")

func _on_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
