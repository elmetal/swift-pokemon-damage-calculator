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

@Test func damageCalculatorCalculateIgnoresNegativeOffensiveStageOnCriticalHit() {
    let damages = DamageCalculator.calculate(
        for: DamageCalculation.Context(
            attacker: DamageCalculation.Context.Attacker(
                level: PokemonLevel(value: 50),
                movePower: MovePower(value: 100),
                moveType: .ground,
                offensiveStat: OffensiveStat(value: 182),
                offensiveStatStage: .minusOne,
                attackerTypes: .single(.ground),
                terastalState: .none,
                ability: .none
            ),
            defender: DamageCalculation.Context.Defender(
                defensiveStat: DefensiveStat(value: 100),
                defensiveStatCategory: .physical,
                defenderTypes: .dual(.grass, .fighting)
            ),
            field: DamageCalculation.Context.Field(weather: .clear, isCritical: true)
        )
    )

    #expect(
        [
            damages[0], damages[1], damages[2], damages[3],
            damages[4], damages[5], damages[6], damages[7],
            damages[8], damages[9], damages[10], damages[11],
            damages[12], damages[13], damages[14], damages[15],
        ] == [78, 78, 80, 81, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 90, 92]
    )
}

@Test func damageCalculatorCalculateIgnoresPositiveDefensiveStageOnCriticalHit() {
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
                defensiveStatStage: .plusOne,
                defenderTypes: .dual(.grass, .fighting)
            ),
            field: DamageCalculation.Context.Field(weather: .clear, isCritical: true)
        )
    )

    #expect(
        [
            damages[0], damages[1], damages[2], damages[3],
            damages[4], damages[5], damages[6], damages[7],
            damages[8], damages[9], damages[10], damages[11],
            damages[12], damages[13], damages[14], damages[15],
        ] == [78, 78, 80, 81, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 90, 92]
    )
}

@Test func damageCalculatorCalculateAppliesTechnicianMovePowerModifierFromContext() {
    let damages = DamageCalculator.calculate(
        for: DamageCalculation.Context(
            attacker: DamageCalculation.Context.Attacker(
                level: PokemonLevel(value: 50),
                movePower: MovePower(value: 60),
                moveType: .normal,
                offensiveStat: OffensiveStat(value: 100),
                attackerTypes: .single(.fire),
                terastalState: .none,
                ability: .technician
            ),
            defender: DamageCalculation.Context.Defender(
                defensiveStat: DefensiveStat(value: 100),
                defensiveStatCategory: .physical,
                defenderTypes: .single(.fighting)
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
        ] == [34, 35, 35, 36, 36, 36, 37, 37, 38, 38, 38, 39, 39, 40, 40, 41]
    )
}

@Test func damageCalculatorCalculateAppliesGutsOffensiveStatModifierFromContext() {
    let damages = DamageCalculator.calculate(
        for: DamageCalculation.Context(
            attacker: DamageCalculation.Context.Attacker(
                level: PokemonLevel(value: 50),
                movePower: MovePower(value: 100),
                moveType: .normal,
                offensiveStat: OffensiveStat(value: 100),
                attackerTypes: .single(.fire),
                terastalState: .none,
                ability: .guts,
                burnStatus: .burned
            ),
            defender: DamageCalculation.Context.Defender(
                defensiveStat: DefensiveStat(value: 100),
                defensiveStatCategory: .physical,
                defenderTypes: .single(.fighting)
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
        ] == [57, 58, 59, 59, 60, 61, 61, 62, 63, 63, 64, 65, 65, 66, 67, 68]
    )
}

@Test func damageCalculatorCalculateAppliesAssaultVestDefensiveStatModifierFromContext() {
    let damages = DamageCalculator.calculate(
        for: DamageCalculation.Context(
            attacker: DamageCalculation.Context.Attacker(
                level: PokemonLevel(value: 50),
                movePower: MovePower(value: 100),
                moveType: .normal,
                offensiveStat: OffensiveStat(value: 100),
                attackerTypes: .single(.fire),
                terastalState: .none,
                ability: .none
            ),
            defender: DamageCalculation.Context.Defender(
                defensiveStat: DefensiveStat(value: 100),
                defensiveStatCategory: .special,
                defenderTypes: .single(.fighting),
                item: .assaultVest
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
        ] == [26, 26, 26, 27, 27, 27, 28, 28, 28, 29, 29, 29, 30, 30, 30, 31]
    )
}

@Test func damageCalculatorCalculateAppliesLifeOrbDamageModifierFromContext() {
    let damages = DamageCalculator.calculate(
        for: DamageCalculation.Context(
            attacker: DamageCalculation.Context.Attacker(
                level: PokemonLevel(value: 50),
                movePower: MovePower(value: 100),
                moveType: .normal,
                offensiveStat: OffensiveStat(value: 100),
                attackerTypes: .single(.fire),
                terastalState: .none,
                ability: .none,
                item: .lifeOrb
            ),
            defender: DamageCalculation.Context.Defender(
                defensiveStat: DefensiveStat(value: 100),
                defensiveStatCategory: .physical,
                defenderTypes: .single(.fighting)
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
        ] == [51, 51, 52, 52, 52, 53, 53, 55, 55, 56, 56, 57, 57, 59, 59, 60]
    )
}
