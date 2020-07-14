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

enum Loading {
    case startLoading
    case stopLoading
}
enum GithubError: Error {
    case invalidURL
    case userNotFound
}

class MainViewModel {
    
    private var cancellable = Set<AnyCancellable>()
    
    struct Input {
        let textFieldTextChange: AnyPublisher<String?, Never>
    }
    
    struct Output {
        let github: AnyPublisher<GithubResponse, Never>
        let loading: AnyPublisher<Loading, Never>
    }
    
    func transform(input: Input) -> Output {
        let loading = CurrentValueSubject<Loading, Never>(.stopLoading)
        let githubResult = input.textFieldTextChange
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .filter { username in username?.count ?? 0 > 3 }
            .handleEvents(receiveOutput: { _ in
                loading.send(.startLoading)
            })
            .compactMap { $0 }
            .compactMap { username -> URL? in
                URL(string: "https://api.github.com/users/\(username)")
            }
            .flatMap { url -> AnyPublisher<GithubResponse, Never> in
                return URLSession.shared.dataTaskPublisher(for: url)
                    .map(\.data)
                    .tryMap { data in
                        let decoder = JSONDecoder()
                        return try decoder.decode(GithubResponse.self, from: data)
                    }
                    .subscribe(on: DispatchQueue.global(qos: .utility))
                    .catch { error in Empty() }
                    .eraseToAnyPublisher()
            }.handleEvents(receiveOutput: { _ in
                loading.send(.stopLoading)
            }).eraseToAnyPublisher()
        
        
        return Output(github: githubResult, loading: loading.eraseToAnyPublisher())
    }
}
