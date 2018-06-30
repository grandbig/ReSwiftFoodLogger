//
//  AppState.swift
//  ReSwiftSample
//
//  Created by Takahiro Kato on 2018/06/24.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    var mapState = MapState(places: [], error: nil)
}

struct MapState: StateType {
    var places: [Place]
    var error: Error?
}
