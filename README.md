# KulleR.su

[![Docker Build](https://github.com/2rage/kuller_su/actions/workflows/docker-build.yml/badge.svg)](https://github.com/2rage/kuller_su/actions/workflows/docker-build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Old project of my game server based on the San Andreas Multiplayer client.

## ToDo:
- [x] Compile and run latest v.23-2f gamemode
- [x] Create config for vscode for a right encoding suggestion (CP-1251)
- [x] Create a Dockerfile for easy installation SA-MP server
- [x] Configure .gitignore for server files
- [x] Rewrite documentation for installation through ```make```
- [ ] Adapt SA-MP mod for open.mp server
- [ ] Attempt to restore the IPB forum engine



## File Structure

| Path | Content |
| ---- | ------- |
| `fm/` | Radio fm.kuller.su |
| `samp_mod/*/` | SA-MP server (Game mod, Scripts, Plugins) |
| `kuller.su/` | Main forum with some integrations for the SA-MP server |
|  `docs` | Documentation folder


## Technology Stack:

- [PAWN](https://github.com/pawn-lang/compiler) - Game modification language
- [Invision Power Board](https://invisioncommunity.com/files/) - Forum for the server
- [MySQL](https://www.mysql.com) - Database management system for IPB and sync with game client
- [Data Life Engine](https://dle-news.ru) - Engine for the FM and unreleased main site

## Installation

See under the [docs folder](docs/installation.md)


## License

KulleR.su project is licensed under the [MIT license](LICENSE)


## Some screenshots from SAMP server

![server release date](img/image1.png)

![gameplay](img/image2.png)

![gameplay](img/image3.png)


## Old gameplay video from server

[![Watch the video](https://img.youtube.com/vi/9pzrdIPB-g8/0.jpg)](https://youtu.be/9pzrdIPB-g8)


