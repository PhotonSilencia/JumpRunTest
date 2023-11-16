extends CharacterBody2D

signal squashed

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if velocity.x >= 0:
		velocity.x = 200
		
	if is_on_wall() or not $Direction/Sprite2D/RayCast2D.is_colliding():
		velocity.x *= -1
		$Direction.scale.x = -$Direction.scale.x
		$AnimatedSprite2D.flip_h = velocity.x < 0

	move_and_slide()
	
#	for i in get_slide_collision_count():
#		var collision = get_slide_collision(i)
#		print("I collided with ", collision.get_collider().name)

func squash():
	squashed.emit()
	queue_free()
