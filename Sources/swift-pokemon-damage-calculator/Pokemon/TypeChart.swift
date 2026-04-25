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
        switch (attackType, defenderType) {
        case (.normal, .rock):
            .half
        case (.normal, .ghost):
            .zero
        case (.fighting, .normal), (.fighting, .rock):
            .double
        case (.fighting, .ghost):
            .zero
        case (.fire, .fire), (.fire, .water), (.fire, .rock):
            .half
        case (.fire, .grass):
            .double
        case (.water, .fire), (.water, .ground), (.water, .rock):
            .double
        case (.water, .water), (.water, .grass):
            .half
        case (.grass, .water), (.grass, .ground), (.grass, .rock):
            .double
        case (.grass, .fire), (.grass, .grass), (.grass, .ghost):
            .half
        case (.electric, .water):
            .double
        case (.electric, .grass), (.electric, .electric):
            .half
        case (.electric, .ground):
            .zero
        case (.ground, .fire), (.ground, .electric), (.ground, .rock):
            .double
        case (.ground, .grass):
            .half
        case (.ground, .ghost):
            .neutral
        case (.rock, .fire):
            .double
        case (.rock, .fighting), (.rock, .ground):
            .half
        case (.ghost, .ghost):
            .double
        case (.ghost, .normal):
            .zero
        default:
            .neutral
        }
    }
}
