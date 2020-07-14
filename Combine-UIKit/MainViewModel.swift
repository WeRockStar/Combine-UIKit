//
//  MainViewModel.swift
//  Combine-UIKit
//
//  Created by Kotchaphan Muangsan on 14/7/20.
//  Copyright © 2020 Kotchaphan Muangsan. All rights reserved.
//

import Foundation
import Combine

class MainViewModel {
    
    struct Input {
        let textFieldTextChange: AnyPublisher<String, Never>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
