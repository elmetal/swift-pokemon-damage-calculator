//
//  FinalDamage.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

struct FinalDamage {
    let value: Int

    init(value: Int) {
        precondition(value >= 0, "value must be greater than or equal to zero.")

        self.value = value
    }
}

struct FinalDamageCalculation {
    struct Start {
        let level: PokemonLevel

        func applying(
            finalMovePower: FinalMovePower,
            finalOffensiveStat: FinalOffensiveStat,
            finalDefensiveStat: FinalDefensiveStat
        ) -> BaseDamage {
            let scaledLevel =
                DamageCalculation.Quotient(
                    numerator: level.value * 2,
                    denominator: 5
                ).rounded(.down) + 2

            let scaledDamage = DamageCalculation.Quotient(
                numerator: scaledLevel * finalMovePower.value * finalOffensiveStat.value,
                denominator: finalDefensiveStat.value
            ).rounded(.down)

            let baseDamage =
                DamageCalculation.Quotient(
                    numerator: scaledDamage,
                    denominator: 50
                ).rounded(.down) + 2

            return BaseDamage(value: baseDamage)
        }
    }

    struct BaseDamage {
        fileprivate let value: Int

        func applyingMoveTargetScope(_ scope: MoveTargetScope) -> MoveTargetAdjusted {
            MoveTargetAdjusted(
                value: FinalDamageCalculation.applyingModifier(scope.modifierNumerator, to: value)
            )
        }
    }

    struct MoveTargetAdjusted {
        fileprivate let value: Int

        func applyingParentalBondHit(_ hit: ParentalBondHit) -> ParentalBondAdjusted {
            ParentalBondAdjusted(
                value: FinalDamageCalculation.applyingModifier(hit.modifierNumerator, to: value)
            )
        }
    }

    struct ParentalBondAdjusted {
        fileprivate let value: Int

        func applyingWeatherModifier(_ modifier: DamageWeatherModifier) -> WeatherAdjusted {
            WeatherAdjusted(
                value: FinalDamageCalculation.applyingModifier(
                    modifier.modifierNumerator,
                    to: value
                )
            )
        }
    }

    struct WeatherAdjusted {
        fileprivate let value: Int

        func applyingSpecialMoveDamageModifier(_ modifier: SpecialMoveDamageModifier)
            -> SpecialMoveAdjusted
        {
            SpecialMoveAdjusted(
                value: FinalDamageCalculation.applyingModifier(
                    modifier.modifierNumerator,
                    to: value
                )
            )
        }
    }

    struct SpecialMoveAdjusted {
        fileprivate let value: Int

        func applyingCriticalModifier(_ modifier: CriticalModifier) -> CriticalAdjusted {
            CriticalAdjusted(
                value: FinalDamageCalculation.applyingModifier(
                    modifier.modifierNumerator,
                    to: value
                )
            )
        }
    }

    struct CriticalAdjusted {
        fileprivate let value: Int

        func applyingRandomFactor(_ randomFactor: DamageRandomFactor) -> RandomAdjusted {
            RandomAdjusted(
                value: DamageCalculation.Quotient(
                    numerator: value * randomFactor.numerator,
                    denominator: randomFactor.denominator
                ).rounded(.down)
            )
        }
    }

    struct RandomAdjusted {
        fileprivate let value: Int

        func applyingSameTypeAttackBonus(
            moveType: PokemonType,
            attackerTypes: AttackerTypes,
            terastalState: TerastalState,
            attackerAbility: AttackerAbility
        ) -> SameTypeAttackBonusAdjusted {
            SameTypeAttackBonusAdjusted(
                value: FinalDamageCalculation.applyingModifier(
                    FinalDamageCalculation.sameTypeAttackBonusNumerator(
                        moveType: moveType,
                        attackerTypes: attackerTypes,
                        terastalState: terastalState,
                        attackerAbility: attackerAbility
                    ),
                    to: value
                )
            )
        }
    }

    struct SameTypeAttackBonusAdjusted {
        fileprivate let value: Int

        func applyingTypeEffectiveness(_ typeEffectiveness: TypeEffectiveness)
            -> TypeEffectivenessAdjusted
        {
            TypeEffectivenessAdjusted(
                value: DamageCalculation.Quotient(
                    numerator: value * typeEffectiveness.numerator,
                    denominator: typeEffectiveness.denominator
                ).rounded(.down)
            )
        }
    }

    struct TypeEffectivenessAdjusted {
        fileprivate let value: Int

        func applyingBurn(
            _ burnStatus: BurnStatus,
            attackerAbility: AttackerAbility,
            moveCategory: DefensiveStatCategory
        ) -> BurnAdjusted {
            let burnModifierNumerator =
                if burnStatus == .burned
                    && moveCategory == .physical
                    && attackerAbility != .guts
                {
                    2048
                } else {
                    4096
                }

            return BurnAdjusted(
                value: FinalDamageCalculation.applyingModifier(burnModifierNumerator, to: value)
            )
        }
    }

    struct BurnAdjusted {
        fileprivate let value: Int

        func applying(_ modifier: DamageModifierCalculation.Finalized) -> DamageModifierAdjusted {
            DamageModifierAdjusted(
                value: FinalDamageCalculation.applyingModifier(modifier.value, to: value)
            )
        }
    }

    struct DamageModifierAdjusted {
        fileprivate let value: Int

        func applyingZMoveProtectModifier(_ modifier: ZMoveProtectModifier) -> ZMoveProtected {
            ZMoveProtected(
                value: FinalDamageCalculation.applyingModifier(
                    modifier.modifierNumerator,
                    to: value
                )
            )
        }
    }

    struct ZMoveProtected {
        fileprivate let value: Int

        func applyingMaxMoveProtectModifier(_ modifier: MaxMoveProtectModifier) -> MaxMoveProtected
        {
            MaxMoveProtected(
                value: FinalDamageCalculation.applyingModifier(
                    modifier.modifierNumerator,
                    to: value
                )
            )
        }
    }

    struct MaxMoveProtected {
        fileprivate let value: Int

        func finalize() -> FinalDamage {
            FinalDamage(value: value)
        }
    }

    static func start(level: PokemonLevel) -> Start {
        Start(level: level)
    }

    private static func applyingModifier(_ numerator: Int, to value: Int) -> Int {
        DamageCalculation.Quotient(
            numerator: value * numerator,
            denominator: 4096
        ).rounded(.toNearestOrDown)
    }

    private static func sameTypeAttackBonusNumerator(
        moveType: PokemonType,
        attackerTypes: AttackerTypes,
        terastalState: TerastalState,
        attackerAbility: AttackerAbility
    ) -> Int {
        let matchesOriginalType = attackerTypes.contains(moveType)
        let matchesTerastalType =
            if case .terastallized(let terastalType) = terastalState {
                terastalType == moveType
            } else {
                false
            }
        let isAdaptability = attackerAbility == .adaptability

        return switch (matchesOriginalType, matchesTerastalType, isAdaptability) {
        case (false, false, _):
            4096
        case (true, true, false):
            8192
        case (true, true, true):
            9216
        case (true, false, false), (false, true, false):
            6144
        case (true, false, true), (false, true, true):
            8192
        }
    }
}
