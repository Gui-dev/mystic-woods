extends KinematicBody2D
class_name Slime


var player_ref = null
var velocity: Vector2
var can_die: bool = false
onready var texture: Sprite = $texture
onready var animation: AnimationPlayer = $animation
export(int) var speed


func _physics_process(_delta: float) -> void:
  move()
  verify_direction()
  animate()
  

func move() -> void:
  if player_ref != null:
    var distance: Vector2 = player_ref.global_position - global_position
    var direction: Vector2 = distance.normalized()
    var distance_length: float = distance.length()
    
    if distance_length <= 5:
      player_ref.kill()
      velocity = Vector2.ZERO
    else:
      velocity = speed * direction
  else:
    velocity = Vector2.ZERO
    
  velocity = move_and_slide(velocity)


func verify_direction() -> void:
  if velocity.x > 0:
    texture.flip_h = false
  else:
    texture.flip_h = true


func animate() -> void:
  if can_die:
    animation.play('dead')
    set_physics_process(false)
  elif velocity != Vector2.ZERO:
    animation.play('walk')
  else:
    animation.play('idle')


func _on_detection_area_body_entered(body: Node) -> void:
  if body.is_in_group('player'):
    player_ref = body as Player


func _on_detection_area_body_exited(body: Node) -> void:
  if body.is_in_group('player'):
    player_ref = null


func kill(area: Area2D) -> void:
  if area.is_in_group('player_attack'):
    can_die = true


func _on_animation_finished(anim_name: String) -> void:
  if anim_name == 'dead':
    queue_free()
