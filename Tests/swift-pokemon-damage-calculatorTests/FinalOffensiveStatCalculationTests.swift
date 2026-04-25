import Testing

@testable import swift_pokemon_damage_calculator

@Test func finalOffensiveStatCalculationRoundsRankedStatDown() {
    let finalOffensiveStat =
        FinalOffensiveStatCalculation
        .start(
            with: OffensiveStat(value: 101),
            attackerAbility: .none
        )
        .applying(OffensiveStatRankMultiplier(numerator: 3, denominator: 2))
        .applyingAttackerAbility()
        .applying(OffensiveStatModifierCalculation.start.finalize())
        .rounded()
        .ensuringMinimumValue(of: 1)

    #expect(finalOffensiveStat.value == 151)
}

@Test func finalOffensiveStatCalculationRoundsModifierUsingToNearestOrDown() {
    let finalOffensiveStat =
        FinalOffensiveStatCalculation
        .start(
            with: OffensiveStat(value: 1),
            attackerAbility: .none
        )
        .applying(OffensiveStatRankMultiplier(numerator: 1, denominator: 1))
        .applyingAttackerAbility()
        .applying(
            OffensiveStatModifierCalculation.start
                .applying(OffensiveStatModifier(numerator: 6144))
                .finalize()
        )
        .rounded()
        .ensuringMinimumValue(of: 1)

    #expect(finalOffensiveStat.value == 1)
}

@Test func finalOffensiveStatCalculationAppliesHustleBeforeOffensiveStatModifier() {
    let finalOffensiveStat =
        FinalOffensiveStatCalculation
        .start(
            with: OffensiveStat(value: 100),
            attackerAbility: .hustle
        )
        .applying(OffensiveStatRankMultiplier(numerator: 1, denominator: 1))
        .applyingAttackerAbility()
        .applying(
            OffensiveStatModifierCalculation.start
                .applying(OffensiveStatModifier(numerator: 5325))
                .finalize()
        )
        .rounded()
        .ensuringMinimumValue(of: 1)

    #expect(finalOffensiveStat.value == 195)
}

@Test func finalOffensiveStatCalculationEnsuresMinimumValueOfOne() {
    let finalOffensiveStat =
        FinalOffensiveStatCalculation
        .start(
            with: OffensiveStat(value: 1),
            attackerAbility: .none
        )
        .applying(OffensiveStatRankMultiplier(numerator: 1, denominator: 1))
        .applyingAttackerAbility()
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
        offensiveStat: OffensiveStat(value: 182),
        attackerAbility: .none,
        defensiveStat: DefensiveStat(value: 130),
        defensiveStatCategory: .physical,
        defenderTypes: .single(.rock),
        weather: .clear
    )

    #expect(context.offensiveStat.value == 182)
}

@Test func damageCalculationContextStoresAttackerAbility() {
    let context = DamageCalculation.Context(
        movePower: MovePower(value: 80),
        offensiveStat: OffensiveStat(value: 182),
        attackerAbility: .hustle,
        defensiveStat: DefensiveStat(value: 130),
        defensiveStatCategory: .physical,
        defenderTypes: .single(.rock),
        weather: .clear
    )

    #expect(context.attackerAbility == .hustle)
}
