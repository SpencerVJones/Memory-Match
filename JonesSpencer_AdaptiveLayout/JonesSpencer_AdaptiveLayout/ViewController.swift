//  ViewController.swift
//  JonesSpencer_AdaptiveLayout
//  Created by Spencer Jones on 5/12/24.
//  Play and stop buttons from https://www.freepik.com/

import UIKit

class ViewController: UIViewController {
    
    // Image View Outlets
    // Row 0
    @IBOutlet var R0C0: UIImageView!
    @IBOutlet var R0C1: UIImageView!
    @IBOutlet var R0C2: UIImageView!
    @IBOutlet var ROC3: UIImageView!
    @IBOutlet var R0C4: UIImageView! // iPad only
    // Row 1
    @IBOutlet var R1C0: UIImageView!
    @IBOutlet var R1C1: UIImageView!
    @IBOutlet var R1C2: UIImageView!
    @IBOutlet var R1C3: UIImageView!
    @IBOutlet var R1C4: UIImageView! // iPad only
    // Row 2
    @IBOutlet var R2C0: UIImageView!
    @IBOutlet var R2C1: UIImageView!
    @IBOutlet var R2C2: UIImageView!
    @IBOutlet var R2C3: UIImageView!
    @IBOutlet var R2C4: UIImageView! // iPad only
    // Row 3
    @IBOutlet var R3C0: UIImageView!
    @IBOutlet var R3C1: UIImageView!
    @IBOutlet var R3C2: UIImageView!
    @IBOutlet var R3C3: UIImageView!
    @IBOutlet var R3C4: UIImageView! // iPad only
    // Row 4
    @IBOutlet var R4C0: UIImageView!
    @IBOutlet var R4C1: UIImageView!
    @IBOutlet var R4C2: UIImageView!
    @IBOutlet var R4C3: UIImageView!
    @IBOutlet var R4C4: UIImageView! // iPad only
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var matchesLabel: UILabel!
    @IBOutlet var movesLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    
    // Rotated outlets
    @IBOutlet var rotatedMatchesLabel: UILabel!
    @IBOutlet var rotatedMovesLabel: UILabel!
    @IBOutlet var rotatedPlayButton: UIButton!
    @IBOutlet var rotatedTimerLabel: UILabel!
    
    
    // Array of images for iPhone
    var iPhoneImageArray = [
        UIImage(named: "Paintbrush"),
        UIImage(named: "Pallet"),
        UIImage(named: "CD"),
        UIImage(named: "Headphones"),
        UIImage(named: "Mic"),
        UIImage(named: "Radio"),
        UIImage(named: "Speaker"),
        UIImage(named: "RockOn"),
        UIImage(named: "Treble"),
        UIImage(named: "Piano")
    ]
    
    // Array of images for iPad
    var iPadImageArray = [
        UIImage(named: "Book"),
        UIImage(named: "Books"),
        UIImage(named: "CD"),
        UIImage(named: "Eraser"),
        UIImage(named: "Eyedropper"),
        UIImage(named: "Headphones"),
        UIImage(named: "Mic"),
        UIImage(named: "Paintbrush"),
        UIImage(named: "Pallet"),
        UIImage(named: "Pen"),
        UIImage(named: "Radio"),
        UIImage(named: "RockOn"),
        UIImage(named: "Speaker"),
        UIImage(named: "Treble"),
        UIImage(named: "Piano")
    ]
    
    var imageViewRows: [[UIImageView]] = []
    var gameRunning = false
    
    // Variables to track images
    var shuffledImages: [UIImage] = []
    var selectedImages: [UIImageView] = []
    var matchedImages: Set<UIImage> = []
    
    // Variables to track matches and moves
    var remainingMatches = 0
    var totalMatches = 0
    var totalMoves = 0
    
    // Timer Variables
    var timer: Timer?
    var startTime: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Determine if iPad
        let isiPad = UIDevice.current.userInterfaceIdiom == .pad
        
