//  Copyright © 2020 Swisscom. All rights reserved.

import UIKit

public protocol RibbonListViewDataSource: class {
    func numberOfSections(in ribbonList: RibbonList) -> Int
    func ribbonList(_ ribbonList: RibbonList, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func ribbonList(_ ribbonList: RibbonList, numberOfItemsInSection section: Int) -> Int
    func ribbonList(_ ribbonList: RibbonList, configurationForSectionAt section: Int) -> RibbonConfiguration?
}

public protocol RibbonListViewDelegate: class {
    func ribbonList(_ ribbonList: RibbonList, heightForSectionAt section: Int) -> CGFloat
    func ribbonList(_ ribbonList: RibbonList, titleForHeaderInSection section: Int) -> String?
    func ribbonList(_ ribbonList: RibbonList, didSelectItemAt indexPath: IndexPath)
    func ribbonList(_ ribbonList: RibbonList, didDeselectItemAt indexPath: IndexPath)
}

extension RibbonListViewDelegate {
    public func ribbonList(_ ribbonList: RibbonList, heightForSectionAt section: Int) -> CGFloat { return Constants.defaultSectionHeight }
    public func ribbonList(_ ribbonList: RibbonList, titleForHeaderInSection section: Int) -> String? { return nil }
    public func ribbonList(_ ribbonList: RibbonList, didSelectItemAt indexPath: IndexPath) { }
    public func ribbonList(_ ribbonList: RibbonList, didDeselectItemAt indexPath: IndexPath) { }
}

open class RibbonList: UIView {

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
        let fakeIndexPath = IndexPath(row: indexPath.row, section: 0)
        return collectionView?.dequeueReusableCell(withReuseIdentifier: identifier, for: fakeIndexPath)
    }
}

extension RibbonList: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.ribbonList(self, heightForSectionAt: indexPath.section) ?? Constants.defaultSectionHeight
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return delegate?.ribbonList(self, titleForHeaderInSection: section)
    }
}

extension RibbonList: UITableViewDataSource {
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

        let configuration = dataSource?.ribbonList(self, configurationForSectionAt: indexPath.section) ?? .default
        cell.setConfiguration(configuration)

        return cell
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        displayingCollectionViews.removeValue(forKey: indexPath.section)
        guard let cell = cell as? RibbonCell else { return }
        storedOffsets[indexPath.section] = cell.collectionView.contentOffset.x
    }
}

extension RibbonList: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fakeIndexPath = IndexPath(row: indexPath.row, section: collectionView.tag)
        delegate?.ribbonList(self, didSelectItemAt: fakeIndexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let fakeIndexPath = IndexPath(row: indexPath.row, section: collectionView.tag)
        delegate?.ribbonList(self, didDeselectItemAt: fakeIndexPath)
    }
}

extension RibbonList: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.ribbonList(self, numberOfItemsInSection: collectionView.tag) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let fakeIndexPath = IndexPath(row: indexPath.row, section: collectionView.tag)
        return dataSource?.ribbonList(self, cellForItemAt: fakeIndexPath) ?? UICollectionViewCell()
    }
}
