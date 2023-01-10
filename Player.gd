extends KinematicBody

export var speed = 14
export var fall_acceleration = 100
export var jump_impulse = 20

var velocity = Vector3.ZERO


func _physics_process(delta):
	var direction_input = Vector3.ZERO

	# Check for each move input and update the direction
	if Input.is_action_pressed("move_right"):
		direction_input.x += 1
	if Input.is_action_pressed("move_left"):
		direction_input.x -= 1
	if Input.is_action_pressed("move_down"):
		direction_input.z += 1
	if Input.is_action_pressed("move_up"):
		direction_input.z -= 1

	# Look in direction
	if direction_input != Vector3.ZERO:
		$Pivot.look_at(translation + direction_input.normalized(), Vector3.UP)

	# Ground velocity
	velocity.x = direction_input.x * speed
	velocity.z = direction_input.z * speed

	# Gravity
	velocity.y -= fall_acceleration * delta

	# Jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.x = direction_input.x * jump_impulse
		velocity.z = direction_input.z * jump_impulse
		velocity.y = jump_impulse

	# Move character
	velocity = move_and_slide(velocity, Vector3.UP)


