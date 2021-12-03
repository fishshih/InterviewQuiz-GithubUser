// 
//  PersonalInfoViewController.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import UIKit
import RxSwift
import RxCocoa

class PersonalInfoViewController: UIViewController {

    // MARK: - Property

    var viewModel: PersonalInfoViewModelPrototype?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        guard let viewModel = viewModel else { return }

        bind(viewModel)
    }

    // MARK: - Private property

    private let disposeBag = DisposeBag()
}

// MARK: - UI configure

private extension PersonalInfoViewController {

    func setupUI() {

    }
}

// MARK: - Private func

private extension PersonalInfoViewController {

}

// MARK: - Binding

private extension PersonalInfoViewController {

    func bind(_ viewModel: PersonalInfoViewModelPrototype) {

    }
}
