import Testing

@testable import swift_pokemon_damage_calculator

@Test func movePowerModifierCalculationStartsAtBaseValue() {
    let modifier = MovePowerModifierCalculation.start.finalize()

    #expect(modifier.value == 4096)
}

@Test func movePowerModifierCalculationRoundsAfterEachAppliedModifier() {
    let modifier = MovePowerModifierCalculation.start
        .applying(MovePowerModifier(numerator: 3072))
        .applying(MovePowerModifier(numerator: 4505))
        .applying(MovePowerModifier(numerator: 4915))
        .finalize()

    #expect(modifier.value == 4055)
}
