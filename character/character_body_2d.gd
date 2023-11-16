extends CharacterBody2D

signal hit

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead = false
var counter = 0

@onready var starting_position = global_position

@export var bounce_impulse = 16


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()
		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Mob":
			var mob = collision.get_collider()
			if Vector2.UP.dot(collision.get_normal()) > 0.5:
				mob.squash()
				velocity.y = bounce_impulse
			else:
#				global_position = starting_position
				is_dead = true
	
	if is_dead:
		process_death()

				
func die():
	is_dead = true

func process_death():
	rotation += 1
	counter += 1
	position.y -= 20
	velocity.y = 0
	if counter > 100:
		global_position = starting_position
		is_dead = false
		rotation = 0
		counter = 0
