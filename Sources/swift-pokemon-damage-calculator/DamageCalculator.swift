//
//  DamageCalculator.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

import PokemonTypes

public struct DamageCalculator {
    public static func calculate(for context: DamageCalculation.Context) -> InlineArray<16, Int> {
        let attacker = context.attacker
        let defender = context.defender
        let field = context.field
        let moveTargetScope = moveTargetScope(isSpreadMove: field.isSpreadMove)
        let parentalBondHit = parentalBondHit(isSecondHit: field.isParentalBondSecondHit)
        let weatherDamageModifier = damageWeatherModifier(
            weather: field.weather,
            moveType: attacker.moveType
        )
        let specialMoveDamageModifier = specialMoveDamageModifier(
            isCollisionCourseStyleBoosted: field.isCollisionCourseStyleBoosted
        )
        let criticalModifier = criticalModifier(isCritical: field.isCritical)
        let typeMultiplier = TypeMultiplier.effectiveness(
            attackType: attacker.moveType,
            defenderTypes: defender.defenderTypes
        )
        let offensiveRankMultiplier = offensiveStatRankMultiplier(
            for: attacker.offensiveStatStage,
            isCritical: field.isCritical
        )
        let defensiveRankMultiplier = defensiveStatRankMultiplier(
            for: defender.defensiveStatStage,
            isCritical: field.isCritical
        )
        let zMoveProtectModifier = zMoveProtectModifier(isProtected: field.isProtectedByZMove)
        let maxMoveProtectModifier = maxMoveProtectModifier(isProtected: field.isProtectedByMaxMove)
        let movePowerModifier = movePowerModifier(for: attacker)
        let offensiveStatModifier = offensiveStatModifier(
            for: attacker,
            moveCategory: defender.defensiveStatCategory
        )
        let defensiveStatModifier = defensiveStatModifier(for: defender)
        let damageModifier = damageModifier(for: attacker)

        let finalMovePower =
            FinalMovePowerCalculation
            .start(with: attacker.movePower)
            .applying(movePowerModifier)
            .rounded()
            .ensuringMinimumValue(of: 1)

        let finalOffensiveStat =
            FinalOffensiveStatCalculation
            .start(
                with: attacker.offensiveStat,
                attackerAbility: attacker.ability
            )
            .applying(offensiveRankMultiplier)
            .applyingAttackerAbility()
            .applying(offensiveStatModifier)
            .rounded()
            .ensuringMinimumValue(of: 1)

        let finalDefensiveStat =
            FinalDefensiveStatCalculation
            .start(
                with: defender.defensiveStat,
                category: defender.defensiveStatCategory,
                defenderTypes: defender.defenderTypes,
                weather: field.weather
            )
            .applying(defensiveRankMultiplier)
            .applyingWeatherBoost()
            .applying(defensiveStatModifier)
            .rounded()
            .ensuringMinimumValue(of: 1)

        let values = DamageRandomFactor.all.map { randomFactor in
            FinalDamageCalculation
                .start(level: attacker.level)
                .applying(
                    finalMovePower: finalMovePower,
                    finalOffensiveStat: finalOffensiveStat,
                    finalDefensiveStat: finalDefensiveStat
                )
                .applyingMoveTargetScope(moveTargetScope)
                .applyingParentalBondHit(parentalBondHit)
                .applyingWeatherModifier(weatherDamageModifier)
                .applyingSpecialMoveDamageModifier(specialMoveDamageModifier)
                .applyingCriticalModifier(criticalModifier)
                .applyingRandomFactor(randomFactor)
                .applyingSameTypeAttackBonus(
                    moveType: attacker.moveType,
                    attackerTypes: attacker.attackerTypes,
                    terastalState: attacker.terastalState,
                    attackerAbility: attacker.ability
                )
                .applyingTypeEffectiveness(typeMultiplier)
                .applyingBurn(
                    attacker.burnStatus,
                    attackerAbility: attacker.ability,
                    moveCategory: defender.defensiveStatCategory
                )
                .applying(damageModifier)
                .applyingZMoveProtectModifier(zMoveProtectModifier)
                .applyingMaxMoveProtectModifier(maxMoveProtectModifier)
                .finalize()
                .value
        }

        var result: InlineArray<16, Int> = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        for index in values.indices {
            result[index] = values[index]
        }

        return result
    }

