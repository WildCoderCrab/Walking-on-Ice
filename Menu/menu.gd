extends Control

@onready var main = $Main
@onready var controls = $Controls
@onready var click_sound = $ClickSound
@onready var ice_cave_music = $IceCaveMusic
@onready var color_rect = $Main/ColorRect

func _ready():
	color_rect.visible = true
	ice_cave_music.play()

func _physics_process(delta):
	color_rect.color.a -= delta

func _on_button_pressed():
	ice_cave_music.stop()
	click_sound.play()
	$Timer.start()

func _on_control_button_pressed():
	click_sound.play()
	main.visible = false
	controls.visible = true

func _on_back_button_pressed():
	click_sound.play()
	main.visible = true
	controls.visible = false

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://World/game.tscn")
