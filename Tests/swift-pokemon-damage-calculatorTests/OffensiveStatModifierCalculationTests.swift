import Testing

@testable import swift_pokemon_damage_calculator

@Test func offensiveStatModifierCalculationStartsAtBaseValue() {
    let modifier = OffensiveStatModifierCalculation.start.finalize()

    #expect(modifier.value == 4096)
}

@Test func offensiveStatModifierCalculationRoundsAfterEachAppliedModifier() {
    let modifier = OffensiveStatModifierCalculation.start
        .applying(OffensiveStatModifier(numerator: 2048))
        .applying(OffensiveStatModifier(numerator: 3072))
        .applying(OffensiveStatModifier(numerator: 5325))
        .finalize()

    #expect(modifier.value == 1997)
}
