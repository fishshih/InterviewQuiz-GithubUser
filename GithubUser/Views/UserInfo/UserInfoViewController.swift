// 
//  UserInfoViewController.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

class UserInfoViewController: UIViewController {

    // MARK: - Property

    var viewModel: UserInfoViewModelPrototype?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        guard let viewModel = viewModel else { return }

        bind(viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        baseInfoView.showAvatar()
    }

    // MARK: - Private property

    @Published private var models = [UserInfoItemModel]() {
        didSet {
            tableView.reloadData()
        }
    }

    private let baseInfoView = UserBaseInfoView() --> {
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowOffset = .init(width: 0, height: 0.8)
        $0.layer.shadowRadius = 0
        $0.layer.shadowOpacity = 1
    }

    private let tableView = UITableView() --> {
        $0.separatorStyle = .none
        $0.register(UserInfoItemTableViewCell.self)
        $0.contentInset.bottom += 72
        $0.alwaysBounceVertical = false
    }

    private let disposeBag = DisposeBag()
    private var cancelableSet = Set<AnyCancellable>()
}

// MARK: - UI configure

private extension UserInfoViewController {

    func setupUI() {
        view.backgroundColor = .white
        configureBaseInfoView()
        configureTableView()
    }

    func configureBaseInfoView() {

        view.addSubview(baseInfoView)

        baseInfoView.snp.makeConstraints {
            $0.centerX.top.leading.equalToSuperview()
        }
    }

    func configureTableView() {

        tableView.delegate = self
        tableView.dataSource = self

        view.insertSubview(tableView, at: 0)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Private func

private extension UserInfoViewController {

}

// MARK: - Binding

private extension UserInfoViewController {

    func bind(_ viewModel: UserInfoViewModelPrototype) {

        viewModel
            .output
            .avatarURLString
            .map { Optional($0) }
            .assign(to: &baseInfoView.$avatarURLString)

        viewModel
            .output
            .name
            .map { Optional($0) }
            .assign(to: &baseInfoView.$name)

        viewModel
            .output
            .bio
            .assign(to: &baseInfoView.$bio)

        baseInfoView
            .closeEvent
            .subscribe(onNext: { _ in
                viewModel.input.dismiss()
            })
            .disposed(by: disposeBag)

        baseInfoView
            .$height
            .compactMap { $0 }
            .sink {
                [weak tableView] in
                tableView?.contentInset.top = $0 + 36
            }
            .store(in: &cancelableSet)

        viewModel.output.infoItems.assign(to: \.models, on: self).store(in: &cancelableSet)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension UserInfoViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UserInfoItemTableViewCell.use(table: tableView, for: indexPath)
        let model = models[indexPath.row]

        cell.imageType = model.image
        cell.value = model.value
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
}
