//
//  GithubResponse.swift
//  Combine-UIKit
//
//  Created by Kotchaphan Muangsan on 14/7/20.
//  Copyright © 2020 Kotchaphan Muangsan. All rights reserved.
//

import Foundation

struct GithubResponse: Decodable {
    let login: String
    let avatar_url: String
}
