// 
//  UserInfoItemTableViewCell.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

class UserInfoItemTableViewCell: UITableViewCell {

    // MARK: - Property


    // MARK: - Life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()

        bind()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Private property

    private let disposeBag = DisposeBag()
}

// MARK: - UI configure

private extension UserInfoItemTableViewCell {

    func setupUI() {

    }
}

// MARK: - Private func

private extension UserInfoItemTableViewCell {

}

// MARK: - Binding

private extension UserInfoItemTableViewCell {

    func bind() {

    }
}
