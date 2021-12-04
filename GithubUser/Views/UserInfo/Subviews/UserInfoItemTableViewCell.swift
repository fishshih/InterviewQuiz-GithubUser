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

    @Published var image: ImageType?
    @Published var value: String?

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

    private let iconImageView = UIImageView()

    private let valueLabel = UILabel() --> {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = #colorLiteral(red: 0.08759657294, green: 0.1211735532, blue: 0.1974031329, alpha: 1)
    }

    private let disposeBag = DisposeBag()
    private var cancelableSet = Set<AnyCancellable>()
}

// MARK: - UI configure

private extension UserInfoItemTableViewCell {

    func setupUI() {
        configureIconImageView()
        configureValueLabel()
    }

    func configureIconImageView() {

        contentView.addSubview(iconImageView)

        iconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(40)
            $0.width.equalTo(40)
        }
    }

    func configureValueLabel() {

        contentView.addSubview(valueLabel)

        valueLabel.snp.makeConstraints {
            $0.centerY.equalTo(iconImageView)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(24)
            $0.trailing.lessThanOrEqualToSuperview().offset(-40)
        }
    }
}

// MARK: - Private func

private extension UserInfoItemTableViewCell { }

// MARK: - Binding

private extension UserInfoItemTableViewCell {

    func bind() {

        $image
            .map {
                switch $0 {
                case .system(name: let name):
                    return UIImage(systemName: name)
                case .asset(name: let name):
                    return UIImage(named: name)
                }
            }
            .assign(to: \.image, on: iconImageView)
            .store(in: &cancelableSet)

        $value.assign(to: \.text, on: valueLabel).store(in: &cancelableSet)
    }
}
