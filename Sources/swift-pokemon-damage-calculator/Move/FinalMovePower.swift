//
//  FinalMovePower.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

struct FinalMovePower {
    let value: Int

    init(value: Int) {
        precondition(value > 0, "value must be greater than zero.")

        self.value = value
    }
}

struct FinalMovePowerCalculation {
    struct Start {
        let movePower: MovePower

        func applying(_ modifier: MovePowerModifierCalculation.Finalized) -> Modified {
            Modified(
                quotient: DamageCalculation.Quotient(
                    numerator: movePower.value * modifier.value,
                    denominator: MovePowerModifier.denominator
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

        func ensuringMinimumValue(of minimumValue: Int) -> FinalMovePower {
            precondition(minimumValue > 0, "minimumValue must be greater than zero.")

            return FinalMovePower(value: max(value, minimumValue))
        }
    }

    static func start(with movePower: MovePower) -> Start {
        Start(movePower: movePower)
    }
}
