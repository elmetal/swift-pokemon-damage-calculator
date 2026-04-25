//
//  FinalOffensiveStat.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

struct FinalOffensiveStat {
    let value: Int

    init(value: Int) {
        precondition(value > 0, "value must be greater than zero.")

        self.value = value
    }
}

struct FinalOffensiveStatCalculation {
    struct Start {
        let offensiveStat: OffensiveStat
        let attackerAbility: AttackerAbility

        func applying(_ rankMultiplier: OffensiveStatRankMultiplier) -> Ranked {
            Ranked(
                value: DamageCalculation.Quotient(
                    numerator: offensiveStat.value * rankMultiplier.numerator,
                    denominator: rankMultiplier.denominator
                ).rounded(.down),
                attackerAbility: attackerAbility
            )
        }
    }

    struct Ranked {
        fileprivate let value: Int
        fileprivate let attackerAbility: AttackerAbility

        func applyingAttackerAbility() -> AbilityAdjusted {
            let adjustedValue =
                switch attackerAbility {
                case .none:
                    value
                case .hustle:
                    DamageCalculation.Quotient(
                        numerator: value * 6144,
                        denominator: 4096
                    ).rounded(.down)
                }

            return AbilityAdjusted(value: adjustedValue)
        }
    }

    struct AbilityAdjusted {
        fileprivate let value: Int

        func applying(_ modifier: OffensiveStatModifierCalculation.Finalized) -> Modified {
            Modified(
                quotient: DamageCalculation.Quotient(
                    numerator: value * modifier.value,
                    denominator: OffensiveStatModifier.denominator
                )
            )
        }
    }

    struct Modified {
        fileprivate let quotient: DamageCalculation.Quotient

        func rounded() -> Rounded {
            Rounded(value: quotient.rounded(.toNearestOrDown))
        }
    }

    struct Rounded {
        fileprivate let value: Int

        func ensuringMinimumValue(of minimumValue: Int) -> FinalOffensiveStat {
            precondition(minimumValue > 0, "minimumValue must be greater than zero.")

            return FinalOffensiveStat(value: max(value, minimumValue))
        }
    }

    static func start(with offensiveStat: OffensiveStat, attackerAbility: AttackerAbility) -> Start
    {
        Start(offensiveStat: offensiveStat, attackerAbility: attackerAbility)
    }
}
