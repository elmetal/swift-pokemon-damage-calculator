import Testing

@testable import swift_pokemon_damage_calculator

@Test func typeChartComposesSingleTypeMultipliersForDualTypes() {
    let multiplier = TypeChart.effectivenessMultiplier(
        attackType: .ground,
        defenderTypes: .dual(.grass, .fighting)
    )

    #expect(multiplier.numerator == 1)
    #expect(multiplier.denominator == 2)
}
