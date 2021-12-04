// 
//  UserInfoViewController.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import UIKit
import RxSwift
import RxCocoa

class UserInfoViewController: UIViewController {

    // MARK: - Property

    var viewModel: UserInfoViewModelPrototype?

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

private extension UserInfoViewController {

    func setupUI() {

    }
}

// MARK: - Private func

private extension UserInfoViewController {

}

// MARK: - Binding

private extension UserInfoViewController {

    func bind(_ viewModel: UserInfoViewModelPrototype) {

    }
}
