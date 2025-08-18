extends Window

@onready var TitleLabel : Label = $MainContainer/TitleLabel
@onready var DescrLabel : RichTextLabel = $MainContainer/DescriptionLabel

func _ready():
    Global.has_active_window = true
    connect("close_requested", queue_free)

func _exit_tree() -> void:
    Global.has_active_window = false

func Init(Title : String, Description : String = "") -> void:
    TitleLabel.text = Title
    DescrLabel.text = Description
