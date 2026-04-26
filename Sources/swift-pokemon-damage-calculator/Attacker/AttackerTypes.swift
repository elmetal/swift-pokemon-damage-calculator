//
//  AttackerTypes.swift
//  swift-pokemon-damage-calculator
//
//  Created by elmetal on 2026/04/25
//
//

import PokemonTypes

public enum AttackerTypes: Equatable {
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
}

public enum TerastalState: Equatable {
    case none
    case terastallized(PokemonType)
}
