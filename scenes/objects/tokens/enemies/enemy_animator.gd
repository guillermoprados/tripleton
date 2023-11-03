extends AnimatedSprite2D

class_name EnemyAnimator

# Called when the node enters the scene tree for the first time.
func _ready():
	idle()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func jump():
	play("jump", true)
	
	
func idle():
	play("idle", )	

func _on_animation_looped():
	if animation == "jump":
		idle()
	
