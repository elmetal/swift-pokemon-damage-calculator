import Testing

@testable import swift_pokemon_damage_calculator

@Test func defensiveStatModifierCalculationStartsAtBaseValue() {
    let modifier = DefensiveStatModifierCalculation.start.finalize()

    #expect(modifier.value == 4096)
}

@Test func defensiveStatModifierCalculationRoundsAfterEachAppliedModifier() {
    let modifier = DefensiveStatModifierCalculation.start
        .applying(DefensiveStatModifier(numerator: 3072))
        .applying(DefensiveStatModifier(numerator: 5325))
        .applying(DefensiveStatModifier(numerator: 6144))
        .finalize()

    #expect(modifier.value == 5991)
}
