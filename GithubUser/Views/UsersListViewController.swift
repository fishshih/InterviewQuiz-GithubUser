// 
//  UsersListViewController.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import UIKit
import RxSwift
import RxCocoa

class UsersListViewController: UIViewController {

    // MARK: - Property

    var viewModel: UsersListViewModelPrototype?

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

private extension UsersListViewController {

    func setupUI() {

    }
}

// MARK: - Private func

private extension UsersListViewController {

}

// MARK: - Binding

private extension UsersListViewController {

    func bind(_ viewModel: UsersListViewModelPrototype) {

    }
}
