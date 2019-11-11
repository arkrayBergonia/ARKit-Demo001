//
//  Entities.swift
//  Demo001
//
//  Created by Francis Jemuel Bergonia on 11/11/19.
//  Copyright © 2019 Arkray Marketing, Inc. All rights reserved.
//

import Foundation


enum Round {
    case One
    case Two
    case Three
    case Four
    case Five
}

func targetScore(for round: Round) -> Int {
    switch round {
    case Round.One:
        return 20
    case Round.Two:
        return 40
    case .Three:
        return 60
    case .Four:
        return 80
    case .Five:
        return 100
    }
}

func timeAllotted(for round: Round) -> Int {
    switch round {
    case Round.One:
        return 30
    case Round.Two, .Three:
        return 50
    case .Four, .Five:
        return 60
    }
}

func targetAllotted(for round: Round) -> String {
    switch round {
    case Round.One:
        return "sugar"
    case Round.Two, .Three:
        return "donut"
    case .Four, .Five:
        return "coke"
    }
}

func descriptionAllotted(for round: Round) -> String {
    switch round {
    case Round.One:
        return "Too much sugar doesn't only make us fat, but could also make us sick."
    case Round.Two:
        return "Donuts are loaded with sugar and may lead to tooth decay or diabetes"
    case .Three:
        return "Donuts are also high in calories, making us fat"
    case .Four:
        return "A 20oz Softdrink or Soda has same amount of sugar as 6 donuts, that's bad"
    case .Five:
        return "A 20oz Softdrink or Soda has same amount of sugar as 18 cookies, that's too much"
    }
}
