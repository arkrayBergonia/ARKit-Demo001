//
//  StartViewController.swift
//  Demo001
//
//  Created by Francis Jemuel Bergonia on 11/8/19.
//  Copyright © 2019 Arkray Marketing, Inc. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func startBtnTapped(_ sender: Any) {
        let lvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InfoVC")
        self.present(lvc, animated: true, completion: nil)
    }
    
}
