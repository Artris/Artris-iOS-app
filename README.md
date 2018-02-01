# ARTris - Game Engine

## Description
ARTris is a multi-player real-time 3D AR Tetris game made with ARKit. 

## Installation

### Project Setup

On the terminal: 

    ```sh
    $ git clone https://github.com/Artris/Artris-iOS-app.git

    $ cd Artris-iOS-app/

    $ pod install
    ```
Open the ARTris.xcodeproj on XCode to build the application!


### Configuration

1. Create a Firebase project on [Firebase](https://console.firebase.google.com/)
2. Click "Add iOS app to project", this will provide a config file. It will ask for app bundle ID which can be found in the Xcode project
3. Add this config file to your Xcode project root directory!


## Specification
`Game`
  - `Action` holds unto the direction of a swipe in a view and orientation of the device when the swipe happens
  - `Blocks` setting the blocks variable triggers a chain of observers to render a new state of the game
  - `Engine` proxy for handling a new state returned by Firebase
  - `GameViewController` holds the configuration for anything related to the game after localization
  - `Interactions` helper class for mapping a swipe direction on a view to a direction in the game coordinate system
  
`GameSessionSetup`
  - `InitialSceneViewController` shows a UI for starting a game or joining an ongoing one
  - `GameSessionList` tableview showing a list of game sessions 
  
  `LicencedFiles` 
  - `Utitilies` utility functions and type extensions throughout the project (made by Apple)
  - `VirtualObjectARView` custom ARSCNView (made by Apple)

`Localization`
  - `LocalizationViewController` handles the placing of the grid for multiplayer localization

`Supporting Files`
  - `Firebase` handles all communication with Firebase
  - `GridShadow` renders a 3D or 2D grid
  
  ![Alt Text](https://media.giphy.com/media/26wkFY3lu3ICfvNXW/giphy.gif)
  

