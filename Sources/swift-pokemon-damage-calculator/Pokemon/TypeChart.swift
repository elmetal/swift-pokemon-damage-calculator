//
//  TypeChart.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

struct TypeChart {
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
        if defenderType.immunities.contains(attackType) {
            return .zero
        }

        if defenderType.weaknesses.contains(attackType) {
            return .double
        }

        if defenderType.resistances.contains(attackType) {
            return .half
        }

        return .neutral
    }
}

extension PokemonType {
    fileprivate var weaknesses: [PokemonType] {
        switch self {
        case .normal:
            [.fighting]
        case .fire:
            [.water, .ground, .rock]
        case .water:
            [.electric, .grass]
        case .electric:
            [.ground]
        case .grass:
            [.fire, .ice, .poison, .flying, .bug]
        case .ice:
            [.fire, .fighting, .rock, .steel]
        case .fighting:
            [.flying, .psychic, .fairy]
        case .poison:
            [.ground, .psychic]
        case .ground:
            [.water, .grass, .ice]
        case .flying:
            [.electric, .ice, .rock]
        case .psychic:
            [.bug, .ghost, .dark]
        case .bug:
            [.fire, .flying, .rock]
        case .rock:
            [.water, .grass, .fighting, .ground, .steel]
        case .ghost:
            [.ghost, .dark]
        case .dragon:
            [.ice, .dragon, .fairy]
        case .dark:
            [.fighting, .bug, .fairy]
        case .steel:
            [.fire, .fighting, .ground]
        case .fairy:
            [.poison, .steel]
        }
    }

    fileprivate var resistances: [PokemonType] {
        switch self {
        case .normal:
            []
        case .fire:
            [.fire, .grass, .ice, .bug, .steel, .fairy]
        case .water:
            [.fire, .water, .ice, .steel]
        case .electric:
            [.electric, .flying, .steel]
        case .grass:
            [.water, .electric, .grass, .ground]
        case .ice:
            [.ice]
        case .fighting:
            [.bug, .rock, .dark]
        case .poison:
            [.grass, .fighting, .poison, .bug, .fairy]
        case .ground:
            [.poison, .rock]
        case .flying:
            [.grass, .fighting, .bug]
        case .psychic:
            [.fighting, .psychic]
        case .bug:
            [.grass, .fighting, .ground]
        case .rock:
            [.normal, .fire, .poison, .flying]
        case .ghost:
            [.poison, .bug]
        case .dragon:
            [.fire, .water, .electric, .grass]
        case .dark:
            [.ghost, .dark]
        case .steel:
            [
                .normal, .grass, .ice, .flying, .psychic, .bug, .rock, .dragon,
                .steel, .fairy,
            ]
        case .fairy:
            [.fighting, .bug, .dark]
        }
    }

    fileprivate var immunities: [PokemonType] {
        switch self {
        case .normal:
            [.ghost]
        case .ground:
            [.electric]
        case .flying:
            [.ground]
        case .ghost:
            [.normal, .fighting]
        case .dark:
            [.psychic]
        case .steel:
            [.poison]
        case .fairy:
            [.dragon]
        case .fire, .water, .electric, .grass, .ice, .fighting, .poison, .psychic, .bug,
            .rock, .dragon:
            []
        }
    }
}
