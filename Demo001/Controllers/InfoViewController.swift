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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func startBtnTapped(_ sender: Any) {
        let lvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BadSugarGameVC")
        self.present(lvc, animated: true, completion: nil)
    }


}
