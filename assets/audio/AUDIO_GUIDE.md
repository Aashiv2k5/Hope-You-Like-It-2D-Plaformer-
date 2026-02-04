# Audio Setup Guide

This guide will help you add audio files to your Godot platformer game.

## Required Audio Files

You need to download 3 audio files and place them in this folder (`assets/audio/`):

1. **background_music.ogg** - Background music (looping)
2. **heart_collect.wav** - Heart collection sound effect
3. **player_death.wav** - Player death sound effect

## Where to Get Free Audio

### Recommended Sources:

#### For Sound Effects (heart_collect.wav, player_death.wav):
- **OpenGameArt.org** - https://opengameart.org/art-search-advanced?keys=&field_art_type_tid%5B%5D=13
  - Search for "collect" or "coin" for heart collection sound
  - Search for "death" or "game over" for death sound
  - Download as WAV format

- **Mixkit** - https://mixkit.co/free-sound-effects/game/
  - High-quality game sound effects
  - Free to use, no attribution required

- **Zapsplat** - https://www.zapsplat.com/sound-effect-categories/
  - Thousands of free sound effects
  - Download in WAV format

#### For Background Music (background_music.ogg):
- **OpenGameArt.org** - https://opengameart.org/art-search-advanced?keys=&field_art_type_tid%5B%5D=12
  - Search for "ambient" or "romantic" or "calm"
  - Download as OGG format (or convert MP3 to OGG)

- **Chosic** - https://www.chosic.com/free-music/videogame/
  - Royalty-free video game music
  - Make sure to check license for each track

## File Format Requirements

- **Background Music**: Must be `.ogg` format (for looping)
- **Sound Effects**: Can be `.wav` or `.ogg` format
- Godot supports: OGG Vorbis, WAV, MP3

## Converting Audio Files

If you have MP3 files, you can convert them to OGG:
- **Online**: https://convertio.co/mp3-ogg/
- **Audacity** (free software): File → Export → Export as OGG Vorbis

## After Downloading

1. Place the audio files in this folder: `d:\Game\GodotPlatformer\assets\audio\`
2. Open your Godot project
3. The audio files will automatically be imported
4. The game scripts are already configured to use these files!

## Quick Recommendations

**Heart Collection Sound:**
- Look for "coin collect", "pickup", "chime", or "bell" sounds
- Should be short (0.1-0.5 seconds)
- Pleasant, positive tone

**Death Sound:**
- Look for "game over", "fail", "death", or "respawn" sounds
- Should be short (0.5-1.5 seconds)
- Not too harsh (this is a romantic game!)

**Background Music:**
- Look for "ambient", "calm", "romantic", "peaceful" music
- Should loop seamlessly
- Duration: 1-3 minutes recommended
- Soft, non-intrusive

## Example Search Terms

Try searching for these on the audio sites:
- "8-bit coin collect" or "pixel collect"
- "game over soft" or "respawn"
- "romantic ambient" or "peaceful loop"
