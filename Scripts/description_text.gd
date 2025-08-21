extends RichTextLabel

func _ready():
    _update_text()
    Global.connect("ChangedDescription", _update_text)

func _update_text() -> void:
    text = Global.Selected_Description
