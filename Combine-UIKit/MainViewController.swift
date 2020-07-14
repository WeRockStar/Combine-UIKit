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
    private let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let input = MainViewModel.Input(textFieldTextChange: usernameTextField.textPublisher)
        
        let output = viewModel.transform(input: input)
        output.github
            .map(\.login)
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: usernameLabel)
            .store(in: &cancellable)
        
    }

}

