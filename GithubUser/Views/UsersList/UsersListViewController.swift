// 
//  UsersListViewController.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

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

    @Published private var models = [UsersListElementModel]() {
        didSet {
            tableView.reloadData()
        }
    }

    private var customNavigationController: GUNavigationController? {
        navigationController as? GUNavigationController
    }

    private let tableView = UITableView() --> {
        $0.separatorStyle = .none
        $0.register(UsersListTableViewCell.self)
        $0.contentInset.bottom += 72
    }

    private let disposeBag = DisposeBag()
    private var cancelable = Set<AnyCancellable>()
}

// MARK: - UI configure

private extension UsersListViewController {

    func setupUI() {
        configureNavigationController()
        configureTableView()
    }

    func configureNavigationController() {

        let appearance = UINavigationBarAppearance() --> {

            $0.configureWithTransparentBackground()
            $0.backgroundColor = UIColor.clear

            $0.largeTitleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: UIFont(name: "Verdana-Bold", size: 40) ?? .systemFont(ofSize: 40)
            ]

            $0.titleTextAttributes = [.foregroundColor: UIColor.clear]

            $0.backButtonAppearance = UIBarButtonItemAppearance() --> {
                $0.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
            }
        }

        let nav = customNavigationController
        let navBar = nav?.navigationBar

        navigationItem.title = "GitHub"
        navBar?.prefersLargeTitles = true
        navBar?.standardAppearance = appearance
        navBar?.scrollEdgeAppearance = appearance
        navBar?.tintColor = .white
        navBar?.backgroundColor = .clear
        navBar?.setBackgroundImage(.withColor(.clear), for: .default)
        nav?.navigationItem.backBarButtonItem?.tintColor = .white

        navBar?
            .rx
            .observe(\.frame)
            .map(\.height)
            .subscribe(onNext: {

                let currentBackgroundColor = navBar?.standardAppearance.backgroundColor

                let changeToLarge = $0 >= 60
                let shouldChangeColor = (changeToLarge && currentBackgroundColor != .white) ||
                    (!changeToLarge && currentBackgroundColor != .black )

                guard shouldChangeColor else { return }

                let color: UIColor = changeToLarge ? .white : .black

                UIViewPropertyAnimator
                    .runningPropertyAnimator(
                        withDuration: 0.5,
                        delay: 0,
                        options: [],
                        animations: {

                            navBar?.standardAppearance.backgroundColor = color
                            nav?.statusBarStyle = changeToLarge ? .darkContent : .lightContent

                        },
                        completion: nil
                    )

            })
            .disposed(by: disposeBag)

        let label = UILabel() --> {
            $0.text = navigationItem.title
            $0.font = UIFont(name: "Verdana-Bold", size: 20)
            $0.textColor = .white
        }

        navigationItem.leftBarButtonItem = .init(customView: label)
    }

    func configureTableView() {

        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Private func

private extension UsersListViewController {

}

// MARK: - Binding

private extension UsersListViewController {

    func bind(_ viewModel: UsersListViewModelPrototype) {

        viewModel.output.models.assign(to: \.models, on: self).store(in: &cancelable)

        tableView
            .rx
            .itemSelected
            .asDriver()
            .drive(onNext: {
                [weak tableView] indexPath in
                tableView?.deselectRow(at: indexPath, animated: true)
                viewModel.input.showUserInfo(by: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UsersListTableViewCell.use(table: tableView, for: indexPath)
        let model = models[indexPath.row]

        cell.avatarURLString = model.avatarURL
        cell.name = model.login
        cell.userDescription = model.type.rawValue

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
}
