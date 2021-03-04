//  Copyright © 2020 Swisscom. All rights reserved.

import UIKit
import RibbonKit

private class Cell: UICollectionViewCell {
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        layer.borderWidth = isFocused ? 3.0 : 0.0
        layer.borderColor = isFocused ? UIColor.red.cgColor : UIColor.clear.cgColor
    }
}

class ViewController: UIViewController {

    let groups = ColorGroup.exampleGroups
    let ribbonList = RibbonListView()

    private lazy var addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didTapAdd))
    private lazy var removeButton = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(didTapRemove))

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ribbons"
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = removeButton

        view.addSubview(ribbonList)
        ribbonList.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ribbonList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ribbonList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            ribbonList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ribbonList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        ribbonList.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        ribbonList.dataSource = self
        ribbonList.delegate = self
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
    func ribbonList(_ ribbonList: RibbonListView, didSelectItemAt indexPath: IndexPath) {
        let cell = ribbonList.cellForItem(at: indexPath)
        let group = groups[indexPath.section]
        UIView.animate(withDuration: 0.5) {
            cell?.backgroundColor = group.colors.randomElement()
        }
    }
}

extension ViewController: RibbonListViewDataSource {
    func numberOfSections(in ribbonList: RibbonListView) -> Int {
        return groups.count
    }

    func ribbonList(_ ribbonList: RibbonListView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cell = ribbonList.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        let group = groups[indexPath.section]
        let color = group.colors[indexPath.row]
        cell.backgroundColor = color
        return cell
    }

    func ribbonList(_ ribbonList: RibbonListView, numberOfItemsInSection section: Int) -> Int {
        return groups[section].colors.count
    }

    func ribbonList(_ ribbonList: RibbonListView, configurationForSectionAt section: Int) -> RibbonConfiguration? {
        return groups[section].configuration
    }
    
    func ribbonList(_ ribbonList: RibbonListView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.text = groups[section].headerTitle
        label.font = .systemFont(ofSize: 30, weight: .bold)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4)
        ])
        return view
    }

    func ribbonList(_ ribbonList: RibbonListView, titleForFooterInSection section: Int) -> String? {
        return groups[section].footerTitle
    }
}
