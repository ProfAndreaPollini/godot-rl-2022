extends Object

var _message: String = ""
var _start_time: int = 0

func start(message: String):
	print(message)
	_message = message
	_start_time = OS.get_ticks_msec() 
	
func stop():
	var total_time = OS.get_ticks_msec() - _start_time
	print("{message} (completed in {total_time} ms)".format({
		"message": _message,
		"total_time": total_time
	}))
