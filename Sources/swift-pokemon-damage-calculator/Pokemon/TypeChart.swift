//
//  TypeChart.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

import PokemonTypes

struct TypeChart {
    private static let table = LatestTypeEffectivenessTable()

    static func effectivenessMultiplier(
        attackType: PokemonType,
        defenderTypes: DefenderTypes
    ) -> TypeMultiplier {
        switch defenderTypes {
        case .single(let primary):
            effectivenessMultiplier(attackType: attackType, defenderType: primary)
        case .dual(let primary, let secondary):
            effectivenessMultiplier(attackType: attackType, defenderType: primary)
                .multiplied(
                    by: effectivenessMultiplier(
                        attackType: attackType,
                        defenderType: secondary
                    )
                )
        }
    }

    static func effectivenessMultiplier(
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
}

extension TypeMultiplier {
    fileprivate init(typeEffectiveness: TypeEffectiveness) {
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
}
