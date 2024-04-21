extends CharacterBody2D

enum {
	RUNNING = 1,
	WALL_JUMPING = 2
}

const SPEED = 300.0
const ACCELERATION = 150.0
const DECELERATION = 120.0
const JUMP_VELOCITY = -500.0
const WALL_JUMP_VELOCITY = -450.0

var state = RUNNING
var wall_jumping_direction = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var wall_detection_1 = $WallDetection1
@onready var wall_detection_2 = $WallDetection2
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var wall_jump_timer = $WallJumpTimer
@onready var jump_sound = $JumpSound

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	match state:
		RUNNING:
			running_state(delta)
		WALL_JUMPING:
			wall_jumping_state()
	
	move_and_slide()

func running_state(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_sound.play()
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	if direction:
		animated_sprite_2d.flip_h = direction < 0
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	
	if is_on_floor():
		if direction != 0:
			animated_sprite_2d.animation = "Run"
		else:
			animated_sprite_2d.animation = "Idle"
	else:
		animated_sprite_2d.animation = "Jump"
	
	if (wall_detection_1.is_colliding() or wall_detection_2.is_colliding()) and !is_on_floor() and Input.is_action_just_pressed("jump"):
		if wall_detection_1.is_colliding():
			wall_jumping_direction = -1
		elif wall_detection_2.is_colliding():
			wall_jumping_direction = 1
		
		wall_jump_timer.start()
		jump_sound.play()
		velocity.y = WALL_JUMP_VELOCITY
		state = WALL_JUMPING

func wall_jumping_state():
	velocity.x = wall_jumping_direction * SPEED
	animated_sprite_2d.flip_h = wall_jumping_direction < 0
	
	if (wall_detection_1.is_colliding() or wall_detection_2.is_colliding()) and Input.is_action_just_pressed("jump"):
		wall_jump_timer.start()
		jump_sound.play()
		wall_jumping_direction *= -1
		velocity.y = WALL_JUMP_VELOCITY
	
	if is_on_floor():
		state = RUNNING

func _on_wall_jump_timer_timeout():
	state = RUNNING
