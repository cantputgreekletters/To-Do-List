extends Label

class_name FadingLabel

var _start_fading : bool = false
func _ready():
    modulate.a = 0

func FadeIn() -> void:
    modulate.a = 1
    _start_fading = true

func _process(_delta):
    if (_start_fading):
        modulate.a -= 0.01
        if(modulate.a == 0):
            _start_fading = false
    