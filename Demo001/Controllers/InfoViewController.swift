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
    
    var gameIsOver: Bool = false
    var currentRoundNumber: Int = 1
    var currentRoundInfo: Round = Round.One
    
    let startVC = StartViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentRoundInfo = Round(rawValue: currentRoundNumber) ?? Round.One
        
        self.updateHeadLabels()
    }
    
    @IBAction func startBtnTapped(_ sender: Any) {
        
        switch startVC.checkGameStatus() {
        case .GameJustStarted, .GameInProgress:
            self.startVC.updateGameStatus(GameStatus.GameInProgress)
            let lvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BadSugarGameVC")
            self.present(lvc, animated: true, completion: nil)
        case .GameIsOver:
            self.startVC.updateGameStatus(GameStatus.GameJustStarted)
            self.currentRoundNumber = 1
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    private func updateHeadLabels() {
        self.headerTitleLabel.text = !gameIsOver ? "Game Over" : "Mission Start"
        self.subHeaderLabel.text = !gameIsOver ? "Did you know?" : "Round \(self.currentRoundNumber)"
        self.targetImage.image = UIImage(named: Entities().targetAllotted(for: self.currentRoundInfo))
        
        switch startVC.checkGameStatus() {
        case .GameJustStarted, .GameInProgress:
            self.targetDescriptionTextView.text = "For this round, you need to obtain a score of \(Entities().targetScore(for: self.currentRoundInfo)) within \(Entities().timeAllotted(for: self.currentRoundInfo)). Do your best"
            
        case .GameIsOver:
            self.targetDescriptionTextView.text = Entities().descriptionAllotted(for: self.currentRoundInfo)
        }
    }
    
    public func updateRoundNumber() {
        if self.currentRoundNumber != 5 {
            self.currentRoundNumber + 1
        } else {
            self.currentRoundNumber = 1
        }
    }

}
