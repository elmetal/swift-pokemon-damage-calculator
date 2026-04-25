import Testing

@testable import swift_pokemon_damage_calculator

@Test func finalDamageCalculationMatchesPublishedMaximumRollExample() {
    let damage =
        FinalDamageCalculation
        .start(level: PokemonLevel(value: 50))
        .applying(
            finalMovePower: FinalMovePower(value: 100),
            finalOffensiveStat: FinalOffensiveStat(value: 182),
            finalDefensiveStat: FinalDefensiveStat(value: 100)
        )
        .applyingMoveTargetScope(.single)
        .applyingParentalBondHit(.normal)
        .applyingWeatherModifier(.none)
        .applyingSpecialMoveDamageModifier(.none)
        .applyingCriticalModifier(.normal)
        .applyingRandomFactor(.maximum)
        .applyingSameTypeAttackBonus(
            moveType: .ground,
            attackerTypes: .single(.ground),
            terastalState: .none,
            attackerAbility: .none
        )
        .applyingTypeEffectiveness(.half)
        .applyingBurn(
            .none,
            attackerAbility: .none,
            moveCategory: .physical
        )
        .applying(DamageModifierCalculation.start.finalize())
        .applyingZMoveProtectModifier(.none)
        .applyingMaxMoveProtectModifier(.none)
        .finalize()

    #expect(damage.value == 61)
}

@Test func finalDamageCalculationAppliesAllModifiersInOrder() {
    let damage =
        FinalDamageCalculation
        .start(level: PokemonLevel(value: 50))
        .applying(
            finalMovePower: FinalMovePower(value: 100),
            finalOffensiveStat: FinalOffensiveStat(value: 182),
            finalDefensiveStat: FinalDefensiveStat(value: 100)
        )
        .applyingMoveTargetScope(.multiple)
        .applyingParentalBondHit(.second)
        .applyingWeatherModifier(.strengthened)
        .applyingSpecialMoveDamageModifier(.collisionCourseStyle)
        .applyingCriticalModifier(.critical)
        .applyingRandomFactor(.minimum)
        .applyingSameTypeAttackBonus(
            moveType: .ground,
            attackerTypes: .single(.ground),
            terastalState: .none,
            attackerAbility: .none
        )
        .applyingTypeEffectiveness(.double)
        .applyingBurn(
            .burned,
            attackerAbility: .none,
            moveCategory: .physical
        )
        .applying(
            DamageModifierCalculation.start
                .applying(DamageModifier(numerator: 5325))
                .finalize()
        )
        .applyingZMoveProtectModifier(.protected)
        .applyingMaxMoveProtectModifier(.protected)
        .finalize()

    #expect(damage.value == 7)
}

@Test func damageCalculatorCalculateReturnsAllRandomRolls() {
    let damages = DamageCalculator.calculate(
        for: DamageCalculation.Context(
            attacker: DamageCalculation.Context.Attacker(
                level: PokemonLevel(value: 50),
                movePower: MovePower(value: 100),
                moveType: .ground,
                offensiveStat: OffensiveStat(value: 182),
                attackerTypes: .single(.ground),
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

@Test func damageCalculatorCalculateAppliesStatStagesFromContext() {
    let damages = DamageCalculator.calculate(
        for: DamageCalculation.Context(
            attacker: DamageCalculation.Context.Attacker(
                level: PokemonLevel(value: 50),
                movePower: MovePower(value: 100),
                moveType: .ground,
                offensiveStat: OffensiveStat(value: 182),
                offensiveStatStage: .plusOne,
                attackerTypes: .single(.ground),
                terastalState: .none,
                ability: .none
            ),
            defender: DamageCalculation.Context.Defender(
                defensiveStat: DefensiveStat(value: 100),
                defensiveStatCategory: .physical,
                defensiveStatStage: .minusOne,
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
        ] == [117, 118, 120, 120, 122, 123, 125, 126, 128, 129, 130, 132, 133, 135, 136, 138]
    )
}
