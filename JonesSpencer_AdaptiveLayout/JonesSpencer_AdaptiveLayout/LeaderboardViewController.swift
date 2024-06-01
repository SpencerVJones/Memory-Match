//  LeaderboardViewController.swift
//  JonesSpencer_AdaptiveLayout
//  Created by Spencer Jones on 5/28/24.

import UIKit
import CoreData

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet var tableView: UITableView!
    
    var managedContext: NSManagedObjectContext!
    var topScores: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize managedContext from app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not found")
        }
        managedContext = appDelegate.persistentContainer.viewContext
        
        fetchTopScores()
        
        // Reload the table view
        tableView.reloadData()
    }
    
    func fetchTopScores() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TopFiveScores")
        let sortDescriptor = NSSortDescriptor(key: "numMoves", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 5
        do {
            topScores = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // 5 Rows for top 5 high scores
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as? LeaderboardTableViewCell else {
            fatalError("Cell is not instance of LeaderboardTableViewCell.")
        }
        if indexPath.row < topScores.count {
            let score = topScores[indexPath.row]
            let initials = score.value(forKey: "userInitials") as? String ?? "N/A"
            let time = score.value(forKey: "time") as? String ?? "N/A"
            let numMoves = score.value(forKey: "numMoves") as? Int ?? 0
            let date = score.value(forKey: "date") as? Date ?? Date()
            
            // Formating date for table view
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: date)
            
            cell.initialsLabel.text = initials
            cell.MovesLabel.text = "\(numMoves)"
            cell.timeLabel.text = "\(time)"
            cell.DateLabel.text = dateString
        } else {
            // Handle case where topScores is empty or partial
            cell.initialsLabel.text = "N/A"
            cell.MovesLabel.text = "N/A"
            cell.timeLabel.text = "N/A"
            cell.DateLabel.text = "N/A"
        }
        
        return cell
    }
    
    // Function to change row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
}
