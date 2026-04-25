import Testing

@testable import swift_pokemon_damage_calculator

@Test func defenderTypesComposeSingleTypeMultipliers() {
    let multiplier = DefenderTypes.dual(.grass, .fighting)
        .effectivenessMultiplier(against: .ground)

    #expect(multiplier.numerator == 1)
    #expect(multiplier.denominator == 2)
}
