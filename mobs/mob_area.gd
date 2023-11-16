extends Area2D

signal hit

var velocity = Vector2.ZERO
var rotate = false

@onready var starting_position = global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

#	velocity.y += gravity * delta
	
	if velocity.x >= 0:
		velocity.x = 200
		
	position += velocity * delta

	if not $Direction/Sprite2D/RayCast2D.is_colliding():
		velocity.x *= -1
		$Direction.scale.x = -$Direction.scale.x
		$AnimatedSprite2D.flip_h = velocity.x < 0


func _on_body_entered(body):
	if not body.is_in_group("floor"):
		if body.velocity.y > 0:
			hide() 
			hit.emit()
			# Must be deferred as we can't change physics properties on a physics callback.
			$CollisionShape2D.set_deferred("disabled", true)
		else:
			if body.has_method("die"):
				body.die()
