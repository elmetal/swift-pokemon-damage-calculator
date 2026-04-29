import PokemonTypes
import Testing

@testable import swift_pokemon_damage_calculator

private let singleTypeMultipliers: [TypeMultiplier] = [.zero, .half, .neutral, .double]

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

    #expect(multiplier == expectedMultiplier)
}

@Test func typeMultiplierComposesSingleTypeMultipliersForDualTypes() {
    let multiplier = TypeMultiplier.effectiveness(
        attackType: .ground,
        defenderTypes: .dual(.grass, .fighting)
    )

    #expect(multiplier == .half)
}

@Test func typeMultiplierSupportsQuadrupleWeakness() {
    let multiplier = TypeMultiplier.effectiveness(
        attackType: .ice,
        defenderTypes: .dual(.ground, .flying)
    )

    #expect(multiplier == .quadruple)
}

@Test func typeMultiplierSupportsQuarterResistance() {
    let multiplier = TypeMultiplier.effectiveness(
        attackType: .grass,
        defenderTypes: .dual(.fire, .dragon)
    )

    #expect(multiplier == .quarter)
}

@Test func typeMultiplierSupportsImmunity() {
    let multiplier = TypeMultiplier.effectiveness(
        attackType: .dragon,
        defenderTypes: .single(.fairy)
    )

    #expect(multiplier == .zero)
}

@Test(arguments: singleTypeMultipliers, singleTypeMultipliers)
func typeMultiplierCompositionOfSingleTypeResultsStaysInTypeEffectivenessSpace(
    lhs: TypeMultiplier,
    rhs: TypeMultiplier
) {
    #expect(TypeMultiplier.allCases.contains(lhs.multiplied(by: rhs)))
}
