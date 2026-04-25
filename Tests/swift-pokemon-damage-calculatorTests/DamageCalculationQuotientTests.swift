import Testing

@testable import swift_pokemon_damage_calculator

@Test func quotientRoundedToNearestOrUpRoundsHalfUp() {
    let rounded = DamageCalculation.Quotient(
        numerator: 3,
        denominator: 2
    )
    .rounded(.toNearestOrUp)

    #expect(rounded == 2)
}

@Test func quotientRoundedToNearestOrDownRoundsHalfDown() {
    let rounded = DamageCalculation.Quotient(
        numerator: 3,
        denominator: 2
    )
    .rounded(.toNearestOrDown)

    #expect(rounded == 1)
}
