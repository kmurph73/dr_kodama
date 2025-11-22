# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**MadDots (Dr. Kodama)** is a tile-matching puzzle game for iOS written in Swift, similar to Dr. Mario or Puyo Puyo. Players rotate and move falling 2-dot pieces on an 8x16 grid, clearing chains of 4+ same-colored dots. The game features 20 levels with special "MadDots" obstacles and an "Angry Kodama" pressure mechanic.

Published on App Store: https://apps.apple.com/us/app/dr-kodama/id1060934796

## Build and Test Commands

### Building the Project
```bash
# Open project in Xcode
open /Users/kmurph/code/swift/dr_kodama/MadDots.xcodeproj

# Build from command line (if xcodebuild is available)
xcodebuild -project MadDots.xcodeproj -scheme MadDots -configuration Debug build
```

### Running Tests
```bash
# Run all tests
xcodebuild test -project MadDots.xcodeproj -scheme MadDots -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test file
xcodebuild test -project MadDots.xcodeproj -scheme MadDots -only-testing:MadDotsTests/GameLevelsTests

# Run single test method
xcodebuild test -project MadDots.xcodeproj -scheme MadDots -only-testing:MadDotsTests/pieceRotation/testRotation
```

**Test Files:**
- `MadDotsTests/ChainHandler.swift` - Chain detection algorithm tests
- `MadDotsTests/pieceRotation.swift` - Piece rotation and wall kick tests
- `MadDotsTests/GameLevelsTests.swift` - Level generation tests
- `MadDotsTests/MadDotsTests.swift` - General game logic tests

## Architecture Overview

### MVC + Game Loop Pattern

```
UI Layer (View Controllers)
    ↓
Game Logic Layer (DotGame + Game State)
    ↓
Scene/Rendering Layer (GameScene + SpriteKit)
    ↓
Data Model Layer (Dot, Piece, DotArray2D, Level)
```

### Core Components

| Component | File | Responsibility |
|-----------|------|----------------|
| **DotGame** | `DotGame.swift` | Core game logic: piece movement, collision detection, chain removal, win/lose conditions |
| **GameScene** | `GameScene.swift` | SpriteKit rendering: draws grid, animates pieces/dots, particle effects, timer management |
| **GameViewController** | `GameViewController.swift` | Input handling (gestures), game flow coordination, UI alerts, delegates to DotGame |
| **Piece** | `Piece.swift` | 2-dot falling piece model with rotation system and sibling relationships |
| **DotArray2D** | `DotArray2D.swift` | 8x16 game grid management using generic `Array2D<T>` base class |
| **HandleChains** | `HandleChains.swift` | Chain detection algorithm (scans for 4+ consecutive same-colored dots) |
| **GameLevels** | `GameLevels.swift` | Procedural level generation with MadDot obstacle placement |

### Key Architectural Patterns

**1. Delegate Pattern**
- `DotGameDelegate` protocol decouples game logic from UI
- Callbacks: `gameDidBegin()`, `gamePieceDidMove()`, `gamePieceDidLand()`, `gameDidEnd()`

**2. Sibling Relationship Pattern**
- Two-dot pieces are linked: `dot1.sibling = dot2`
- Used for visual connector rendering and piece validation
- Must be cleaned up when dots are removed

**3. Closure-based Async Animations**
```swift
func dropDots(_ fallenDots: [GoodDot], completion: @escaping () -> ())
```
- Enables cascading logic: detect chains → remove → drop → detect again

**4. Global State Management**
- Game settings stored in `Globals.swift` and persisted to UserDefaults
- Key settings: `GameLevel`, `GameSpeed`, `NumberOfColors`, `ShowNextPiece`, `AngryKodama`
- Initialized in `AppDelegate.assessState()`

### Rendering Technology

**SpriteKit** (2D sprite engine):
- Individual dots rendered as `SKSpriteNode` with pre-rendered PNG textures
- Texture atlases: `Sprites.atlas` (colored dots), `AngryKodama` (3-frame animation)
- Pre-calculated grid positions cached in `points: Array2D<PointStore>` for performance
- Animations use `SKAction.move(to:duration:)` with easeIn timing
- No Metal, SceneKit, or custom rendering

### Game Loop Flow

```
Timer (0.07-2.0s interval based on speed)
    ↓
GameScene.didTick() → GameViewController.didTick()
    ↓
DotGame.lowerPiece() (gravity)
    ↓
Collision detection → Piece lands
    ↓
gamePieceDidLand() → findAllChains()
    ↓
removeCompletedDots() → Animate removal
    ↓
dropFallenDots() → Apply gravity
    ↓
Repeat chain detection until stable
    ↓
Spawn new piece
```

### Data Model Hierarchy