        // 2D array for Image Views
        if isiPad {
            imageViewRows = [ // iPad
                [R0C0, R0C1, R0C2, ROC3, R0C4], // Row 0
                [R1C0, R1C1, R1C2, R1C3, R1C4], // Row 1
                [R2C0, R2C1, R2C2, R2C3, R2C4], // Row 2
                [R3C0, R3C1, R3C2, R3C3, R3C4], // Row 3
                [R4C0, R4C1, R4C2, R4C3, R4C4]  // Row 4
            ]
        } else {
            imageViewRows = [ // iPhone
                [R0C0, R0C1, R0C2, ROC3], // Row 0
                [R1C0, R1C1, R1C2, R1C3], // Row 1
                [R2C0, R2C1, R2C2, R2C3], // Row 2
                [R3C0, R3C1, R3C2, R3C3], // Row 3
                [R4C0, R4C1, R4C2, R4C3]  // Row 4
            ]
        }
        
        // Tap gestures for image views
        for row in imageViewRows {
            for imageView in row {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
                imageView.addGestureRecognizer(tapGesture)
                imageView.isUserInteractionEnabled = true
            }
        }
        
        // Starting label values
        matchesLabel.text = "Matches: \(totalMatches)"
        movesLabel.text = "Moves: \(totalMoves)"
        rotatedMatchesLabel.text = "Matches: \(totalMatches)"
        rotatedMovesLabel.text = "Moves: \(totalMoves)"
        
