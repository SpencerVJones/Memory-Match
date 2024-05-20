# Memory-Match
A fun and engaging memory game for iOS, developed using Swift. This project features a grid of cards that players can flip to match pairs of images.

## Features
- **Dynamic Grid Layout**: Adapts to both iPhone and iPad screen sizes.
- **Image Matching**: Players can flip cards to find matching pairs.
- **Timer**: Tracks the time taken to complete the game.
- **Move Counter**: Counts the number of moves taken.
- **Match Counter**: Counts the number of matches made.
- **Responsive UI**: Provides feedback and transitions for user actions.

## Usage
- **Start the Game:** Press the play button to start a new game. The images will be shown for a few seconds before being hidden.
- **Flip Cards:** Tap on any card to flip it and reveal the image. Try to find and match all pairs of images.
- **Track Your Progress:** The timer, moves counter, and matches counter will update as you play. When all pairs are matched, the game ends, and you will be notified of your success.

## Code Overview
### ViewController
- `viewDidLoad`: Initializes the game board and sets up tap gestures.
- `playButtonTapped`: Starts or stops the game.
- `imageViewTapped`: Handles the logic for flipping cards and checking for matches.
- `startGame`: Shuffles images and starts the game.
- `stopGame`: Resets the game.
- `updateTimer`: Updates the timer label using DateComponentsFormatter.
### UI Elements
- **Image Views**: Represent the cards on the game board.
- **Labels**: Display the number of matches, moves, and the elapsed time.
- **Buttons**: Start and stop the game.

## Technologies Used
- **Swift**: The primary programming language used for iOS development.
- **UIKit**: Framework used to construct and manage the user interface.
- **Xcode**: Integrated development environment (IDE) for macOS.
- **Auto Layout**: Used for designing adaptive and responsive UI layouts.
- **DateComponentsFormatter**: Used to format the time elapsed during the game.

## Acknowledgments
- Thanks to Freepik for the images used in the game.
- All memory immages from Full Sail University.
- Inspired by classic memory games.

## Contributing
Contributions are welcome! 
