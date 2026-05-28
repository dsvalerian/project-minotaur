# project-minotaur

## Project Structure

```
global/          Autoloaded systems — always loaded, singletons, accessible everywhere
  signals.gd       Cross-system signals
  network/
	network_manager.gd   Connection management (host/join/leave)
	peer_manager.gd      Peer state and sync RPCs
	peer_store.gd        Peer data store
	peer_info.gd         Peer data class

features/        Game features — each self-contained in its own subfolder
  lobby/           Lobby UI and lobby logic
  characters/      Character base class and subclasses
  game_manager/    Controls everything after endtering the game
	

shared/          Assets and data referenced by multiple features
  enums.gd         Global enums (NetState, etc.)

main.tscn        Entry point
```

New feature = new folder under `features/`. Scripts, scenes, and assets that belong to one feature live together. Anything needed by two or more features goes in `shared/`. `global/` is infrastructure — it underpins features but is not a feature itself.
