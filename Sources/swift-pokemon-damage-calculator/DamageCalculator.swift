//
//  DamageCalculator.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

public struct DamageCalculator {
    public static func calculate(for context: DamageCalculation.Context) -> InlineArray<16, Int> {
        let finalMovePower =
            FinalMovePowerCalculation
            .start(with: context.movePower)
            .applying(MovePowerModifierCalculation.start.finalize())
            .rounded()
            .ensuringMinimumValue(of: 1)

        let finalOffensiveStat =
            FinalOffensiveStatCalculation
            .start(
                with: context.offensiveStat,
                attackerAbility: context.attackerAbility
            )
            .applying(OffensiveStatRankMultiplier(numerator: 1, denominator: 1))
            .applyingAttackerAbility()
            .applying(OffensiveStatModifierCalculation.start.finalize())
            .rounded()
            .ensuringMinimumValue(of: 1)

        let finalDefensiveStat =
            FinalDefensiveStatCalculation
            .start(
                with: context.defensiveStat,
                category: context.defensiveStatCategory,
                defenderTypes: context.defenderTypes,
                weather: context.weather
            )
            .applying(DefensiveStatRankMultiplier(numerator: 1, denominator: 1))
            .applyingWeatherBoost()
            .applying(DefensiveStatModifierCalculation.start.finalize())
            .rounded()
            .ensuringMinimumValue(of: 1)

        let damageModifier = DamageModifierCalculation.start.finalize()
        let values = DamageRandomFactor.all.map { randomFactor in
            FinalDamageCalculation
                .start(level: context.level)
                .applying(
                    finalMovePower: finalMovePower,
                    finalOffensiveStat: finalOffensiveStat,
                    finalDefensiveStat: finalDefensiveStat
                )
                .applyingMoveTargetScope(context.moveTargetScope)
                .applyingParentalBondHit(context.parentalBondHit)
                .applyingWeatherModifier(context.weatherDamageModifier)
                .applyingSpecialMoveDamageModifier(context.specialMoveDamageModifier)
                .applyingCriticalModifier(context.criticalModifier)
                .applyingRandomFactor(randomFactor)
                .applyingSameTypeAttackBonus(
                    moveType: context.moveType,
                    attackerTypes: context.attackerTypes,
                    terastalState: context.terastalState,
                    attackerAbility: context.attackerAbility
                )
                .applyingTypeEffectiveness(context.typeEffectiveness)
                .applyingBurn(
                    context.burnStatus,
                    attackerAbility: context.attackerAbility,
                    moveCategory: context.defensiveStatCategory
                )
                .applying(damageModifier)
                .applyingZMoveProtectModifier(context.zMoveProtectModifier)
                .applyingMaxMoveProtectModifier(context.maxMoveProtectModifier)
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
