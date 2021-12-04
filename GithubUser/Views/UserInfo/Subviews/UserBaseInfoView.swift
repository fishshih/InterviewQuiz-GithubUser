// 
//  UserBaseInfoView.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

class UserBaseInfoView: UIView {

    // MARK: - Property


    // MARK: - Life cycle

    init() {
        super.init(frame: .zero)

        setupUI()

        bind()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)

        setupUI()

        bind()
    }

    // MARK: - Private property

    private let disposeBag = DisposeBag()
}

// MARK: - UI configure

private extension UserBaseInfoView {

    func setupUI() {

    }
}

// MARK: - Private func

private extension UserBaseInfoView {

}

// MARK: - Binding

private extension UserBaseInfoView {

    func bind() {

    }
}
