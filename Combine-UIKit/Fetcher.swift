//
//  Fetcher.swift
//  Combine-UIKit
//
//  Created by Kotchaphan Muangsan on 15/7/20.
//  Copyright © 2020 Kotchaphan Muangsan. All rights reserved.
//

import Combine
import Foundation

protocol Fetcher {
    func get(username: String?) -> AnyPublisher<Data, Never>
}
