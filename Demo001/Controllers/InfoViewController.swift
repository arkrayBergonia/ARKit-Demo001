//
//  InfoViewController.swift
//  Demo001
//
//  Created by Francis Jemuel Bergonia on 11/11/19.
//  Copyright © 2019 Arkray Marketing, Inc. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var nurseImage: UIImageView!
    @IBOutlet weak var targetImage: UIImageView!
    @IBOutlet weak var subHeaderLabel: UILabel!
    @IBOutlet weak var targetDescriptionTextView: UITextView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var mainButton: RoundedButton!
    
    private var gameStatus: GameStatus = GameStatus.GameJustStarted
    var gameIsOver: Bool = false
    var currentRoundNumber: Int = 1
    var currentRoundInfo: Round = Round.One
    var lastScore = 0
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.gameIsOver = self.defaults.bool(forKey: "gameOver")
        self.lastScore = self.defaults.integer(forKey: "score")
        self.defaults.removeObject(forKey: "gameOver")
        self.defaults.removeObject(forKey: "score")
        self.updateHeadLabels()
    }
    
    @IBAction func startBtnTapped(_ sender: Any) {
        if !gameIsOver {
            let lvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BadSugarGameVC")
            self.present(lvc, animated: true, completion: nil)
        } else {
            self.currentRoundNumber = 1
            self.gameIsOver = false
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    private func updateHeadLabels() {
        self.headerTitleLabel.text = gameIsOver ? "Game Over" : "Mission Start"
        self.subHeaderLabel.text = gameIsOver ? "Did you know?" : "Round \(self.currentRoundNumber)"
        self.targetImage.image = UIImage(named: Entities().targetAllotted(for: self.currentRoundInfo))
        self.mainButton.setTitle(gameIsOver ? "Okay, I understand" : "Okay, Let's start", for: .normal)
        self.scoreLabel.isHidden = gameIsOver ? false : true
        self.scoreLabel.text = "Last score: \(lastScore)"
        
        if !gameIsOver {
            if self.currentRoundNumber != 5 {
                self.currentRoundNumber += 1
            }
            
            self.targetDescriptionTextView.text = "To proceed to the next round, you need to obtain a score of \(Entities().targetScore(for: self.currentRoundInfo)) points within \(Entities().timeAllotted(for: self.currentRoundInfo)) seconds. Do your best!"
        } else {
            self.currentRoundNumber = 1
            self.targetDescriptionTextView.text = Entities().descriptionAllotted(for: self.currentRoundInfo)
        }
        
        self.currentRoundInfo = Round(rawValue: self.currentRoundNumber) ?? Round.One
    }
    
}
