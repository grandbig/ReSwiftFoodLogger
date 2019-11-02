//
//  AppAction.swift
//  ReSwiftSample
//
//  Created by Takahiro Kato on 2018/06/24.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftThunk
import PromiseKit

extension MapState {
    struct RequestRestaurantsAction: Action {
    }
    
    struct SuccessRestaurantsAction: Action {
        let response: [Place]
    }
    
    struct APIErrorAction: Action {
        let error: Error
    }
    
    static func fetchRestaurantsAction(lat: Double, lng: Double) -> Thunk<AppState> {
        return Thunk<AppState> { dispatch, getState in
            firstly {
                GooglePlacesAPI().fetchRestaurants(lat: lat, lng: lng)
            }.done { results in
                dispatch(SuccessRestaurantsAction(response: results))
            }.catch { error in
                dispatch(APIErrorAction(error: error))
            }
        }
    }
}