    private static func damageWeatherModifier(
        weather: BattleWeather,
        moveType: PokemonType
    ) -> DamageWeatherModifier {
        switch (weather, moveType) {
        case (.sun, .fire), (.rain, .water):
            .strengthened
        case (.sun, .water), (.rain, .fire):
            .weakened
        default:
            .none
        }
    }

    private static func moveTargetScope(isSpreadMove: Bool) -> MoveTargetScope {
        isSpreadMove ? .multiple : .single
    }

    private static func parentalBondHit(isSecondHit: Bool) -> ParentalBondHit {
        isSecondHit ? .second : .normal
    }

    private static func specialMoveDamageModifier(
        isCollisionCourseStyleBoosted: Bool
    ) -> SpecialMoveDamageModifier {
        isCollisionCourseStyleBoosted ? .collisionCourseStyle : .none
    }

    private static func criticalModifier(isCritical: Bool) -> CriticalModifier {
        isCritical ? .critical : .normal
    }

    private static func movePowerModifier(
        for attacker: DamageCalculation.Context.Attacker
    ) -> MovePowerModifierCalculation.Finalized {
        if attacker.ability == .technician && attacker.movePower.value <= 60 {
            return MovePowerModifierCalculation.start
                .applying(MovePowerModifier(numerator: 6144))
                .finalize()
        }

        return MovePowerModifierCalculation.start.finalize()
    }

    private static func offensiveStatModifier(
        for attacker: DamageCalculation.Context.Attacker,
        moveCategory: DefensiveStatCategory
    ) -> OffensiveStatModifierCalculation.Finalized {
        if attacker.ability == .guts && attacker.burnStatus == .burned && moveCategory == .physical
        {
            return OffensiveStatModifierCalculation.start
                .applying(OffensiveStatModifier(numerator: 6144))
                .finalize()
        }

        return OffensiveStatModifierCalculation.start.finalize()
    }

    private static func defensiveStatModifier(
        for defender: DamageCalculation.Context.Defender
    ) -> DefensiveStatModifierCalculation.Finalized {
        if defender.item == .assaultVest && defender.defensiveStatCategory == .special {
            return DefensiveStatModifierCalculation.start
                .applying(DefensiveStatModifier(numerator: 6144))
                .finalize()
        }

        return DefensiveStatModifierCalculation.start.finalize()
    }

    private static func damageModifier(
        for attacker: DamageCalculation.Context.Attacker
    ) -> DamageModifierCalculation.Finalized {
        if attacker.item == .lifeOrb {
            return DamageModifierCalculation.start
                .applying(DamageModifier(numerator: 5325))
                .finalize()
        }

        return DamageModifierCalculation.start.finalize()
    }

    private static func zMoveProtectModifier(isProtected: Bool) -> ZMoveProtectModifier {
        isProtected ? .protected : .none
    }

    private static func maxMoveProtectModifier(isProtected: Bool) -> MaxMoveProtectModifier {
        isProtected ? .protected : .none
    }

    private static func offensiveStatRankMultiplier(
        for stage: StatStage,
        isCritical: Bool
    ) -> OffensiveStatRankMultiplier {
        let effectiveStage = isCritical && stage.rawValue < 0 ? .neutral : stage
        let (numerator, denominator) = rankFraction(for: effectiveStage)
        return OffensiveStatRankMultiplier(numerator: numerator, denominator: denominator)
    }

    private static func defensiveStatRankMultiplier(
        for stage: StatStage,
        isCritical: Bool
    ) -> DefensiveStatRankMultiplier {
        let effectiveStage = isCritical && stage.rawValue > 0 ? .neutral : stage
        let (numerator, denominator) = rankFraction(for: effectiveStage)
        return DefensiveStatRankMultiplier(numerator: numerator, denominator: denominator)
    }

    private static func rankFraction(for stage: StatStage) -> (Int, Int) {
        let rawValue = stage.rawValue
        if rawValue >= 0 {
            return (2 + rawValue, 2)
        }

        return (2, 2 + abs(rawValue))
    }

}
