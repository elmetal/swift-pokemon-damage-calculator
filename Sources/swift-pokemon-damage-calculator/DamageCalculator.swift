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
                .applyingWeatherModifier(field.weatherDamageModifier)
                .applyingSpecialMoveDamageModifier(field.specialMoveDamageModifier)
                .applyingCriticalModifier(field.criticalModifier)
                .applyingRandomFactor(randomFactor)
                .applyingSameTypeAttackBonus(
                    moveType: attacker.moveType,
                    attackerTypes: attacker.attackerTypes,
                    terastalState: attacker.terastalState,
                    attackerAbility: attacker.ability
                )
                .applyingTypeEffectiveness(field.typeEffectiveness)
                .applyingBurn(
                    attacker.burnStatus,
                    attackerAbility: attacker.ability,
                    moveCategory: defender.defensiveStatCategory
                )
                .applying(damageModifier)
                .applyingZMoveProtectModifier(field.zMoveProtectModifier)
                .applyingMaxMoveProtectModifier(field.maxMoveProtectModifier)
                .finalize()
                .value
        }

        var result: InlineArray<16, Int> = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        for index in values.indices {
            result[index] = values[index]
        }

        return result
    }

}
