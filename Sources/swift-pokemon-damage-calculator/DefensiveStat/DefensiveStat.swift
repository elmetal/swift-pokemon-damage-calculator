//
//  DefensiveStat.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

public struct DefensiveStat {
    public let value: Int

    public init(value: Int) {
        precondition(value > 0, "value must be greater than zero.")

        self.value = value
    }
}

public enum DefensiveStatCategory: Equatable {
    case physical
    case special
}

struct DefensiveStatRankMultiplier {
    let numerator: Int
    let denominator: Int

    init(numerator: Int, denominator: Int) {
        precondition(numerator > 0, "numerator must be greater than zero.")
        precondition(denominator > 0, "denominator must be greater than zero.")

        self.numerator = numerator
        self.denominator = denominator
    }
}
