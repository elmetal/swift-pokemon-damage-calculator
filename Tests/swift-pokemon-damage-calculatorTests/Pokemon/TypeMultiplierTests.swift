import PokemonTypes
import Testing

@testable import swift_pokemon_damage_calculator

@Test(arguments: PokemonTypes.PokemonType.allCases, PokemonTypes.PokemonType.allCases)
func typeMultiplierMatchesLatestTypeEffectivenessTableForSingleTypes(
    attackType: PokemonTypes.PokemonType,
    defenderType: PokemonTypes.PokemonType
) {
    let multiplier = TypeMultiplier.effectiveness(
        attackType: attackType,
        defenderTypes: .single(defenderType)
    )
    let effectiveness = LatestTypeEffectivenessTable().effectiveness(
        of: attackType,
        against: defenderType
    )
    let expectedMultiplier = TypeMultiplier(typeEffectiveness: effectiveness)

    #expect(multiplier.numerator == expectedMultiplier.numerator)
    #expect(multiplier.denominator == expectedMultiplier.denominator)
}

@Test func typeMultiplierComposesSingleTypeMultipliersForDualTypes() {
    let multiplier = TypeMultiplier.effectiveness(
        attackType: .ground,
        defenderTypes: .dual(.grass, .fighting)
    )

    #expect(multiplier.numerator == 1)
    #expect(multiplier.denominator == 2)
}

@Test func typeMultiplierSupportsQuadrupleWeakness() {
    let multiplier = TypeMultiplier.effectiveness(
        attackType: .ice,
        defenderTypes: .dual(.ground, .flying)
    )

    #expect(multiplier.numerator == 4)
    #expect(multiplier.denominator == 1)
}

@Test func typeMultiplierSupportsQuarterResistance() {
    let multiplier = TypeMultiplier.effectiveness(
        attackType: .grass,
        defenderTypes: .dual(.fire, .dragon)
    )

    #expect(multiplier.numerator == 1)
    #expect(multiplier.denominator == 4)
}

@Test func typeMultiplierSupportsImmunity() {
    let multiplier = TypeMultiplier.effectiveness(
        attackType: .dragon,
        defenderTypes: .single(.fairy)
    )

    #expect(multiplier.numerator == 0)
    #expect(multiplier.denominator == 1)
}
