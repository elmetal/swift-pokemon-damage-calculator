import Testing

@testable import swift_pokemon_damage_calculator

@Test func finalDefensiveStatCalculationRoundsRankedStatDown() {
    let finalDefensiveStat =
        FinalDefensiveStatCalculation
        .start(
            with: DefensiveStat(value: 101),
            category: .physical,
            defenderTypes: .single(.rock),
            weather: .clear
        )
        .applying(DefensiveStatRankMultiplier(numerator: 3, denominator: 2))
        .applyingWeatherBoost()
        .applying(DefensiveStatModifierCalculation.start.finalize())
        .rounded()
        .ensuringMinimumValue(of: 1)

    #expect(finalDefensiveStat.value == 151)
}

@Test func finalDefensiveStatCalculationAppliesSandstormRockBoostForSpecialDefense() {
    let finalDefensiveStat =
        FinalDefensiveStatCalculation
        .start(
            with: DefensiveStat(value: 100),
            category: .special,
            defenderTypes: .dual(.rock, .ghost),
            weather: .sandstorm
        )
        .applying(DefensiveStatRankMultiplier(numerator: 1, denominator: 1))
        .applyingWeatherBoost()
        .applying(
            DefensiveStatModifierCalculation.start
                .applying(DefensiveStatModifier(numerator: 5325))
                .finalize()
        )
        .rounded()
        .ensuringMinimumValue(of: 1)

    #expect(finalDefensiveStat.value == 195)
}

@Test func finalDefensiveStatCalculationRoundsModifierUsingToNearestOrDown() {
    let finalDefensiveStat =
        FinalDefensiveStatCalculation
        .start(
            with: DefensiveStat(value: 1),
            category: .physical,
            defenderTypes: .single(.rock),
            weather: .sandstorm
        )
        .applying(DefensiveStatRankMultiplier(numerator: 1, denominator: 1))
        .applyingWeatherBoost()
        .applying(
            DefensiveStatModifierCalculation.start
                .applying(DefensiveStatModifier(numerator: 6144))
                .finalize()
        )
        .rounded()
        .ensuringMinimumValue(of: 1)

    #expect(finalDefensiveStat.value == 1)
}

@Test func finalDefensiveStatCalculationEnsuresMinimumValueOfOne() {
    let finalDefensiveStat =
        FinalDefensiveStatCalculation
        .start(
            with: DefensiveStat(value: 1),
            category: .physical,
            defenderTypes: .single(.rock),
            weather: .clear
        )
        .applying(DefensiveStatRankMultiplier(numerator: 1, denominator: 1))
        .applyingWeatherBoost()
        .applying(
            DefensiveStatModifierCalculation.start
                .applying(DefensiveStatModifier(numerator: 2048))
                .finalize()
        )
        .rounded()
        .ensuringMinimumValue(of: 1)

    #expect(finalDefensiveStat.value == 1)
}

@Test func damageCalculationContextStoresDefensiveInputs() {
    let context = DamageCalculation.Context(
        movePower: MovePower(value: 80),
        offensiveStat: OffensiveStat(value: 182),
        attackerAbility: .none,
        defensiveStat: DefensiveStat(value: 130),
        defensiveStatCategory: .special,
        defenderTypes: .dual(.rock, .ghost),
        weather: .sandstorm
    )

    #expect(context.defensiveStat.value == 130)
    #expect(context.defensiveStatCategory == .special)
    #expect(context.defenderTypes.contains(.rock))
    #expect(context.weather == .sandstorm)
}
