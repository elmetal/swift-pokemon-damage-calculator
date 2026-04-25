//
//  OffensiveStatModifier.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

struct OffensiveStatModifier {
    static let denominator = 4096

    let numerator: Int

    init(numerator: Int) {
        precondition(numerator > 0, "numerator must be greater than zero.")

        self.numerator = numerator
    }
}

struct OffensiveStatModifierCalculation {
    struct Start {
        fileprivate let value = OffensiveStatModifier.denominator

        func applying(_ modifier: OffensiveStatModifier) -> Modified {
            Modified(value: OffensiveStatModifierCalculation.apply(modifier, to: value))
        }

        func finalize() -> Finalized {
            Finalized(value: value)
        }
    }

    struct Modified {
        fileprivate let value: Int

        func applying(_ modifier: OffensiveStatModifier) -> Modified {
            Modified(value: OffensiveStatModifierCalculation.apply(modifier, to: value))
        }

        func finalize() -> Finalized {
            Finalized(value: value)
        }
    }

    struct Finalized {
        let value: Int

        init(value: Int) {
            precondition(value > 0, "value must be greater than zero.")

            self.value = value
        }
    }

    static let start = Start()

    private static func apply(_ modifier: OffensiveStatModifier, to currentValue: Int) -> Int {
        DamageCalculation.Quotient(
            numerator: currentValue * modifier.numerator,
            denominator: OffensiveStatModifier.denominator
        )
        .rounded(.toNearestOrUp)
    }
}
