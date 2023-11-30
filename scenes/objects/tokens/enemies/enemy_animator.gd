extends AnimatedSprite2D

class_name EnemyAnimator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_looped.connect(_on_animation_finished)
	idle()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass

func jump() -> void:
	play("jump", true)
	
	
func idle() -> void:
	play("idle", )	

func _on_animation_finished() -> void:
	if animation == "jump":
		idle()
	
	
