//
//  DamageCalculator.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

public struct DamageCalculator {
    public static func calculate(for context: DamageCalculation.Context) -> InlineArray<16, Int> {
        let attacker = context.attacker
        let defender = context.defender
        let field = context.field
        let weatherDamageModifier = damageWeatherModifier(
            weather: field.weather,
            moveType: attacker.moveType
        )
        let specialMoveDamageModifier = specialMoveDamageModifier(for: field.specialMovePowerUp)
        let criticalModifier = criticalModifier(isCritical: field.isCritical)
        let typeEffectiveness = typeEffectiveness(
            moveType: attacker.moveType,
            defenderTypes: defender.defenderTypes
        )
        let zMoveProtectModifier = zMoveProtectModifier(isProtected: field.isProtectedByZMove)
        let maxMoveProtectModifier = maxMoveProtectModifier(isProtected: field.isProtectedByMaxMove)

        let finalMovePower =
            FinalMovePowerCalculation
            .start(with: attacker.movePower)
            .applying(MovePowerModifierCalculation.start.finalize())
            .rounded()
            .ensuringMinimumValue(of: 1)

        let finalOffensiveStat =
            FinalOffensiveStatCalculation
            .start(
                with: attacker.offensiveStat,
                attackerAbility: attacker.ability
            )
            .applying(OffensiveStatRankMultiplier(numerator: 1, denominator: 1))
            .applyingAttackerAbility()
            .applying(OffensiveStatModifierCalculation.start.finalize())
            .rounded()
            .ensuringMinimumValue(of: 1)

        let finalDefensiveStat =
            FinalDefensiveStatCalculation
            .start(
                with: defender.defensiveStat,
                category: defender.defensiveStatCategory,
                defenderTypes: defender.defenderTypes,
                weather: field.weather
            )
            .applying(DefensiveStatRankMultiplier(numerator: 1, denominator: 1))
            .applyingWeatherBoost()
            .applying(DefensiveStatModifierCalculation.start.finalize())
            .rounded()
            .ensuringMinimumValue(of: 1)

        let damageModifier = DamageModifierCalculation.start.finalize()
        let values = DamageRandomFactor.all.map { randomFactor in
            FinalDamageCalculation
                .start(level: attacker.level)
                .applying(
                    finalMovePower: finalMovePower,
                    finalOffensiveStat: finalOffensiveStat,
                    finalDefensiveStat: finalDefensiveStat
                )
                .applyingMoveTargetScope(field.moveTargetScope)
                .applyingParentalBondHit(field.parentalBondHit)
                .applyingWeatherModifier(weatherDamageModifier)
                .applyingSpecialMoveDamageModifier(specialMoveDamageModifier)
                .applyingCriticalModifier(criticalModifier)
                .applyingRandomFactor(randomFactor)
                .applyingSameTypeAttackBonus(
                    moveType: attacker.moveType,
                    attackerTypes: attacker.attackerTypes,
                    terastalState: attacker.terastalState,
                    attackerAbility: attacker.ability
                )
                .applyingTypeEffectiveness(typeEffectiveness)
                .applyingBurn(
                    attacker.burnStatus,
                    attackerAbility: attacker.ability,
                    moveCategory: defender.defensiveStatCategory
                )
                .applying(damageModifier)
                .applyingZMoveProtectModifier(zMoveProtectModifier)
                .applyingMaxMoveProtectModifier(maxMoveProtectModifier)
                .finalize()
                .value
        }

        var result: InlineArray<16, Int> = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        for index in values.indices {
            result[index] = values[index]
        }

        return result
    }

    private static func damageWeatherModifier(
        weather: BattleWeather,
        moveType: PokemonType
    ) -> DamageWeatherModifier {
        switch (weather, moveType) {
        case (.sun, .fire), (.rain, .water):
            .strengthened
        case (.sun, .water), (.rain, .fire):
            .weakened
        default:
            .none
        }
    }

    private static func specialMoveDamageModifier(
        for specialMovePowerUp: SpecialMovePowerUp
    ) -> SpecialMoveDamageModifier {
        switch specialMovePowerUp {
        case .none:
            .none
        case .collisionCourseStyle:
            .collisionCourseStyle
        }
    }

    private static func criticalModifier(isCritical: Bool) -> CriticalModifier {
        isCritical ? .critical : .normal
    }

    private static func zMoveProtectModifier(isProtected: Bool) -> ZMoveProtectModifier {
        isProtected ? .protected : .none
    }

    private static func maxMoveProtectModifier(isProtected: Bool) -> MaxMoveProtectModifier {
        isProtected ? .protected : .none
    }

    private static func typeEffectiveness(
        moveType: PokemonType,
        defenderTypes: DefenderTypes
    ) -> TypeEffectiveness {
        let multipliers = defenderTypes.effectivenessMultipliers(against: moveType)
        let numerator = multipliers.reduce(1) { partialResult, multiplier in
            partialResult * multiplier.numerator
        }
        let denominator = multipliers.reduce(1) { partialResult, multiplier in
            partialResult * multiplier.denominator
        }

        return switch (numerator, denominator) {
        case (0, _):
            .zero
        case (1, 4):
            .quarter
        case (1, 2):
            .half
        case (1, 1):
            .neutral
        case (2, 1):
            .double
        case (4, 1):
            .quadruple
        default:
            preconditionFailure("Unsupported type effectiveness: \(numerator)/\(denominator)")
        }
    }

}
