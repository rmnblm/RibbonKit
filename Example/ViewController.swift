//  Copyright © 2020 Swisscom. All rights reserved.

import UIKit
import RibbonKit

struct ColorGroup {
    let name: String
    let colors: [UIColor]
}

class ViewController: UIViewController {

    var groups = [ColorGroup]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        groups.append(ColorGroup(name: "Blue Colors", colors: randomColors(count: 20, hue: .blue)))
        groups.append(ColorGroup(name: "Green Colors", colors: randomColors(count: 20, hue: .green)))
        groups.append(ColorGroup(name: "Red Colors", colors: randomColors(count: 20, hue: .red)))

        let ribbonList = RibbonListView()
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
    func ribbonListView(_ ribbonListView: RibbonListView, heightForSectionAt section: Int) -> CGFloat {
        return 80
    }
}

extension ViewController: RibbonListViewDataSource {
    func numberOfSections(in ribbonListView: RibbonListView) -> Int {
        return groups.count
    }

    func ribbonListView(_ ribbonListView: RibbonListView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: UICollectionViewCell = ribbonListView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) else {
            fatalError("Could not dequeue")
        }
        let group = groups[indexPath.section]
        let color = group.colors[indexPath.row]
        cell.backgroundColor = color
        return cell
    }

    func ribbonListView(_ ribbonListView: RibbonListView, numberOfItemsInSection section: Int) -> Int {
        return groups[section].colors.count
    }

    func ribbonListView(_ ribbonListView: RibbonListView, configurationForSectionAt section: Int) -> RibbonConfiguration? {
        return nil
    }
}
