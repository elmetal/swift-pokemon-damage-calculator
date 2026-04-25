//
//  MovePower.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

public struct MovePower {
    public let value: Int

    public init(value: Int) {
        precondition(value > 0, "value must be greater than zero.")

        self.value = value
    }
}
