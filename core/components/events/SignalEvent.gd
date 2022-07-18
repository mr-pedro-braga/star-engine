extends __EventBase
class_name SignalEvent

signal triggered()

func _trigger():
	triggered.emit()

