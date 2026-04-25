import Testing

@testable import swift_pokemon_damage_calculator

@Test func finalMovePowerCalculationRoundsUsingToNearestOrDown() {
    let finalMovePower = FinalMovePowerCalculation
        .start(with: MovePower(value: 1))
        .applying(
            MovePowerModifierCalculation.start
                .applying(MovePowerModifier(numerator: 6144))
                .finalize()
        )
        .rounded()
        .ensuringMinimumValue(of: 1)

    #expect(finalMovePower.value == 1)
}

@Test func finalMovePowerCalculationEnsuresMinimumValueOfOne() {
    let finalMovePower = FinalMovePowerCalculation
        .start(with: MovePower(value: 1))
        .applying(
            MovePowerModifierCalculation.start
                .applying(MovePowerModifier(numerator: 2048))
                .finalize()
        )
        .rounded()
        .ensuringMinimumValue(of: 1)

    #expect(finalMovePower.value == 1)
}

@Test func damageCalculationContextStoresMovePower() {
    let context = DamageCalculation.Context(movePower: MovePower(value: 80))

    #expect(context.movePower.value == 80)
}
