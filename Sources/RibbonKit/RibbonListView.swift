//  Copyright © 2020 Swisscom. All rights reserved.

import UIKit

public protocol RibbonListViewDataSource: class {
    func numberOfSections(in ribbonListView: RibbonListView) -> Int
    func ribbonListView(_ ribbonListView: RibbonListView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func ribbonListView(_ ribbonListView: RibbonListView, numberOfItemsInSection section: Int) -> Int
    func ribbonListView(_ ribbonListView: RibbonListView, configurationForSectionAt section: Int) -> RibbonConfiguration?
}

public protocol RibbonListViewDelegate: class {
    func ribbonListView(_ ribbonListView: RibbonListView, heightForSectionAt section: Int) -> CGFloat
}

struct CellRegistration {
    let reuseIdentifier: String
    let cellClass: AnyClass?
}

public struct RibbonConfiguration {

}

class Test: UICollectionViewCell { }

open class RibbonListView: UIView {

    open weak var dataSource: RibbonListViewDataSource?

    open weak var delegate: RibbonListViewDelegate?

    open var tableView = UITableView(frame: .zero, style: .grouped)

    private var cellRegistrations: [CellRegistration] = []
    private var displayingCollectionViews: [Int: UICollectionView] = [:]
    private var storedOffsets: [Int: CGFloat] = [:]

    public init() {
        super.init(frame: .zero)
        setupView()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(RibbonCell.self)
    }

    open func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        cellRegistrations.append(.init(reuseIdentifier: identifier, cellClass: cellClass))
    }

    open func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell? {
        let collectionView = displayingCollectionViews[indexPath.section]
        return collectionView?.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath(row: indexPath.row, section: 0))
    }
}

extension RibbonListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.ribbonListView(self, heightForSectionAt: indexPath.section) ?? 100
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "I am a section!"
    }
}

extension RibbonListView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RibbonCell = tableView.dequeueReusableCell(for: indexPath)
        displayingCollectionViews[indexPath.section] = cell.collectionView
        cell.registerCellsIfNecessary(registrations: cellRegistrations)
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.tag = indexPath.section
        cell.collectionView.contentOffset.x = storedOffsets[indexPath.section] ?? 0
        cell.configuration = dataSource?.ribbonListView(self, configurationForSectionAt: indexPath.section)
        return cell
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        displayingCollectionViews.removeValue(forKey: indexPath.section)
        guard let cell = cell as? RibbonCell else { return }
        storedOffsets[indexPath.row] = cell.collectionView.contentOffset.x
    }
}

extension RibbonListView: UICollectionViewDelegate {

}

extension RibbonListView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.ribbonListView(self, numberOfItemsInSection: collectionView.tag) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource?.ribbonListView(self, cellForItemAt: IndexPath(row: indexPath.row, section: collectionView.tag)) ?? UICollectionViewCell()
    }
}
