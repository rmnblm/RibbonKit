//  Copyright © 2020 Swisscom. All rights reserved.

import UIKit
import RibbonKit

class ViewController: UIViewController {

    let groups = ColorGroup.exampleGroups

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let ribbonList = RibbonList()
        view.addSubview(ribbonList)
        ribbonList.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ribbonList.topAnchor.constraint(equalTo: view.topAnchor),
            ribbonList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ribbonList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ribbonList.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        ribbonList.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        ribbonList.dataSource = self
        ribbonList.delegate = self
    }
}

extension ViewController: RibbonListViewDelegate {
    func ribbonList(_ ribbonList: RibbonList, titleForHeaderInSection section: Int) -> String? {
        return groups[section].name
    }

    func ribbonList(_ ribbonList: RibbonList, heightForSectionAt section: Int) -> CGFloat {
        return groups[section].sectionHeight
    }
}

extension ViewController: RibbonListViewDataSource {
    func numberOfSections(in ribbonList: RibbonList) -> Int {
        return groups.count
    }

    func ribbonList(_ ribbonList: RibbonList, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: UICollectionViewCell = ribbonList.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) else {
            fatalError("Could not dequeue")
        }
        let group = groups[indexPath.section]
        let color = group.colors[indexPath.row]
        cell.backgroundColor = color
        return cell
    }

    func ribbonList(_ ribbonList: RibbonList, numberOfItemsInSection section: Int) -> Int {
        return groups[section].colors.count
    }

    func ribbonList(_ ribbonList: RibbonList, configurationForSectionAt section: Int) -> RibbonConfiguration? {
        return groups[section].configuration
    }
}
