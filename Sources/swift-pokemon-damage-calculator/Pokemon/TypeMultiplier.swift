//
//  TypeMultiplier.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

import PokemonTypes

enum TypeMultiplier: CaseIterable, Equatable, Sendable {
    case zero
    case quarter
    case half
    case neutral
    case double
    case quadruple

    var numerator: Int {
        switch self {
        case .zero:
            0
        case .quarter, .half, .neutral:
            1
        case .double:
            2
        case .quadruple:
            4
        }
    }

    var denominator: Int {
        switch self {
        case .zero, .neutral, .double, .quadruple:
            1
        case .half:
            2
        case .quarter:
            4
        }
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
        TypeEffectivenessResolver().effectiveness(
            attackType: attackType,
            defenderTypes: defenderTypes
        )
    }

    static func effectiveness(
        attackType: PokemonType,
        defenderType: PokemonType
    ) -> TypeMultiplier {
        TypeEffectivenessResolver().effectiveness(
            attackType: attackType,
            defenderType: defenderType
        )
    }

    func multiplied(by other: TypeMultiplier) -> TypeMultiplier {
        switch (self, other) {
        case (.zero, _), (_, .zero):
            .zero
        case (.quarter, .quarter), (.quarter, .half), (.half, .quarter):
            preconditionFailure("Composed type multiplier is outside the supported type space.")
        case (.quarter, .neutral), (.neutral, .quarter), (.half, .half):
            .quarter
        case (.quarter, .double), (.double, .quarter), (.half, .neutral), (.neutral, .half):
            .half
        case (.quarter, .quadruple), (.quadruple, .quarter), (.half, .double), (.double, .half),
            (.neutral, .neutral):
            .neutral
        case (.half, .quadruple), (.quadruple, .half), (.neutral, .double), (.double, .neutral):
            .double
        case (.neutral, .quadruple), (.quadruple, .neutral), (.double, .double):
            .quadruple
        case (.double, .quadruple), (.quadruple, .double), (.quadruple, .quadruple):
            preconditionFailure("Composed type multiplier is outside the supported type space.")
        }
    }
}

struct TypeEffectivenessResolver {
    private let table = LatestTypeEffectivenessTable()

    func effectiveness(
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

    func effectiveness(
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
