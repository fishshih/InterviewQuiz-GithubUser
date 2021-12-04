// 
//  UsersListTableViewCell.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import UIKit
import RxSwift
import RxCocoa
import Combine
import Kingfisher

class UsersListTableViewCell: UITableViewCell {

    // MARK: - Property

    @Published var avatarURLString: String?
    @Published var name: String?
    @Published var userDescription: String?

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

    private static let avatarSize = CGSize(width: 40, height: 40)

    private let avatarImageView = UIImageView() --> {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = avatarSize.height / 2
    }

    private let nameLabel = UILabel() --> {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = #colorLiteral(red: 0.08759657294, green: 0.1211735532, blue: 0.1974031329, alpha: 1)
    }

    private let descLabel = UILabel() --> {
        $0.font = .systemFont(ofSize: 10, weight: .medium)
        $0.textColor = #colorLiteral(red: 0.2503578961, green: 0.3272333741, blue: 0.513871491, alpha: 1)
    }

    private let disposeBag = DisposeBag()
    private var cancelableSet = Set<AnyCancellable>()
}

// MARK: - UI configure

private extension UsersListTableViewCell {

    func setupUI() {
        configureAvatarImageView()
        configureNameLabel()
        configureDescLabel()
    }

    func configureAvatarImageView() {

        contentView.addSubview(avatarImageView)

        avatarImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
            $0.size.equalTo(Self.avatarSize)
        }
    }

    func configureNameLabel() {

        contentView.addSubview(nameLabel)

        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(avatarImageView).offset(-8)
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            $0.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
    }

    func configureDescLabel() {

        contentView.addSubview(descLabel)

        descLabel.snp.makeConstraints {
            $0.centerY.equalTo(avatarImageView).offset(8)
            $0.leading.equalTo(nameLabel)
            $0.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
    }
}

// MARK: - Private func

private extension UsersListTableViewCell { }

// MARK: - Binding

private extension UsersListTableViewCell {

    func bind() {

        $avatarURLString
            .compactMap {
                URL(string: $0 ?? "")
            }
            .sink {
                [weak avatarImageView] in
                avatarImageView?.kf.setImage(with: .network($0))
            }
            .store(in: &cancelableSet)

        $name.assign(to: \.text, on: nameLabel).store(in: &cancelableSet)
        $userDescription.assign(to: \.text, on: descLabel).store(in: &cancelableSet)
    }
}
