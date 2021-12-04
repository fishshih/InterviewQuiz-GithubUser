// 
//  PersonalInfoViewController.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import UIKit
import Combine
import Kingfisher

class PersonalInfoViewController: UIViewController {

    // MARK: - Property

    var viewModel: PersonalInfoViewModelPrototype?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        guard let viewModel = viewModel else { return }

        bind(viewModel)
    }

    // MARK: - Private property

    private static let avatarSize = CGSize(width: 120, height: 120)

    private let coverImageView = UIImageView() --> {

        $0.backgroundColor = #colorLiteral(red: 0.9625373483, green: 0.9508945346, blue: 0.9713860154, alpha: 1)
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill

        if let url = URL(string: "https://picsum.photos/600/300/?blur=4") {
            $0.kf.setImage(with: .network(url))
        }
    }

    private let avatarImageView = UIImageView() --> {
        $0.backgroundColor = .lightGray
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = avatarSize.height / 2
    }

    private let nameLabel = UILabel() --> {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .black
    }

    private let loginIDLabel = UILabel() --> {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .gray
    }

    private let infoItemStackView = UIStackView() --> {
        $0.axis = .vertical
        $0.spacing = 12
    }

    private static let imageConfig = UIImage.SymbolConfiguration(pointSize: 16)

    private let followInfoView = PersonalInfoItemView() --> {

        $0.iconImageView.image = UIImage(
            systemName: "person.2",
            withConfiguration: imageConfig
        )?.withRenderingMode(.alwaysTemplate)

        $0.iconImageView.tintColor = #colorLiteral(red: 0.08759657294, green: 0.1211735532, blue: 0.1974031329, alpha: 1)
    }

    private let numberOfRepositoriesView = PersonalInfoItemView() --> {

        $0.iconImageView.image = UIImage(
            systemName: "shippingbox",
            withConfiguration: imageConfig
        )?.withRenderingMode(.alwaysTemplate)

        $0.iconImageView.tintColor = #colorLiteral(red: 0.08759657294, green: 0.1211735532, blue: 0.1974031329, alpha: 1)
    }

    private let emailView = PersonalInfoItemView() --> {

        $0.iconImageView.image = UIImage(
            systemName: "envelope",
            withConfiguration: imageConfig
        )?.withRenderingMode(.alwaysTemplate)

        $0.iconImageView.tintColor = #colorLiteral(red: 0.08759657294, green: 0.1211735532, blue: 0.1974031329, alpha: 1)
    }

    private let statementLabel = UILabel() --> {

        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.alpha = 0.9

        let attr = NSMutableAttributedString()

        attr.append(text: "for\n", font: .systemFont(ofSize: 12, weight: .medium), textColor: .lightGray)
        attr.append(text: "PRACTICE", font: .systemFont(ofSize: 13, weight: .bold), textColor: .gray)

        $0.attributedText = attr
    }

    private var cancelableSet = Set<AnyCancellable>()
}

// MARK: - UI configure

private extension PersonalInfoViewController {

