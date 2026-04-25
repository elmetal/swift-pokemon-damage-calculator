//
//  DamageCalculation.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

public struct DamageCalculation {
    public struct Context {
        public struct Attacker {
            public let level: PokemonLevel
            public let movePower: MovePower
            public let moveType: PokemonType
            public let offensiveStat: OffensiveStat
            public let offensiveStatStage: StatStage
            public let attackerTypes: AttackerTypes
            public let terastalState: TerastalState
            public let ability: AttackerAbility
            public let burnStatus: BurnStatus

            public init(
                level: PokemonLevel = PokemonLevel(value: 50),
                movePower: MovePower,
                moveType: PokemonType = .normal,
                offensiveStat: OffensiveStat,
                offensiveStatStage: StatStage = .neutral,
                attackerTypes: AttackerTypes = .single(.rock),
                terastalState: TerastalState = .none,
                ability: AttackerAbility,
                burnStatus: BurnStatus = .none
            ) {
                self.level = level
                self.movePower = movePower
                self.moveType = moveType
                self.offensiveStat = offensiveStat
                self.offensiveStatStage = offensiveStatStage
                self.attackerTypes = attackerTypes
                self.terastalState = terastalState
                self.ability = ability
                self.burnStatus = burnStatus
            }
        }

        public struct Defender {
            public let defensiveStat: DefensiveStat
            public let defensiveStatCategory: DefensiveStatCategory
            public let defensiveStatStage: StatStage
            public let defenderTypes: DefenderTypes

            public init(
                defensiveStat: DefensiveStat,
                defensiveStatCategory: DefensiveStatCategory,
                defensiveStatStage: StatStage = .neutral,
                defenderTypes: DefenderTypes
            ) {
                self.defensiveStat = defensiveStat
                self.defensiveStatCategory = defensiveStatCategory
                self.defensiveStatStage = defensiveStatStage
                self.defenderTypes = defenderTypes
            }
        }

        public struct Field {
            public let weather: BattleWeather
            public let moveTargetScope: MoveTargetScope
            public let parentalBondHit: ParentalBondHit
            public let specialMovePowerUp: SpecialMovePowerUp
            public let isCritical: Bool
            public let isProtectedByZMove: Bool
            public let isProtectedByMaxMove: Bool

            public init(
                weather: BattleWeather,
                moveTargetScope: MoveTargetScope = .single,
                parentalBondHit: ParentalBondHit = .normal,
                specialMovePowerUp: SpecialMovePowerUp = .none,
                isCritical: Bool = false,
                isProtectedByZMove: Bool = false,
                isProtectedByMaxMove: Bool = false
            ) {
                self.weather = weather
                self.moveTargetScope = moveTargetScope
                self.parentalBondHit = parentalBondHit
                self.specialMovePowerUp = specialMovePowerUp
                self.isCritical = isCritical
                self.isProtectedByZMove = isProtectedByZMove
                self.isProtectedByMaxMove = isProtectedByMaxMove
            }
        }

        public let attacker: Attacker
        public let defender: Defender
        public let field: Field

        public init(
            attacker: Attacker,
            defender: Defender,
            field: Field
        ) {
            self.attacker = attacker
            self.defender = defender
            self.field = field
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
