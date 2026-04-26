import PokemonTypes
import Testing

@testable import swift_pokemon_damage_calculator

@Test(arguments: PokemonTypes.PokemonType.allCases, PokemonTypes.PokemonType.allCases)
func typeChartMatchesLatestTypeEffectivenessTableForSingleTypes(
    attackType: PokemonTypes.PokemonType,
    defenderType: PokemonTypes.PokemonType
) {
    let multiplier = TypeChart.effectivenessMultiplier(
        attackType: attackType,
        defenderTypes: .single(defenderType)
    )
    let effectiveness = LatestTypeEffectivenessTable().effectiveness(
        of: attackType,
        against: defenderType
    )
    let expectedMultiplier = expectedTypeMultiplier(for: effectiveness)

    #expect(multiplier.numerator == expectedMultiplier.numerator)
    #expect(multiplier.denominator == expectedMultiplier.denominator)
}

@Test func typeChartComposesSingleTypeMultipliersForDualTypes() {
    let multiplier = TypeChart.effectivenessMultiplier(
        attackType: .ground,
        defenderTypes: .dual(.grass, .fighting)
    )

    #expect(multiplier.numerator == 1)
    #expect(multiplier.denominator == 2)
}

@Test func typeChartSupportsQuadrupleWeakness() {
    let multiplier = TypeChart.effectivenessMultiplier(
        attackType: .ice,
        defenderTypes: .dual(.ground, .flying)
    )

    #expect(multiplier.numerator == 4)
    #expect(multiplier.denominator == 1)
}

@Test func typeChartSupportsQuarterResistance() {
    let multiplier = TypeChart.effectivenessMultiplier(
        attackType: .grass,
        defenderTypes: .dual(.fire, .dragon)
    )

    #expect(multiplier.numerator == 1)
    #expect(multiplier.denominator == 4)
}

@Test func typeChartSupportsImmunity() {
    let multiplier = TypeChart.effectivenessMultiplier(
        attackType: .dragon,
        defenderTypes: .single(.fairy)
    )

    #expect(multiplier.numerator == 0)
    #expect(multiplier.denominator == 1)
}

private func expectedTypeMultiplier(
    for effectiveness: PokemonTypes.TypeEffectiveness
) -> TypeMultiplier {
    switch effectiveness {
    case .ineffective:
        .zero
    case .notVeryEffective:
        .half
    case .neutral:
        .neutral
    case .superEffective:
        .double
    }
}
