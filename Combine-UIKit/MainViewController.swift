//
//  ViewController.swift
//  Combine-UIKit
//
//  Created by Kotchaphan Muangsan on 13/7/20.
//  Copyright © 2020 Kotchaphan Muangsan. All rights reserved.
//

import UIKit
import CombineCocoa
import Combine

class MainViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetcher = GithubFetcher()
        let viewModel = MainViewModel(fetcher: fetcher)
        let input = MainViewModel.Input(textFieldTextChange: usernameTextField.textPublisher)
        
        let output = viewModel.transform(input: input)
        let github = output.github.share()
        
        github
            .map(\.login)
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: usernameLabel)
            .store(in: &cancellable)
        
        github
            .map(\.avatar_url)
            .compactMap { URL(string: $0) }
            .tryMap { try Data(contentsOf: $0) }
            .map { UIImage(data: $0) }
            .assertNoFailure()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .assign(to: \.image, on: avatarImageView)
            .store(in: &cancellable)
        
        output.loading
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] loading in
                switch loading {
                case .startLoading:
                    self?.indicator.startAnimating()
                case .stopLoading:
                    self?.indicator.stopAnimating()
                }
            }).store(in: &cancellable)
    }

}

