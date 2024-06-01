//  ViewController.swift
//  JonesSpencer_AdaptiveLayout
//  Created by Spencer Jones on 5/12/24.
//  Play and stop buttons from https://www.freepik.com/
//  All matching images provided by Full Sail University

import UIKit
import CoreData

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
    
    // iPad only
    @IBOutlet var R5C0: UIImageView!
    @IBOutlet var R5C1: UIImageView!
    @IBOutlet var R5C2: UIImageView!
    @IBOutlet var R5C3: UIImageView!
    @IBOutlet var R5C4: UIImageView!
    
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var matchesLabel: UILabel!
    @IBOutlet var movesLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var leaderboardButton: UIButton!
    
    // Rotated outlets
    @IBOutlet var rotatedMatchesLabel: UILabel!
    @IBOutlet var rotatedMovesLabel: UILabel!
    @IBOutlet var rotatedPlayButton: UIButton!
    @IBOutlet var rotatedTimerLabel: UILabel!
    @IBOutlet var rotatedLeaderboardButton: UIButton!
    
    // Core Data Required Objects
    private var managedContext: NSManagedObjectContext!
    private var entityDescription: NSEntityDescription!
    private var topFiveScores: NSManagedObject!
    private var appDelegate: AppDelegate!
    
    
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
                [R4C0, R4C1, R4C2, R4C3, R4C4],  // Row 4
                [R5C0, R5C1, R5C2, R5C3, R5C4]  // Row 5
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
        
        // Hide matches and moves labels
        matchesLabel.isHidden = true
        movesLabel.isHidden = true
        rotatedMatchesLabel.isHidden = true
        rotatedMovesLabel.isHidden = true
        
        // Hide timers
        timerLabel.isHidden = true
        rotatedTimerLabel.isHidden = true
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        // Fill out entity description
        if let entity = NSEntityDescription.entity(forEntityName: "TopFiveScores", in: managedContext) {
            entityDescription = entity
        } else {
            print("Error: Entity description for 'TopFiveScores' is nil")
        }
        
        LoadAction(UIButton())
    }
    
    
    func initialUISetup() {
        // Starting label values
        matchesLabel.text = "Matches: \(totalMatches)"
        movesLabel.text = "Moves: \(totalMoves)"
        rotatedMatchesLabel.text = "Matches: \(totalMatches)"
        rotatedMovesLabel.text = "Moves: \(totalMoves)"
        
        // Show the leaderboard button
        leaderboardButton.isHidden = false
        
        // Hide matches and moves labels
        matchesLabel.isHidden = true
        movesLabel.isHidden = true
        rotatedMatchesLabel.isHidden = true
        rotatedMovesLabel.isHidden = true
        
        // Hide timers
        timerLabel.isHidden = true
        rotatedTimerLabel.isHidden = true
    }
    
    // MARK: Storyboard actions
    @IBAction func LoadAction(_ sender: Any) {
        // MARK: Load in the data
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TopFiveScores")
        
        do {
            
            let results:[NSManagedObject] = try managedContext.fetch(fetchRequest)
            
            for obj in results {
                print(obj.description)
                
                topFiveScores = obj
            }
        }
        catch {
            print("Error fetching data: \(error)")
        }
    }
    
    
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
        
        // Hide leaderboard button
        leaderboardButton.isHidden = true
        rotatedLeaderboardButton.isHidden = true
        
        // Unhide timers
        timerLabel.isHidden = false
        rotatedTimerLabel.isHidden = false
        
        // Unhide matches and moves
        matchesLabel.isHidden = false
        movesLabel.isHidden = false
        rotatedMatchesLabel.isHidden = false
        rotatedMovesLabel.isHidden = false
        
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
            
            // Disable user interaction for all image views
            imageViewRows.forEach { row in
                row.forEach { imageView in
                    imageView.isUserInteractionEnabled = false
                }
            }
            
            if selectedImages[0].image == selectedImages[1].image {
                matchedImages.insert(selectedImages[0].image!)
                remainingMatches -= 1
                
                // Delay before removing matched images
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.removeMatchedImages()
                    
                    // Re-enable user interaction after matched images are removed
                    self.imageViewRows.forEach { row in
                        row.forEach { imageView in
                            imageView.isUserInteractionEnabled = true
                        }
                    }
                    
                    // Check if game over
                    if self.remainingMatches == 0 {
                        self.gameRunning = false
                        self.stopTimer()
                        self.playButton.setImage(UIImage(named: "Play"), for: .normal)
                        self.rotatedPlayButton.setImage(UIImage(named: "Play"), for: .normal)
                    }
                }
            } else {
                // No match, flip back after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.flipSelectedImages()
                    
                    // Re-enable user interaction after images are flipped back
                    self.imageViewRows.forEach { row in
                        row.forEach { imageView in
                            imageView.isUserInteractionEnabled = true
                        }
                    }
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
                
                let date = Date()
                let numMoves = self.totalMoves
                let time = self.timerLabel.text ?? "00:00"
                
                // Alert to ask user for initals
                let alertController = UIAlertController(title: "Enter Initials", message: "Enter your initials for the high score", preferredStyle: .alert)
                alertController.addTextField { textField in
                    textField.placeholder = "Initials"
                }
                let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
                    if let initials = alertController.textFields?.first?.text, !initials.isEmpty {
                        self.saveScore(date: Date(), numMoves: self.totalMoves, time: self.timerLabel.text ?? "00:00", userInitials: initials)
                    }
                }
                alertController.addAction(confirmAction)
                self.present(alertController, animated: true, completion: nil)

                DispatchQueue.main.async {
                    self.initialUISetup()
                }
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
        
        DispatchQueue.main.async {
            // Reset timer to 0
            self.timerLabel.text = "00:00"
            self.rotatedTimerLabel.text = "00:00"
            
            // Hide timers
            self.timerLabel.isHidden = true
            self.rotatedTimerLabel.isHidden = true
            
            // Hide matches and moves labels
            self.matchesLabel.isHidden = true
            self.movesLabel.isHidden = true
            self.rotatedMatchesLabel.isHidden = true
            self.rotatedMovesLabel.isHidden = true
            
            // Unhide leaderboard button
            self.leaderboardButton.isHidden = false
            self.rotatedLeaderboardButton.isHidden = false
        }
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
    
    
    // MARK: Core Data
    func saveScore(date: Date, numMoves: Int, time: String, userInitials: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "TopFiveScores", in: managedContext)!
        let score = NSManagedObject(entity: entity, insertInto: managedContext)
        
        score.setValue(date, forKey: "date")
        score.setValue(numMoves, forKey: "numMoves")
        score.setValue(time, forKey: "time")
        score.setValue(userInitials, forKey: "userInitials")
        
        do {
            try managedContext.save()
            print("Score saved successfully")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func promptForUserInitials() {
        let alertController = UIAlertController(title: "Enter Initials", message: "Enter your initials for the high score", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Initials"
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let initials = alertController.textFields?.first?.text, !initials.isEmpty {
                self.saveScore(date: Date(), numMoves: self.totalMoves, time: self.timerLabel.text ?? "00:00", userInitials: initials)
            }
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
}
