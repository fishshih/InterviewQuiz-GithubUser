// 
//  PersonalInfoItemView.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/5.
//

import UIKit

class PersonalInfoItemView: UIView {

    // MARK: - Property

    let iconImageView = UIImageView() --> {
        $0.contentMode = .center
    }

    let contentLabel = UILabel() --> {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = #colorLiteral(red: 0.08759657294, green: 0.1211735532, blue: 0.1974031329, alpha: 1)
        $0.numberOfLines = 0
    }

    // MARK: - Life cycle

    init() {
        super.init(frame: .zero)

        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)

        setupUI()
    }
}

// MARK: - UI configure

private extension PersonalInfoItemView {

    func setupUI() {
        configureIconImageView()
        configureContentLabel()
    }

    func configureIconImageView() {

        let height = contentLabel.font.lineHeight

        addSubview(iconImageView)

        iconImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.bottom.equalToSuperview().priority(.low)
            $0.bottom.lessThanOrEqualToSuperview()
            $0.size.equalTo(CGSize(width: height, height: height))
        }
    }

    func configureContentLabel() {

        addSubview(contentLabel)

        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
}
