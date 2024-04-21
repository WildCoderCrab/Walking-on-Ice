extends Area2D

func _on_body_entered(_body):
	var scene = get_tree().current_scene
	scene.password_panel.visible = true
	scene.button.visible = true

func _on_body_exited(_body):
	get_tree().current_scene.password_panel.visible = false