        // Hide timers
        timerLabel.isHidden = true
        rotatedTimerLabel.isHidden = true
    }
    
    // MARK: Storyboard actions
    @IBAction func playButtonTapped(_ sender: UIButton) {
        // Reset game state
        totalMoves = 0
        totalMatches = 0
        updateLabels()
        
        if gameRunning {
            stopGame()
        } else {
            startGame()
        }
    }
    
    func updateLabels() {
        // Update labels with current game state
        matchesLabel.text = "Matches: \(totalMatches)"
        movesLabel.text = "Moves: \(totalMoves)"
        rotatedMatchesLabel.text = "Matches: \(totalMatches)"
        rotatedMovesLabel.text = "Moves: \(totalMoves)"
    }
    
    func startGame() {
        // Reset game state
        gameRunning = true
        totalMatches = 0
        totalMoves = 0
        
        // Hide timers
        timerLabel.isHidden = false
        rotatedTimerLabel.isHidden = false
        
        // Update play button image
        playButton.setImage(UIImage(named: "Stop"), for: .normal)
        rotatedPlayButton.setImage(UIImage(named: "Stop"), for: .normal)
        
        // Start timer
        startTimer()
        
        // Use different array depending on iPhone or iPad
        let imageArray = UIDevice.current.userInterfaceIdiom == .pad ? iPadImageArray : iPhoneImageArray
        
        // Shuffle image array
        shuffledImages = (imageArray.compactMap { $0 } + imageArray.compactMap { $0 }).shuffled()
        
        var currentIndex = 0
        
        for row in 0..<imageViewRows.count {
            for col in 0..<imageViewRows[row].count {
                // Assign images to outlets
                imageViewRows[row][col].image = shuffledImages[currentIndex]
                
                // Move to next image in shuffled array
                currentIndex += 1
            }
        }
        
        // Hide images after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            for row in 0..<self.imageViewRows.count {
                for col in 0..<self.imageViewRows[row].count {
                    self.imageViewRows[row][col].image = UIImage(named: "Background")
                }
            }
        }
        
        remainingMatches = imageArray.count
        matchedImages.removeAll()
        selectedImages.removeAll()
    }
    
    // Function to find index of image view in imageViewRows array
    func indexOfImageView(_ imageView: UIImageView) -> (Int, Int)? {
        for (rowIndex, row) in imageViewRows.enumerated() {
            if let colIndex = row.firstIndex(of: imageView) {
                return (rowIndex, colIndex)
            }
        }
        return nil
    }
    
    // Function to handle image view tapped
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        guard gameRunning, !selectedImages.contains(tappedImageView), !matchedImages.contains(tappedImageView.image!) else { return }
        
        // Reveal image
        if let index = imageViewRows.flatMap({ $0 }).firstIndex(of: tappedImageView) {
            tappedImageView.image = shuffledImages[index]
        }
        
        selectedImages.append(tappedImageView)
        
        // Check for match
        if selectedImages.count == 2 {
            if selectedImages[0].image == selectedImages[1].image {
                matchedImages.insert(selectedImages[0].image!)
                remainingMatches -= 1
                
                // Delay before removing matched images
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.removeMatchedImages()
                    
                    // Check if game over
                    if self.remainingMatches == 0 {
                        self.gameRunning = false
                        self.stopTimer()
                        self.playButton.setImage(UIImage(named: "Play"), for: .normal)
                        self.rotatedPlayButton.setImage(UIImage(named: "Play"), for: .normal)
                        
                        // Show game over message
                        let alert = UIAlertController(title: "Congratulations!", message: "You matched all pairs!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                // No match, flip back after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.flipSelectedImages()
                }
            }
        }
    }
    
    
    // Function to remove matched images
    func removeMatchedImages() {
        totalMatches += 1
        totalMoves += 1
        updateLabels()
        
        // Disable user interaction while matches are displayed
        view.isUserInteractionEnabled = false
        
        // Remove matches
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.selectedImages.forEach { $0.image = nil }
            self.selectedImages.removeAll()
            
            // Enable user interaction after matcheds removed
            self.view.isUserInteractionEnabled = true
            
            // Check if game  over
            if self.remainingMatches == 0 {
                self.gameRunning = false
                self.playButton.setImage(UIImage(named: "Play"), for: .normal)
                self.rotatedPlayButton.setImage(UIImage(named: "Play"), for: .normal)
                
                // Show game over message
                let alert = UIAlertController(title: "Congratulations!", message: "You Won!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    
    // Function to flip selected images back over
    func flipSelectedImages() {
        totalMoves += 1
        updateLabels()
        
        // Disable tap gesture recognizers to prevent extra selections
        imageViewRows.forEach { row in
            row.forEach { imageView in
                imageView.gestureRecognizers?.forEach { recognizer in
                    recognizer.isEnabled = false
                }
            }
        }
        
        // Flip selected images back over after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.selectedImages.forEach { imageView in
                UIView.transition(with: imageView, duration: 0.0, options: .transitionFlipFromLeft, animations: {
                    imageView.image = UIImage(named: "Background")
                }, completion: { _ in
                    // Re-enable tap gesture recognizers after flipping
                    self.imageViewRows.forEach { row in
                        row.forEach { imageView in
                            imageView.gestureRecognizers?.forEach { recognizer in
                                recognizer.isEnabled = true
                            }
                        }
                    }
                })
            }
            
            // Clear selectedImages array
            self.selectedImages.removeAll()
        }
    }
    
    
    // Function to stop game and set the view to background image
    func stopGame() {
        gameRunning = false
        stopTimer()
        
        // Update play button image
        playButton.setImage(UIImage(named: "Play"), for: .normal)
        rotatedPlayButton.setImage(UIImage(named: "Play"), for: .normal)
        
        for row in 0..<imageViewRows.count {
            for col in 0..<imageViewRows[row].count {
                imageViewRows[row][col].image = UIImage(named: "Background")
            }
        }
        
        // Reset timer to 0
        timerLabel.text = "00:00"
        rotatedTimerLabel.text = "00:00"
        
        // Hide timers
        timerLabel.isHidden = true
        rotatedTimerLabel.isHidden = true
        
    }
    
    // Function to start timer
    func startTimer() {
        startTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // Function to stop timer
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        startTime = nil
    }
    
    // Function to update timer label
    @objc func updateTimer() {
        guard let startTime = startTime else { return }
        let elapsedTime = Date().timeIntervalSince(startTime)
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        rotatedTimerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        
    }
}
