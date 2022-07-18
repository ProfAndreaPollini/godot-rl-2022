extends RichTextLabel


func set_message(message):
	var timeDict = Time.get_time_dict_from_system();
	var hour = timeDict.hour;
	var minute = timeDict.minute;
	var seconds = timeDict.second;
	
	bbcode_text = "{hh}:{mm}:{ss} {message}".format({
		"hh":hour,
		"mm": minute, 
		"ss":seconds, 
		"message":message
		})
