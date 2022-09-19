extends AnimatedSprite
class_name RunParticles


func play_particles() -> void:
  play()


func _on_animation_finished() -> void:
  queue_free()
