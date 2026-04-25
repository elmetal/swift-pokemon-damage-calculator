//
//  DamageCalculation.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

public struct DamageCalculation {
    public struct Context {
        public let level: PokemonLevel
        public let movePower: MovePower
        public let moveType: PokemonType
        public let offensiveStat: OffensiveStat
        public let attackerTypes: AttackerTypes
        public let terastalState: TerastalState
        public let attackerAbility: AttackerAbility
        public let defensiveStat: DefensiveStat
        public let defensiveStatCategory: DefensiveStatCategory
        public let defenderTypes: DefenderTypes
        public let weather: BattleWeather
        public let moveTargetScope: MoveTargetScope
        public let parentalBondHit: ParentalBondHit
        public let weatherDamageModifier: DamageWeatherModifier
        public let specialMoveDamageModifier: SpecialMoveDamageModifier
        public let criticalModifier: CriticalModifier
        public let typeEffectiveness: TypeEffectiveness
        public let burnStatus: BurnStatus
        public let zMoveProtectModifier: ZMoveProtectModifier
        public let maxMoveProtectModifier: MaxMoveProtectModifier

        public init(
            level: PokemonLevel = PokemonLevel(value: 50),
            movePower: MovePower,
            moveType: PokemonType = .normal,
            offensiveStat: OffensiveStat,
            attackerTypes: AttackerTypes = .single(.rock),
            terastalState: TerastalState = .none,
            attackerAbility: AttackerAbility,
            defensiveStat: DefensiveStat,
            defensiveStatCategory: DefensiveStatCategory,
            defenderTypes: DefenderTypes,
            weather: BattleWeather,
            moveTargetScope: MoveTargetScope = .single,
            parentalBondHit: ParentalBondHit = .normal,
            weatherDamageModifier: DamageWeatherModifier = .none,
            specialMoveDamageModifier: SpecialMoveDamageModifier = .none,
            criticalModifier: CriticalModifier = .normal,
            typeEffectiveness: TypeEffectiveness = .neutral,
            burnStatus: BurnStatus = .none,
            zMoveProtectModifier: ZMoveProtectModifier = .none,
            maxMoveProtectModifier: MaxMoveProtectModifier = .none
        ) {
            self.level = level
            self.movePower = movePower
            self.moveType = moveType
            self.offensiveStat = offensiveStat
            self.attackerTypes = attackerTypes
            self.terastalState = terastalState
            self.attackerAbility = attackerAbility
            self.defensiveStat = defensiveStat
            self.defensiveStatCategory = defensiveStatCategory
            self.defenderTypes = defenderTypes
            self.weather = weather
            self.moveTargetScope = moveTargetScope
            self.parentalBondHit = parentalBondHit
            self.weatherDamageModifier = weatherDamageModifier
            self.specialMoveDamageModifier = specialMoveDamageModifier
            self.criticalModifier = criticalModifier
            self.typeEffectiveness = typeEffectiveness
            self.burnStatus = burnStatus
            self.zMoveProtectModifier = zMoveProtectModifier
            self.maxMoveProtectModifier = maxMoveProtectModifier
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