```
Dot (abstract base)
├── GoodDot (player-placed dots from pieces)
│   └── Has connector property for sibling visualization
└── MadDot (grid obstacles to clear, can be "angry")
    └── Animated sprite when angry (3-frame kodama animation)
```

### Input Handling (GameViewController)

- **Tap gesture**: Rotate piece (calls `DotGame.rotatePiece()`)
- **Pan gesture**: Move left/right/down (calls `movePieceLeft/Right/Down()`)
- **Swipe up**: Hard drop (calls `DotGame.dropPiece()`)
- `CanMovePiece` global flag locks input during animations

## File Organization

```
/MadDots/
├── AppDelegate.swift              # App lifecycle, UserDefaults initialization
├── MainController.swift           # Home screen / menu
├── GameViewController.swift       # Main game screen, input handling
├── SettingsController.swift       # Settings UI
├── HelpViewController.swift       # Help screen
├── AboutAngryViewController.swift # About angry kodama feature
│
├── DotGame.swift                  # Core game logic engine
├── GameScene.swift                # SpriteKit rendering
├── MainScene.swift                # Menu scene
│
├── Piece.swift                    # Falling piece model + rotation
├── Dot.swift                      # Base dot class
├── GoodDot.swift                  # Player-placed dots
├── MadDot.swift                   # Obstacle dots
├── DotArray2D.swift               # 8x16 grid wrapper
├── Array2D.swift                  # Generic 2D array base class
│
├── HandleChains.swift             # Chain detection algorithm
├── GameLevels.swift               # Level generation (LevelMaker)
├── Globals.swift                  # Global state + UserDefaults keys
│
├── Utilities.swift                # Helper functions
├── AppUtilities.swift             # App-level utilities
├── Extensions.swift               # Swift extensions
├── DeviceType.swift               # Device detection
│
├── Sprites.atlas/                 # Dot sprite textures
├── AngryKodama.atlas/             # Angry dot animation frames
├── Background.atlas/              # Background images
├── Assets.xcassets/               # App icons, launch images
└── Base.lproj/                    # Storyboards and XIBs

/MadDotsTests/
├── ChainHandler.swift             # Chain detection tests
├── pieceRotation.swift            # Rotation and wall kick tests
├── GameLevelsTests.swift          # Level generation tests
└── MadDotsTests.swift             # General game logic tests
```

## Common Development Patterns

### Adding a New Dot Type
1. Create subclass of `Dot` in a new file
2. Add color/texture property
3. Update `GameScene.addDotToScene()` to handle new type
4. Update `LevelMaker` if it should appear in levels

### Modifying Game Rules
- **Piece behavior**: Edit `DotGame.swift` methods (`movePiece*`, `rotatePiece`, `lowerPiece`)
- **Chain detection**: Edit `HandleChains.swift` (note: must update both horizontal and vertical scan logic)
- **Win/lose conditions**: Edit `DotArray2D.hasAchievedVictory()` or `hasDotsAboveGrid()`

### Adding New Animations
1. Create `SKAction` sequence in `GameScene.swift`
2. Use completion closures to chain animations
3. Set `CanMovePiece = false` during animation, restore to `true` when complete
4. Cache textures in `textureCache` dictionary for performance

### Modifying Rotation System
- Edit `Piece.swift` rotation methods and `Rotation` class
- Update wall kick translations in `Rotation.translations` array
- Test with `MadDotsTests/pieceRotation.swift`

## Important Implementation Details

**Grid Coordinate System:**
- Origin (0, 0) is **top-left** of grid
- 8 columns (x-axis), 16 rows (y-axis)
- Screen positions pre-calculated in `GameScene.points` array

**Piece Rotation:**
- Stores previous rotation for undo (enables wall kick detection)
- 4 rotation states with translation offsets for each state
- Always check `detectIllegalPlacement()` after rotation

**Chain Removal Sequence:**
1. Detect chains with `findAllChains()` (horizontal + vertical)
2. Remove dots from grid and scene
3. Apply gravity to remaining dots (animate downward)
4. Repeat steps 1-3 until no more chains found
5. Spawn new piece only after grid is stable

**Texture Cache:**
- Always check `textureCache` before loading textures
- Key format: `"\(color)dot"` (e.g., "reddot", "bluedot")
- Significantly improves performance (avoids disk I/O)

**Timer Management:**
- Pause timer when app backgrounds (`AppDelegate` sends notification)
- Resume when app foregrounds
- Timer interval calculated from `GameSpeed` setting (1-13)

**UserDefaults Keys:**
- All defined in `Globals.swift`
- Loaded in `AppDelegate.assessState()`
- Include: GameLevel, GameSpeed, NumberOfColors, ShowNextPiece, AngryKodama settings
