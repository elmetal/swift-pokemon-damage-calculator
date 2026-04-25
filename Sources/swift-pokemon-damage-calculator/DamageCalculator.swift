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
            .start(with: context.offensiveStat)
            .applying(OffensiveStatRankMultiplier(numerator: 1, denominator: 1))
            .applying(OffensiveStatModifierCalculation.start.finalize())
            .rounded()
            .ensuringMinimumValue(of: 1)

        return [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    }

}
