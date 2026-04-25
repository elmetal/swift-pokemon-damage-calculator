import Testing

@testable import swift_pokemon_damage_calculator

@Test func level50GarchompEarthquakeAgainstBreloomMatchesPublishedExample() {
    let damages = DamageCalculator.calculate(
        for: DamageCalculation.Context(
            attacker: DamageCalculation.Context.Attacker(
                level: PokemonLevel(value: 50),
                movePower: MovePower(value: 100),
                moveType: .ground,
                offensiveStat: OffensiveStat(value: 182),
                attackerTypes: .dual(.dragon, .ground),
                terastalState: .none,
                ability: .none
            ),
            defender: DamageCalculation.Context.Defender(
                defensiveStat: DefensiveStat(value: 100),
                defensiveStatCategory: .physical,
                defenderTypes: .dual(.grass, .fighting)
            ),
            field: DamageCalculation.Context.Field(weather: .clear)
        )
    )

    #expect(
        [
            damages[0], damages[1], damages[2], damages[3],
            damages[4], damages[5], damages[6], damages[7],
            damages[8], damages[9], damages[10], damages[11],
            damages[12], damages[13], damages[14], damages[15],
        ] == [51, 52, 53, 54, 54, 54, 55, 56, 57, 57, 57, 58, 59, 60, 60, 61]
    )
}
