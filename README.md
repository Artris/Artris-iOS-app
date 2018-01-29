# ARTris Game Engine
ARTris is a multi-player real-time 3D AR Tetris game made with ARKit. 

## In this repo
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
  

