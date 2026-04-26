//
//  TypeMultiplier.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

import PokemonTypes

struct TypeMultiplier {
    let numerator: Int
    let denominator: Int

    static let zero = TypeMultiplier(numerator: 0, denominator: 1)
    static let half = TypeMultiplier(numerator: 1, denominator: 2)
    static let neutral = TypeMultiplier(numerator: 1, denominator: 1)
    static let double = TypeMultiplier(numerator: 2, denominator: 1)

    private static let table = LatestTypeEffectivenessTable()

    init(numerator: Int, denominator: Int) {
        precondition(denominator > 0, "denominator must be greater than zero.")

        self.numerator = numerator
        self.denominator = denominator
    }

    init(typeEffectiveness: TypeEffectiveness) {
        switch typeEffectiveness {
        case .ineffective:
            self = .zero
        case .notVeryEffective:
            self = .half
        case .neutral:
            self = .neutral
        case .superEffective:
            self = .double
        }
    }

    static func effectiveness(
        attackType: PokemonType,
        defenderTypes: DefenderTypes
    ) -> TypeMultiplier {
        switch defenderTypes {
        case .single(let primary):
            effectiveness(attackType: attackType, defenderType: primary)
        case .dual(let primary, let secondary):
            effectiveness(attackType: attackType, defenderType: primary)
                .multiplied(
                    by: effectiveness(
                        attackType: attackType,
                        defenderType: secondary
                    )
                )
        }
    }

    static func effectiveness(
        attackType: PokemonType,
        defenderType: PokemonType
    ) -> TypeMultiplier {
        TypeMultiplier(
            typeEffectiveness: table.effectiveness(
                of: attackType,
                against: defenderType
            )
        )
    }

    func multiplied(by other: TypeMultiplier) -> TypeMultiplier {
        if numerator == 0 || other.numerator == 0 {
            return .zero
        }

        return TypeMultiplier(
            numerator: numerator * other.numerator,
            denominator: denominator * other.denominator
        )
    }
}
