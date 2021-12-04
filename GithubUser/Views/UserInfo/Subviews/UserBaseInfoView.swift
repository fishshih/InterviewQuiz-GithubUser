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

    @Published var avatarURLString: String?
    @Published var name: String?
    @Published var bio: String?
    @Published var height: CGFloat?

    var closeEvent: Observable<Void> {
        closeButton.rx.tap.asObservable()
    }

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

    override func layoutSubviews() {
        super.layoutSubviews()
        height = frame.height
    }

    // MARK: - Private property

    private let closeButton = UIButton() --> {

        let image = UIImage(systemName: "xmark")

        $0.setImage(image, for: .normal)
        $0.setImage(image?.withTintColor(#colorLiteral(red: 0.6419981122, green: 0.7502131462, blue: 0.9661634564, alpha: 1), renderingMode: .alwaysOriginal), for: .highlighted)

        $0.tintColor = #colorLiteral(red: 0.08759657294, green: 0.1211735532, blue: 0.1974031329, alpha: 1)
    }

    private let avatarImageView = UIImageView() --> {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
    }

    private let nameLabel = UILabel() --> {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = #colorLiteral(red: 0.08759657294, green: 0.1211735532, blue: 0.1974031329, alpha: 1)
    }

    private let bioLabel = UILabel() --> {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textAlignment = .center
        $0.textColor = #colorLiteral(red: 0.2503578961, green: 0.3272333741, blue: 0.513871491, alpha: 1)
        $0.numberOfLines = 0
    }

    private let disposeBag = DisposeBag()
    private var cancelableSet = Set<AnyCancellable>()
}

// MARK: - UI configure

private extension UserBaseInfoView {

    func setupUI() {
        backgroundColor = .white
        configureCloseButton()
        configureAvatarImageView()
        configureNameLabel()
        configureBioLabel()
    }

    func configureCloseButton() {

        addSubview(closeButton)

        closeButton.snp.makeConstraints {
            $0.top.leading.equalTo(12)
            $0.size.equalTo(CGSize(width: 44, height: 44))
        }
    }

    func configureAvatarImageView() {

        addSubview(avatarImageView)

        avatarImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(60)
            $0.size.equalTo(CGSize(width: 120, height: 120))
        }

        avatarImageView.transform = .init(scaleX: 0, y: 0)
    }

    func configureNameLabel() {

        addSubview(nameLabel)

        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(avatarImageView.snp.bottom).offset(16)
            $0.leading.greaterThanOrEqualTo(20)
        }
    }

    func configureBioLabel() {

        addSubview(bioLabel)

        bioLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.leading.greaterThanOrEqualTo(80)
            $0.bottom.equalTo(-20)
            $0.height.greaterThanOrEqualTo(36)
        }
    }
}

// MARK: - public func

extension UserBaseInfoView {

    func showAvatar() {

        UIViewPropertyAnimator
            .runningPropertyAnimator(
                withDuration: 0.3,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    [weak avatarImageView] in
                    avatarImageView?.transform = .init(scaleX: 1, y: 1)
                },
                completion: nil
            )
    }
}

// MARK: - Binding

private extension UserBaseInfoView {

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
        $bio.assign(to: \.text, on: bioLabel).store(in: &cancelableSet)
    }
}
