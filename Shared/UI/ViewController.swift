//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit
import RibbonKit

class HeaderView: UICollectionReusableView {

    private(set) lazy var titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) { nil }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    func setupView() {
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

private class Cell: UICollectionViewCell {
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        layer.borderWidth = isFocused ? 3.0 : 0.0
        layer.borderColor = isFocused ? UIColor.red.cgColor : UIColor.clear.cgColor
    }
}

class ViewController: UIViewController {

    let groups = ColorGroup.exampleGroups
    private lazy var ribbonList: RibbonListView = {
        let list = RibbonListView()
        list.delegate = self
        list.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        list.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        return list
    }()

    typealias Snapshot = RibbonListViewDiffableDataSourceSnapshot<ColorGroup, ColorItem>
    typealias DataSource = RibbonListViewDiffableDataSource<ColorGroup, ColorItem>

    private lazy var dataSource: DataSource = {
        let dataSource: DataSource = .init(ribbonList: ribbonList) { ribbonList, indexPath, item in
            let cell: UICollectionViewCell = ribbonList.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = item.color
            return cell
        }

        dataSource.supplementaryViewProvider = { [weak self] ribbonList, kind, indexPath in
            let headerView = ribbonList.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "Header",
                for: IndexPath(item: 0, section: indexPath.section)
            )
            (headerView as? HeaderView)?.titleLabel.text = self?.groups[indexPath.section].headerTitle
            return headerView
        }

        return dataSource
    }()

    private lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .red
        return headerView
    }()

    private lazy var toggleHeaderButton = UIBarButtonItem(title: "Toggle Header", style: .plain, target: self, action: #selector(didTapToggleHeader))
    private lazy var addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didTapAdd))
    private lazy var removeButton = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(didTapRemove))

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ribbons"
        #if os(iOS)
        navigationController?.setToolbarHidden(false, animated: false)
        toolbarItems = [addButton, .flexibleSpace(), removeButton]
        navigationItem.rightBarButtonItem = toggleHeaderButton
        view.backgroundColor = .systemBackground
        #else
        navigationItem.leftBarButtonItems = [addButton, removeButton]
        navigationItem.rightBarButtonItem = toggleHeaderButton
        #endif

        view.addSubview(ribbonList)
        ribbonList.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ribbonList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ribbonList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            ribbonList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ribbonList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        ribbonList.headerView = headerView

        applySnapshot()
    }

    func applySnapshot() {
        let snapshot = Snapshot()

        snapshot.appendSections(groups)
        groups.forEach {
            snapshot.appendItems($0.colors, toSection: $0)
        }

        dataSource.apply(snapshot)
    }

    @objc private func didTapToggleHeader() {
        if ribbonList.headerView != nil {
            ribbonList.headerView = nil
        }
        else {
            ribbonList.headerView = headerView
        }
    }

    @objc private func didTapAdd() {
        let section = Int.random(in: 0..<groups.count)
        let group = groups[section]
        let _ = group.insertRandom()
        applySnapshot()
    }

    @objc private func didTapRemove() {
        let sectionsWithItems = groups.enumerated().compactMap { return $1.colors.isEmpty ? nil : $0 }
        guard !sectionsWithItems.isEmpty else { return }
        guard let section = sectionsWithItems.randomElement() else { return }
        let group = groups[section]
        guard let _ = group.removeRandom() else { return }
        applySnapshot()
    }
}

extension ViewController: RibbonListViewDelegate {
    func ribbonListHeaderHeight(_ ribbonList: RibbonListView) -> RibbonListDimension {
        return .absolute(100)
    }

    func ribbonList(_ ribbonList: RibbonListView, didSelectItemAt indexPath: IndexPath) {
        let cell = ribbonList.cellForItem(at: indexPath)
        let group = groups[indexPath.section]
        UIView.animate(withDuration: 0.5) {
            cell?.backgroundColor = group.colors.randomElement()?.color
        }
    }

    #if os(iOS)
    func ribbonList(_ ribbonList: RibbonListView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let share = UIAction(title: "Share") { _ in }
        let delete = UIAction(title: "Delete") { _ in }

        return UIContextMenuConfiguration(identifier: nil,
          previewProvider: nil) { _ in
          UIMenu(title: "Actions", children: [share, delete])
        }
    }
    #endif

    func ribbonList(_ ribbonList: RibbonListView, configurationForSectionAt section: Int) -> RibbonListSectionConfiguration {
        return groups[section].configuration
    }

    func ribbonList(_ ribbonList: RibbonListView, heightForHeaderInSection section: Int) -> RibbonListDimension {
        return .absolute(30)
    }
}
