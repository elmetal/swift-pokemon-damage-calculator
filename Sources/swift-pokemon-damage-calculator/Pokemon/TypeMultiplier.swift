//
//  TypeMultiplier.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

struct TypeMultiplier {
    let numerator: Int
    let denominator: Int

    static let zero = TypeMultiplier(numerator: 0, denominator: 1)
    static let quarter = TypeMultiplier(numerator: 1, denominator: 4)
    static let half = TypeMultiplier(numerator: 1, denominator: 2)
    static let neutral = TypeMultiplier(numerator: 1, denominator: 1)
    static let double = TypeMultiplier(numerator: 2, denominator: 1)
    static let quadruple = TypeMultiplier(numerator: 4, denominator: 1)

    func multiplied(by other: TypeMultiplier) -> TypeMultiplier {
        if numerator == 0 || other.numerator == 0 {
            return .zero
        }

        return TypeMultiplier(
            numerator: numerator * other.numerator,
            denominator: denominator * other.denominator
        )
    }
}
