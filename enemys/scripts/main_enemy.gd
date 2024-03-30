extends CharacterBody2D

var speed = 100
const GRAVITY = 32

func _physics_process(delta):	
	move()

func move():
	velocity.y += GRAVITY
	if (velocity.x == 0):
		speed *= -1
		velocity.x = speed
	move_and_slide()

