//
//  AppReducer.swift
//  ReSwiftSample
//
//  Created by Takahiro Kato on 2018/06/24.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import Foundation
import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()

    state.mapState = MapState.fetchRestaurantsReducer(action: action, state: state.mapState)
    
    return state
}

extension MapState {
    public static func fetchRestaurantsReducer(action: Action, state: MapState?) -> MapState {
        var state = state ?? MapState(places: [], error: nil)
        
        switch action {
        case let action as SuccessRestaurantsAction:
            state.places = action.response
        case let action as APIErrorAction:
            state.error = action.error
        default:
            break
        }
        
        return state
    }
}
