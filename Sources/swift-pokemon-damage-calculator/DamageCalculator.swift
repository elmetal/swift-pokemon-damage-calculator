//
//  DamageCalculator.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

public struct DamageCalculator {
    public static func calculate(for context: DamageCalculation.Context) -> InlineArray<16, Int> {
        _ =
            FinalMovePowerCalculation
            .start(with: context.movePower)
            .applying(MovePowerModifierCalculation.start.finalize())
            .rounded()
            .ensuringMinimumValue(of: 1)

        _ =
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

        _ =
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

        return [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    }

}
