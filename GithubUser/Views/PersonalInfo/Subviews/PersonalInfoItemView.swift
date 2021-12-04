// 
//  PersonalInfoItemView.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/5.
//

import UIKit
import RxSwift
import RxCocoa

class PersonalInfoItemView: UIView {

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

private extension PersonalInfoItemView {

    func setupUI() {

    }
}

// MARK: - Private func

private extension PersonalInfoItemView {

}

// MARK: - Binding

private extension PersonalInfoItemView {

    func bind() {

    }
}
