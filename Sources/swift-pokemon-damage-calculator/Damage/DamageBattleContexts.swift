//
//  DamageBattleContexts.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

public struct PokemonLevel: Equatable, Sendable {
    public let value: Int

    public init(value: Int) {
        precondition(value > 0, "value must be greater than zero.")

        self.value = value
    }
}

public enum MoveTargetScope: Equatable, Sendable {
    case single
    case multiple

    var modifierNumerator: Int {
        switch self {
        case .single:
            4096
        case .multiple:
            3072
        }
    }
}

public enum ParentalBondHit: Equatable, Sendable {
    case normal
    case second

    var modifierNumerator: Int {
        switch self {
        case .normal:
            4096
        case .second:
            1024
        }
    }
}

public enum DamageWeatherModifier: Equatable, Sendable {
    case none
    case weakened
    case strengthened

    var modifierNumerator: Int {
        switch self {
        case .none:
            4096
        case .weakened:
            2048
        case .strengthened:
            6144
        }
    }
}

public enum SpecialMoveDamageModifier: Equatable, Sendable {
    case none
    case collisionCourseStyle

    var modifierNumerator: Int {
        switch self {
        case .none:
            4096
        case .collisionCourseStyle:
            8192
        }
    }
}

public enum CriticalModifier: Equatable, Sendable {
    case normal
    case critical

    var modifierNumerator: Int {
        switch self {
        case .normal:
            4096
        case .critical:
            6144
        }
    }
}

public struct DamageRandomFactor: Equatable, Sendable {
    public static let minimum = DamageRandomFactor(numerator: 85)
    public static let maximum = DamageRandomFactor(numerator: 100)
    public static let all = (85...100).map(DamageRandomFactor.init(numerator:))

    let numerator: Int
    let denominator: Int = 100

    public init(numerator: Int) {
        precondition((85...100).contains(numerator), "numerator must be between 85 and 100.")

        self.numerator = numerator
    }
}

public enum TypeEffectiveness: Equatable, Sendable {
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
        case .quarter:
            1
        case .half:
            1
        case .neutral:
            1
        case .double:
            2
        case .quadruple:
            4
        }
    }

    var denominator: Int {
        switch self {
        case .zero:
            1
        case .quarter:
            4
        case .half:
            2
        case .neutral:
            1
        case .double:
            1
        case .quadruple:
            1
        }
    }
}

public enum BurnStatus: Equatable, Sendable {
    case none
    case burned
}

public enum ZMoveProtectModifier: Equatable, Sendable {
    case none
    case protected

    var modifierNumerator: Int {
        switch self {
        case .none:
            4096
        case .protected:
            1024
        }
    }
}

public enum MaxMoveProtectModifier: Equatable, Sendable {
    case none
    case protected

    var modifierNumerator: Int {
        switch self {
        case .none:
            4096
        case .protected:
            1024
        }
    }
}
