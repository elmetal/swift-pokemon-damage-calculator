import Testing

@testable import swift_pokemon_damage_calculator

@Test func finalMovePowerCalculationRoundsUsingToNearestOrDown() {
    let finalMovePower =
        FinalMovePowerCalculation
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
    let finalMovePower =
        FinalMovePowerCalculation
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
    let context = DamageCalculation.Context(
        attacker: DamageCalculation.Context.Attacker(
            movePower: MovePower(value: 80),
            offensiveStat: OffensiveStat(value: 182),
            ability: .none
        ),
        defender: DamageCalculation.Context.Defender(
            defensiveStat: DefensiveStat(value: 130),
            defensiveStatCategory: .physical,
            defenderTypes: .single(.rock)
        ),
        field: DamageCalculation.Context.Field(weather: .clear)
    )

    #expect(context.attacker.movePower.value == 80)
}