    func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.9625373483, green: 0.9508945346, blue: 0.9713860154, alpha: 1)
        configureNavigation()
        configureCoverImageView()
        configureAvatarImageView()
        configureNameLabel()
        configureLoginIDLabel()
        configureInfoItemStackView()
        configureInfoItemViews()
        configureStatementLabel()
    }

    func configureNavigation() {

        let appearance = UINavigationBarAppearance() --> {
            $0.configureWithTransparentBackground()
            $0.backgroundColor = UIColor.black
            $0.titleTextAttributes = [.foregroundColor: UIColor.clear]
        }

        let nav = navigationController as? GUNavigationController
        let navBar = nav?.navigationBar

        navigationItem.title = "GitHub"
        navBar?.standardAppearance = appearance
        navBar?.scrollEdgeAppearance = appearance
        navBar?.tintColor = .white
        navBar?.backgroundColor = .clear
        navBar?.setBackgroundImage(.withColor(.clear), for: .default)
        nav?.statusBarStyle = .lightContent

        let label = UILabel() --> {
            $0.text = navigationItem.title
            $0.font = UIFont(name: "Verdana-Bold", size: 20)
            $0.textColor = view.backgroundColor
        }

        navigationItem.leftBarButtonItem = .init(customView: label)
    }

    func configureCoverImageView() {

        view.addSubview(coverImageView)

        coverImageView.snp.makeConstraints {
            $0.centerX.leading.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(coverImageView.snp.width).dividedBy(2)
        }
    }

    func configureAvatarImageView() {

        view.addSubview(avatarImageView)

        avatarImageView.snp.makeConstraints {
            $0.centerY.equalTo(coverImageView.snp.bottom)
            $0.leading.equalTo(24)
            $0.size.equalTo(Self.avatarSize)
        }
    }

    func configureNameLabel() {

        view.addSubview(nameLabel)

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom).offset(16)
            $0.leading.equalTo(34)
            $0.trailing.lessThanOrEqualTo(-32)
            $0.height.equalTo(30)
        }
    }

    func configureLoginIDLabel() {

        view.addSubview(loginIDLabel)

        loginIDLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalTo(nameLabel)
            $0.trailing.lessThanOrEqualTo(-32)
            $0.height.equalTo(28)
        }
    }

    func configureInfoItemStackView() {

        view.addSubview(infoItemStackView)

        infoItemStackView.snp.makeConstraints {
            $0.top.equalTo(loginIDLabel.snp.bottom).offset(20)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalTo(-20)
        }
    }

    func configureInfoItemViews() {
        infoItemStackView.addArrangedSubview(followInfoView)
        infoItemStackView.addArrangedSubview(numberOfRepositoriesView)
        infoItemStackView.addArrangedSubview(emailView)
    }

    func configureStatementLabel() {

        view.addSubview(statementLabel)

        statementLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-18)
        }
    }
}

// MARK: - Private func

private extension PersonalInfoViewController {

    func formatFollowInfo(by numOfFollowers: Int, numOfFollowing: Int) -> NSAttributedString {

        return NSMutableAttributedString() --> {

            let lightColor = #colorLiteral(red: 0.3854748011, green: 0.4147148132, blue: 0.5077751875, alpha: 1)

            $0.append(text: String(numOfFollowers))
            $0.append(text: " followers ∙ ", textColor: lightColor)
            $0.append(text: String(numOfFollowing))
            $0.append(text: " following", textColor: lightColor)
        }
    }

    func format(numberOfRepositories num: Int) -> NSAttributedString {

        return NSMutableAttributedString() --> {

            let lightColor = #colorLiteral(red: 0.3854748011, green: 0.4147148132, blue: 0.5077751875, alpha: 1)

            $0.append(text: String(num))
            $0.append(text: " repositories", textColor: lightColor)
        }
    }
}

// MARK: - Binding

private extension PersonalInfoViewController {

    func bind(_ viewModel: PersonalInfoViewModelPrototype) {

        viewModel
            .output
            .avatarURLString
            .compactMap { URL(string: $0) }
            .sink {
                [weak avatarImageView] in
                avatarImageView?.kf.setImage(with: .network($0))
            }
            .store(in: &cancelableSet)

        viewModel
            .output
            .name
            .map { Optional($0) }
            .assign(to: \.text, on: nameLabel)
            .store(in: &cancelableSet)

        viewModel
            .output
            .loginID
            .map { Optional($0) }
            .assign(to: \.text, on: loginIDLabel)
            .store(in: &cancelableSet)

        Publishers
            .Zip(
                viewModel.output.numberOfFollowers,
                viewModel.output.numberOfFollowing
            )
            .map {
                [weak self] in
                self?.formatFollowInfo(by: $0.0, numOfFollowing: $0.1)
            }
            .assign(to: \.contentLabel.attributedText, on: followInfoView)
            .store(in: &cancelableSet)

        viewModel
            .output
            .numberOfRepositories
            .map {
                [weak self] in
                self?.format(numberOfRepositories: $0)
            }
            .assign(to: \.contentLabel.attributedText, on: numberOfRepositoriesView)
            .store(in: &cancelableSet)

        viewModel
            .output
            .email
            .map { _ in "fish.shih@icloud.com" }
            .assign(to: \.contentLabel.text, on: emailView)
            .store(in: &cancelableSet)
    }
}
