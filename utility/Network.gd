extends Node

## server config
const PORT: int = 80
const MAX_CLIENTS: int = 4

## runtime variables
var is_standalone: bool = false
var players: Dictionary = {}

## server functions
# start a multiplayer server
# `standalone` is true if the server is not also a player
func start_lobby(standalone: bool = true) -> void:
	is_standalone = standalone
	
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	peer.peer_connected.connect(_on_peer_connected_to_lobby)
	peer.peer_disconnected.connect(_on_peer_disconnected_from_lobby)
	multiplayer.multiplayer_peer = peer

func start_lobby_as_client() -> void:
	start_lobby(false)
	
	players[get_tree().get_network_unique_id()] = "player"

func join_lobby(ip_address: String) -> void:
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(ip_address, PORT)
	multiplayer.multiplayer_peer = peer

func _on_peer_connected_to_lobby(id: int) -> void:
	players[id] = "player"
	
func _on_peer_disconnected_from_lobby(id: int) -> void:
	players.erase(id)
