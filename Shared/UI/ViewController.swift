//  Copyright © 2020 Roman Blum. All rights reserved.

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
        list.dataSource = self
        list.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        list.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        return list
    }()

    private lazy var addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didTapAdd))
    private lazy var removeButton = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(didTapRemove))

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ribbons"
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = removeButton
        #if os(iOS)
        view.backgroundColor = .systemBackground
        #endif

        view.addSubview(ribbonList)
        ribbonList.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ribbonList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ribbonList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            ribbonList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ribbonList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        let headerView = UIView()
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        headerView.backgroundColor = .red
        ribbonList.headerView = headerView
    }

    @objc private func didTapAdd() {
        let section = Int.random(in: 0..<groups.count)
        let group = groups[section]
        let itemIndex = group.insertRandom()
        let indexPath = IndexPath(item: itemIndex, section: section)
        ribbonList.insertItems(at: [indexPath])
        print("Insert at \(indexPath)")
    }

    @objc private func didTapRemove() {
        let sectionsWithItems = groups.enumerated().compactMap { return $1.colors.isEmpty ? nil : $0 }
        guard !sectionsWithItems.isEmpty else { return }
        guard let section = sectionsWithItems.randomElement() else { return }
        let group = groups[section]
        guard let itemIndex = group.removeRandom() else { return }
        let indexPath = IndexPath(item: itemIndex, section: section)
        ribbonList.deleteItems(at: [indexPath])
        print("Delete at \(indexPath)")
    }
}

extension ViewController: RibbonListViewDelegate {
    func ribbonList(_ ribbonList: RibbonListView, widthForItemAt indexPath: IndexPath) -> CGFloat? {
        return indexPath.item == 0 ? 20 : nil
    }

    func ribbonList(_ ribbonList: RibbonListView, didSelectItemAt indexPath: IndexPath) {
        let cell = ribbonList.cellForItem(at: indexPath)
        let group = groups[indexPath.section]
        UIView.animate(withDuration: 0.5) {
            cell?.backgroundColor = group.colors.randomElement()
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

    func ribbonList(_ ribbonList: RibbonListView, configurationForSectionAt section: Int) -> RibbonConfiguration? {
        return groups[section].configuration
    }

    func ribbonList(_ ribbonList: RibbonListView, heightForHeaderInSection section: Int) -> RibbonListLayoutDimension {
        return .absolute(30)
    }
}

extension ViewController: RibbonListViewDataSource {
    func numberOfSections(in ribbonList: RibbonListView) -> Int {
        return groups.count
    }

    func ribbonList(_ ribbonList: RibbonListView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = ribbonList.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let group = groups[indexPath.section]
        let color = group.colors[indexPath.row]
        cell.backgroundColor = color
        return cell
    }

    func ribbonList(_ ribbonList: RibbonListView, numberOfItemsInSection section: Int) -> Int {
        return groups[section].colors.count
    }

    func ribbonList(_ ribbonList: RibbonListView, viewForHeaderInSection section: Int) -> UICollectionReusableView {
        let headerView = ribbonList.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "Header",
            for: IndexPath(item: 0, section: section)
        )
        (headerView as? HeaderView)?.titleLabel.text = groups[section].headerTitle
        return headerView
    }
}
