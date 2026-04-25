//
//  DefenderTypes.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

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

    func effectivenessMultiplier(against attackType: PokemonType) -> TypeMultiplier {
        switch self {
        case .single(let primary):
            primary.effectivenessMultiplier(against: attackType)
        case .dual(let primary, let secondary):
            primary.effectivenessMultiplier(against: attackType)
                .multiplied(by: secondary.effectivenessMultiplier(against: attackType))
        }
    }
}

struct TypeMultiplier {
    let numerator: Int
    let denominator: Int

    static let zero = TypeMultiplier(numerator: 0, denominator: 1)
    static let quarter = TypeMultiplier(numerator: 1, denominator: 4)
    static let half = TypeMultiplier(numerator: 1, denominator: 2)
    static let neutral = TypeMultiplier(numerator: 1, denominator: 1)
    static let double = TypeMultiplier(numerator: 2, denominator: 1)
    static let quadruple = TypeMultiplier(numerator: 4, denominator: 1)

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

extension PokemonType {
    fileprivate func effectivenessMultiplier(against attackType: PokemonType) -> TypeMultiplier {
        switch (attackType, self) {
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
