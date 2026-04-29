//
//  FinalDefensiveStat.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

struct FinalDefensiveStat {
    let value: Int

    init(value: Int) {
        precondition(value > 0, "value must be greater than zero.")

        self.value = value
    }
}

struct FinalDefensiveStatCalculation {
    struct Start {
        let defensiveStat: DefensiveStat
        let category: DefensiveStatCategory
        let defenderTypes: DefenderTypes
        let weather: BattleWeather

        func applying(_ rankMultiplier: DefensiveStatRankMultiplier) -> Ranked {
            Ranked(
                value: DamageCalculation.Quotient(
                    numerator: defensiveStat.value * rankMultiplier.numerator,
                    denominator: rankMultiplier.denominator
                ).rounded(.down),
                category: category,
                defenderTypes: defenderTypes,
                weather: weather
            )
        }
    }

    struct Ranked {
        fileprivate let value: Int
        fileprivate let category: DefensiveStatCategory
        fileprivate let defenderTypes: DefenderTypes
        fileprivate let weather: BattleWeather

        func applyingWeatherBoost() -> WeatherAdjusted {
            let appliesSandstormBoost =
                category == .special && weather == .sandstorm && defenderTypes.contains(.rock)
            let appliesSnowBoost =
                category == .physical && weather == .snow && defenderTypes.contains(.ice)
            let adjustedValue =
                if appliesSandstormBoost || appliesSnowBoost {
                    DamageCalculation.Quotient(numerator: value * 6144, denominator: 4096)
                        .rounded(.down)
                } else {
                    value
                }

            return WeatherAdjusted(value: adjustedValue)
        }
    }

    struct WeatherAdjusted {
        fileprivate let value: Int

        func applying(_ modifier: DefensiveStatModifierCalculation.Finalized) -> Modified {
            Modified(
                quotient: DamageCalculation.Quotient(
                    numerator: value * modifier.value,
                    denominator: DefensiveStatModifier.denominator
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

        func ensuringMinimumValue(of minimumValue: Int) -> FinalDefensiveStat {
            precondition(minimumValue > 0, "minimumValue must be greater than zero.")

            return FinalDefensiveStat(value: max(value, minimumValue))
        }
    }

    static func start(
        with defensiveStat: DefensiveStat,
        category: DefensiveStatCategory,
        defenderTypes: DefenderTypes,
        weather: BattleWeather
    ) -> Start {
        Start(
            defensiveStat: defensiveStat,
            category: category,
            defenderTypes: defenderTypes,
            weather: weather
        )
    }
}
