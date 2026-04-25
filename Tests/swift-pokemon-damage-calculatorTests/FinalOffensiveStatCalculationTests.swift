import Testing

@testable import swift_pokemon_damage_calculator

@Test func finalOffensiveStatCalculationRoundsRankedStatDown() {
    let finalOffensiveStat =
        FinalOffensiveStatCalculation
        .start(with: OffensiveStat(value: 101))
        .applying(OffensiveStatRankMultiplier(numerator: 3, denominator: 2))
        .applying(OffensiveStatModifierCalculation.start.finalize())
        .rounded()
        .ensuringMinimumValue(of: 1)

    #expect(finalOffensiveStat.value == 151)
}

@Test func finalOffensiveStatCalculationRoundsModifierUsingToNearestOrDown() {
    let finalOffensiveStat =
        FinalOffensiveStatCalculation
        .start(with: OffensiveStat(value: 1))
        .applying(OffensiveStatRankMultiplier(numerator: 1, denominator: 1))
        .applying(
            OffensiveStatModifierCalculation.start
                .applying(OffensiveStatModifier(numerator: 6144))
                .finalize()
        )
        .rounded()
        .ensuringMinimumValue(of: 1)

    #expect(finalOffensiveStat.value == 1)
}

@Test func finalOffensiveStatCalculationEnsuresMinimumValueOfOne() {
    let finalOffensiveStat =
        FinalOffensiveStatCalculation
        .start(with: OffensiveStat(value: 1))
        .applying(OffensiveStatRankMultiplier(numerator: 1, denominator: 1))
        .applying(
            OffensiveStatModifierCalculation.start
                .applying(OffensiveStatModifier(numerator: 2048))
                .finalize()
        )
        .rounded()
        .ensuringMinimumValue(of: 1)

    #expect(finalOffensiveStat.value == 1)
}

@Test func damageCalculationContextStoresOffensiveStat() {
    let context = DamageCalculation.Context(
        movePower: MovePower(value: 80),
        offensiveStat: OffensiveStat(value: 182)
    )

    #expect(context.offensiveStat.value == 182)
}
