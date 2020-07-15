//
//  GithubFether.swift
//  Combine-UIKit
//
//  Created by Kotchaphan Muangsan on 15/7/20.
//  Copyright © 2020 Kotchaphan Muangsan. All rights reserved.
//

import Combine
import Foundation

struct GithubFetcher: Fetcher {
    
    func get(username: String?) -> AnyPublisher<Data, Never> {
        return Just(username)
            .compactMap { username -> URL? in
                guard let user = username else { return .none }
                return URL(string: "https://api.github.com/users/\(user)")
            }.flatMap { url -> AnyPublisher<Data, Never> in
                URLSession.shared.dataTaskPublisher(for: url)
                    .map(\.data)
                    .assertNoFailure()
                    .eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
}
