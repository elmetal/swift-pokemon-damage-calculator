import Testing

@testable import swift_pokemon_damage_calculator

@Test func damageModifierCalculationStartsAtBaseValue() {
    let modifier = DamageModifierCalculation.start.finalize()

    #expect(modifier.value == 4096)
}

@Test func damageModifierCalculationRoundsAfterEachAppliedModifier() {
    let modifier = DamageModifierCalculation.start
        .applying(DamageModifier(numerator: 3072))
        .applying(DamageModifier(numerator: 5325))
        .applying(DamageModifier(numerator: 6144))
        .finalize()

    #expect(modifier.value == 5991)
}
