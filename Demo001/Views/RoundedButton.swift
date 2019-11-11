//
//  RoundedButton.swift
//  Demo001
//
//  Created by Francis Jemuel Bergonia on 11/11/19.
//  Copyright © 2019 Arkray Marketing, Inc. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }

}
