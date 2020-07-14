//
//  MainViewModel.swift
//  Combine-UIKit
//
//  Created by Kotchaphan Muangsan on 14/7/20.
//  Copyright © 2020 Kotchaphan Muangsan. All rights reserved.
//

import Foundation
import Combine
import UIKit

class MainViewModel {
    
    private var cancellable = Set<AnyCancellable>()
    
    struct Input {
        let textFieldTextChange: AnyPublisher<String?, Never>
    }
    
    struct Output {
        let github: AnyPublisher<GithubResponse, Never>
    }
    
    func transform(input: Input) -> Output {
        let githubResult = input.textFieldTextChange
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .filter { username in username?.count ?? 0 > 3 }
            .compactMap { $0 }
            .flatMap{ username -> AnyPublisher<GithubResponse, Never> in
                let url = URL(string: "https://api.github.com/users/\(username)")!
                return URLSession.shared.dataTaskPublisher(for: url)
                    .map(\.data)
                    .tryMap { data in
                        let decoder = JSONDecoder()
                        return try decoder.decode(GithubResponse.self, from: data)
                    }.subscribe(on: DispatchQueue.global(qos: .utility))
                    .assertNoFailure()
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        return Output(github: githubResult)
    }
}
