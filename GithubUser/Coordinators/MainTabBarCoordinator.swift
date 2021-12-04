// 
//  MainTabBarCoordinator.swift
//  GithubUser
//
//  Created by Fish Shih on 2021/12/4.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Tab bar type

enum TabBarType: Int, CaseIterable {
    case usersList = 0
    case personalInfo
}

extension TabBarType {

    var title: String {
        switch self {
        case .usersList:
            return "Users"
        case .personalInfo:
            return "Mine"
        }
    }

    var image: UIImage? {

        let imgName: String

        if #available(iOS 15, *) {
            switch self {
            case .usersList:
                imgName = "list.bullet.circle.fill"
            case .personalInfo:
                imgName = "person.circle.fill"
            }
        } else {
            switch self {
            case .usersList:
                imgName = "list.bullet"
            case .personalInfo:
                imgName = "person.circle"
            }
        }

        return UIImage(systemName: imgName)?.withRenderingMode(.alwaysTemplate)
    }
}

// MARK: - Coordinator

class MainTabBarCoordinator: Coordinator<Void> {

    var tabBarController: UITabBarController? {
        rootViewController as? UITabBarController
    }

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {

        let tabCoordinators = makeTabCoordinators() --> { coordinator in
            coordinator.forEach {
                $0.start()
                store(coordinator: $0)
            }
        }

        tabList = makeTabList(by: tabCoordinators)
        setupTabBarItem(for: tabCoordinators)

        let tabBarController = makeTabBarController(by: tabCoordinators)

        rootViewController = tabBarController

        window.rootViewController = rootViewController
    }

    // MARK: Private

    fileprivate typealias TabItem = (type: TabBarType, identifier: UUID)

    private let window: UIWindow
    private var tabList = [TabItem]()
}

// MARK: - Tab bar setup

private extension MainTabBarCoordinator {

    /// 建立 TabBarItem
    func makeTabBarItem(by type: TabBarType) -> UITabBarItem {
        .init(title: type.title, image: type.image, tag: type.rawValue)
    }

    /// 建立各 Tab Coordinator
    func makeTabCoordinators() -> [CoordinatorPrototype] {

        var coordinators = [CoordinatorPrototype]()

        TabBarType.allCases.forEach {

            let coordinator: CoordinatorPrototype

            switch $0 {
            case .usersList:

                let tab = UsersListCoordinator()

                tab
                    .output
                    .subscribe(onNext: {
                        [weak self] reaction in
                        switch reaction {
                        default:
                            break
                        }
                    })
                    .disposed(by: disposeBag)

                coordinator = tab

            case .personalInfo:

                let tab = PersonalInfoCoordinator()

                tab
                    .output
                    .subscribe(onNext: {
                        [weak self] reaction in
                        switch reaction {
                        default:
                            break
                        }
                    })
                    .disposed(by: disposeBag)

                coordinator = tab
            }

            coordinators.append(coordinator)
        }

        return coordinators
    }

    /// 設定 TabList，使 MainTabCoordinator 可以透過 TabList 取得各頁面 Coordinator
    func makeTabList(by coordinators: [CoordinatorPrototype]) -> [TabItem] {

        var list = [TabItem]()

        for (index, coordinator) in coordinators.enumerated() {
            guard let type = TabBarType(rawValue: index) else { continue }
            list.append((type, coordinator.identifier))
        }

        return list
    }

    /// 對 Coordinators 所持有的 ViewController 設定 TabBarItem
    func setupTabBarItem(for coordinators: [CoordinatorPrototype]) {
        for (index, coordinator) in coordinators.enumerated() {
            guard let type = TabBarType(rawValue: index) else { continue }
            coordinator.rootViewController?.tabBarItem = makeTabBarItem(by: type)
        }
    }

    /// 建立 TabBarCoordinator，同時給進 ViewControllers
    func makeTabBarController(by coordinators: [CoordinatorPrototype]) -> UITabBarController {

        let vcs = coordinators.compactMap {
            $0.navigationController != nil ? $0.navigationController : $0.rootViewController
        }

        return .init() --> {
            $0.setViewControllers(vcs, animated: true)
            $0.tabBar.tintColor = #colorLiteral(red: 0.07916644961, green: 0.1094686463, blue: 0.178361088, alpha: 1)
            $0.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.702612102, green: 0.6975950599, blue: 0.7064554095, alpha: 1)
            $0.tabBar.isTranslucent = false
            $0.tabBar.backgroundColor = .white
        }
    }

    /// 取得 TabBarType 位於 TabBar 中的 Index
    func getTabBarIndex(by type: TabBarType) -> Int? {
        tabList.firstIndex { $0.type == type }
    }
}
