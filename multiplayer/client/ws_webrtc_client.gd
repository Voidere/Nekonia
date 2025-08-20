extends Node

enum Message {JOIN, ID, PEER_CONNECT, PEER_DISCONNECT, OFFER, ANSWER, CANDIDATE, SEAL}

@export var autojoin := true
@export var lobby := "" # Will create a new lobby if empty.
@export var mesh := true # Will use the lobby host as relay otherwise.

var ws: WebSocketPeer = WebSocketPeer.new()
var code = 1000
var reason = "Unknown"
var old_state = WebSocketPeer.STATE_CLOSED

signal lobby_joined(lobby)
signal connected(id, use_mesh)
signal disconnected()
signal peer_connected(id)
signal peer_disconnected(id)
signal offer_received(id, offer)
signal answer_received(id, answer)
signal candidate_received(id, mid, index, sdp)
signal lobby_sealed()


func connect_to_url(url):
	close()
	code = 1000
	reason = "Unknown"
	ws.connect_to_url(url)


func close():
	ws.close()


func _process(delta):
	ws.poll()
	var state = ws.get_ready_state()
	if state != old_state and state == WebSocketPeer.STATE_OPEN and autojoin:
		join_lobby(lobby)
	while state == WebSocketPeer.STATE_OPEN and ws.get_available_packet_count():
		if not _parse_msg():
			print("Error parsing message from server.")
	if state != old_state and state == WebSocketPeer.STATE_CLOSED:
		code = ws.get_close_code()
		reason = ws.get_close_reason()
		disconnected.emit()
	old_state = state


func _parse_msg():
	var packet = ws.get_packet()
	var json_str = packet.get_string_from_utf8()
	print("Received raw message: ", json_str)  # Debug log
	
	var parsed = JSON.parse_string(json_str)
	if parsed == null:
		print("Failed to parse JSON")
		return false
		
	if typeof(parsed) != TYPE_DICTIONARY:
		print("Message is not a dictionary, got type: ", typeof(parsed))
		return false
		
	if not parsed.has("type"):
		print("Message missing 'type' field")
		return false
		
	if not parsed.has("id"):
		print("Message missing 'id' field")
		return false
		
	if typeof(parsed.get("data")) != TYPE_STRING:
		print("'data' field is not a string, got type: ", typeof(parsed.get("data")))
		return false

	var msg := parsed as Dictionary
	if typeof(msg.type) != TYPE_INT and typeof(msg.type) != TYPE_FLOAT:
		print("'type' is not a number: ", msg.type)
		return false
		
	if typeof(msg.id) != TYPE_INT and typeof(msg.id) != TYPE_FLOAT:
		print("'id' is not a number: ", msg.id)
		return false

	var type := int(msg.type)
	var src_id := int(msg.id)

	if type == Message.ID:
		connected.emit(src_id, msg.data == "true")
	elif type == Message.JOIN:
		lobby_joined.emit(msg.data)
	elif type == Message.SEAL:
		lobby_sealed.emit()
	elif type == Message.PEER_CONNECT:
		# Client connected
		peer_connected.emit(src_id)
	elif type == Message.PEER_DISCONNECT:
		# Client connected
		peer_disconnected.emit(src_id)
	elif type == Message.OFFER:
		# Offer received
		offer_received.emit(src_id, msg.data)
	elif type == Message.ANSWER:
		# Answer received
		answer_received.emit(src_id, msg.data)
	elif type == Message.CANDIDATE:
		# Candidate received
		var candidate: PackedStringArray = msg.data.split("\n", false)
		if candidate.size() != 3:
			return false
		if not candidate[1].is_valid_int():
			return false
		candidate_received.emit(src_id, candidate[0], candidate[1].to_int(), candidate[2])
	else:
		return false
	return true # Parsed


func join_lobby(lobby: String):
	return _send_msg(Message.JOIN, 0 if mesh else 1, lobby)


func seal_lobby():
	return _send_msg(Message.SEAL, 0)


func send_candidate(id, mid, index, sdp) -> int:
	return _send_msg(Message.CANDIDATE, id, "\n%s\n%d\n%s" % [mid, index, sdp])


func send_offer(id, offer) -> int:
	return _send_msg(Message.OFFER, id, offer)


func send_answer(id, answer) -> int:
	return _send_msg(Message.ANSWER, id, answer)


func _send_msg(type: int, id: int, data:="") -> int:
	return ws.send_text(JSON.stringify({
		"type": type,
		"id": id,
		"data": data
	}))
