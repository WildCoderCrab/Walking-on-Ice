extends Control

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer
@onready var click_sound = $ClickSound

func _ready():
	$IceCaveMusic.play()
	color_rect.visible = true
	animation_player.play("Ending")

func _physics_process(delta):
	color_rect.color.a -= delta * 0.5

func _on_back_button_pressed():
	click_sound.play()
	get_tree().change_scene_to_file("res://Menu/menu.tscn")
