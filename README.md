# Godot Platformer - Quick Reference

## 📁 Project Files

| File | Description |
|------|-------------|
| `scripts/player.gd` | CharacterBody2D movement and physics |
| `scripts/camera_follow.gd` | Camera2D smooth follow system |
| `scripts/heart.gd` | Area2D collectible with signals |
| `scripts/level_manager.gd` | Singleton for level management (AutoLoad) |
| `scripts/ui/message_popup.gd` | Message display UI |
| `scripts/ui/title_screen.gd` | Title screen |

## 🎮 Controls

- **Move**: Arrow Keys / A/D
- **Jump**: Space

## 📖 Full Setup Guide

See godot_setup_guide.md artifact for complete scene creation instructions.

## ⚡ Quick Start

1. Download Godot 4.3+ from godotengine.org
2. Import project from `d:\Game\GodotPlatformer\`
3. Follow setup guide to create scenes
4. Press F5 to run!

## 🔧 Key Godot Features

- CharacterBody2D for player physics
- ParallaxBackground for automatic scrolling
- Signals for event communication
- AutoLoad singleton for global state
- Scene instancing for prefabs

## 📦 Advantages

✅ Tiny engine (~50MB download)
✅ GDScript is Python-like
✅ Open source and free
✅ Built-in 2D tools
✅ Fast iteration
