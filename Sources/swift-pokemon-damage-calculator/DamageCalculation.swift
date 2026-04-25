//
//  DamageCalculation.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

public struct DamageCalculation {
    public struct Context {
        public let movePower: MovePower
        public let offensiveStat: OffensiveStat
        public let attackerAbility: AttackerAbility

        public init(
            movePower: MovePower,
            offensiveStat: OffensiveStat,
            attackerAbility: AttackerAbility
        ) {
            self.movePower = movePower
            self.offensiveStat = offensiveStat
            self.attackerAbility = attackerAbility
        }
    }

    struct Quotient {
        let numerator: Int
        let denominator: Int

        init(numerator: Int, denominator: Int) {
            precondition(numerator >= 0, "numerator must be greater than or equal to zero.")
            precondition(denominator > 0, "denominator must be greater than zero.")

            self.numerator = numerator
            self.denominator = denominator
        }

        func rounded(_ rule: RoundingRule) -> Int {
            let quotient = numerator / denominator
            let remainder = numerator % denominator

            return switch rule {
            case .down:
                quotient
            case .toNearestOrDown:
                quotient + ((remainder * 2 > denominator) ? 1 : 0)
            case .toNearestOrUp:
                quotient + ((remainder * 2 >= denominator) ? 1 : 0)
            }
        }
    }

    enum RoundingRule: Equatable {
        case down
        case toNearestOrDown
        case toNearestOrUp
    }
}
