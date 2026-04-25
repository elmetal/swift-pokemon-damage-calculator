//
//  DefenderTypes.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

public enum PokemonType: Equatable {
    case normal
    case fighting
    case fire
    case water
    case grass
    case electric
    case ground
    case rock
    case ghost
}

public enum DefenderTypes: Equatable {
    case single(PokemonType)
    case dual(PokemonType, PokemonType)

    func contains(_ type: PokemonType) -> Bool {
        switch self {
        case .single(let primary):
            primary == type
        case .dual(let primary, let secondary):
            primary == type || secondary == type
        }
    }

    func effectivenessMultipliers(against attackType: PokemonType) -> [TypeMultiplier] {
        switch self {
        case .single(let primary):
            [primary.effectivenessMultiplier(against: attackType)]
        case .dual(let primary, let secondary):
            [
                primary.effectivenessMultiplier(against: attackType),
                secondary.effectivenessMultiplier(against: attackType),
            ]
        }
    }
}

struct TypeMultiplier {
    let numerator: Int
    let denominator: Int
}

extension PokemonType {
    fileprivate func effectivenessMultiplier(against attackType: PokemonType) -> TypeMultiplier {
        switch (attackType, self) {
        case (.normal, .rock):
            TypeMultiplier(numerator: 1, denominator: 2)
        case (.normal, .ghost):
            TypeMultiplier(numerator: 0, denominator: 1)
        case (.fighting, .normal), (.fighting, .rock):
            TypeMultiplier(numerator: 2, denominator: 1)
        case (.fighting, .ghost):
            TypeMultiplier(numerator: 0, denominator: 1)
        case (.fire, .fire), (.fire, .water), (.fire, .rock):
            TypeMultiplier(numerator: 1, denominator: 2)
        case (.fire, .grass):
            TypeMultiplier(numerator: 2, denominator: 1)
        case (.water, .fire), (.water, .ground), (.water, .rock):
            TypeMultiplier(numerator: 2, denominator: 1)
        case (.water, .water), (.water, .grass):
            TypeMultiplier(numerator: 1, denominator: 2)
        case (.grass, .water), (.grass, .ground), (.grass, .rock):
            TypeMultiplier(numerator: 2, denominator: 1)
        case (.grass, .fire), (.grass, .grass), (.grass, .ghost):
            TypeMultiplier(numerator: 1, denominator: 2)
        case (.electric, .water):
            TypeMultiplier(numerator: 2, denominator: 1)
        case (.electric, .grass), (.electric, .electric):
            TypeMultiplier(numerator: 1, denominator: 2)
        case (.electric, .ground):
            TypeMultiplier(numerator: 0, denominator: 1)
        case (.ground, .fire), (.ground, .electric), (.ground, .rock):
            TypeMultiplier(numerator: 2, denominator: 1)
        case (.ground, .grass):
            TypeMultiplier(numerator: 1, denominator: 2)
        case (.ground, .ghost):
            TypeMultiplier(numerator: 1, denominator: 1)
        case (.rock, .fire):
            TypeMultiplier(numerator: 2, denominator: 1)
        case (.rock, .fighting), (.rock, .ground):
            TypeMultiplier(numerator: 1, denominator: 2)
        case (.ghost, .ghost):
            TypeMultiplier(numerator: 2, denominator: 1)
        case (.ghost, .normal):
            TypeMultiplier(numerator: 0, denominator: 1)
        default:
            TypeMultiplier(numerator: 1, denominator: 1)
        }
    }
}
