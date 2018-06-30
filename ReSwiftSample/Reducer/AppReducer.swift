//
//  AppReducer.swift
//  ReSwiftSample
//
//  Created by Takahiro Kato on 2018/06/24.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import Foundation
import ReSwift

func fetchRestaurantsReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    switch action {
    case let action as SuccessRestaurantsAction:
        state.mapState.places = action.response
    case let action as APIErrorAction:
        state.mapState.error = action.error
    default:
        break
    }
    
    return state
}
