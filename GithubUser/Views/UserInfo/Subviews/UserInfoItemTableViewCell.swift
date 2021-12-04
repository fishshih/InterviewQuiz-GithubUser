// 
//  UserInfoItemTableViewCell.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import UIKit
import Combine

class UserInfoItemTableViewCell: UITableViewCell {

    // MARK: - Property

    @Published var imageType: ImageType?
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

    private let iconImageView = UIImageView() --> {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = #colorLiteral(red: 0.08759657294, green: 0.1211735532, blue: 0.1974031329, alpha: 1)
    }

    private let valueLabel = UILabel() --> {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = #colorLiteral(red: 0.3854748011, green: 0.4147148132, blue: 0.5077751875, alpha: 1)
    }

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
            $0.centerX.equalToSuperview().multipliedBy(0.5)
            $0.width.equalTo(40)
        }
    }

    func configureValueLabel() {

        contentView.addSubview(valueLabel)

        valueLabel.snp.makeConstraints {
            $0.centerY.equalTo(iconImageView)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(18)
            $0.trailing.lessThanOrEqualToSuperview().offset(-30)
        }
    }
}

// MARK: - Binding

private extension UserInfoItemTableViewCell {

    func bind() {

        $imageType
            .compactMap { $0 }
            .map {
                switch $0 {
                case .system(name: let name):
                    let config = UIImage.SymbolConfiguration(pointSize: 24)
                    return UIImage(systemName: name, withConfiguration: config)
                case .asset(name: let name):
                    return UIImage(named: name)
                }
            }
            .assign(to: \.image, on: iconImageView)
            .store(in: &cancelableSet)

        $value.assign(to: \.text, on: valueLabel).store(in: &cancelableSet)
    }
}
