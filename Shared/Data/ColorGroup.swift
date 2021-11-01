//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit
import RibbonKit

class ColorGroup {
    let headerTitle: String
    let footerTitle: String
    let configuration: RibbonListSectionConfiguration
    let newColorClosure: (() -> UIColor)

    private(set) var colors: [UIColor]

    init(headerTitle: String, footerTitle: String, configuration: RibbonListSectionConfiguration, newColorClosure: @escaping (() -> UIColor)) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.newColorClosure = newColorClosure
        self.colors = (0..<10).map { _ in newColorClosure() }
        self.configuration = configuration
    }

    func insertRandom() -> Int {
        let index = colors.isEmpty ? 0 : Int.random(in: 0..<colors.count)
        let color = newColorClosure()
        colors.insert(color, at: index)
        return index
    }

    func removeRandom() -> Int? {
        guard !colors.isEmpty else { return nil }
        let index = Int.random(in: 0..<colors.count)
        colors.remove(at: index)
        return index
    }
}

extension ColorGroup {
    static let exampleGroups: [ColorGroup] = [
        ColorGroup(
            headerTitle: "Blue-ish Colors",
            footerTitle: "A range of blue colors to please your eyes. You can click on a cell to change its color.",
            configuration:
                RibbonListSectionConfiguration(
                    layout: .horizontal(heightDimension: .absolute(30), itemWidthDimensions: [.absolute(30), .absolute(100)])
                ),
            newColorClosure: { randomColor(hue: .blue, luminosity: .light) }
        ),
        ColorGroup(
            headerTitle: "Green-ish Colors",
            footerTitle: "A range of green colors to please your eyes. You can click on a cell to change its color.",
            configuration:
                RibbonListSectionConfiguration(
                    layout: .horizontal(heightDimension: .absolute(50), itemWidthDimension: .absolute(50))
                ),
            newColorClosure: { randomColor(hue: .green, luminosity: .light) }
        ),
        ColorGroup(
            headerTitle: "Red-ish Colors",
            footerTitle: "A range of red colors to please your eyes. You can click on a cell to change its color.",
            configuration:
                RibbonListSectionConfiguration(
                    layout: .horizontal(heightDimension: .absolute(70), itemWidthDimension: .absolute(70))
                ),
            newColorClosure: { randomColor(hue: .red, luminosity: .light) }
        ),
        ColorGroup(
            headerTitle: "Purple-ish Colors",
            footerTitle: "A range of purple colors to please your eyes. You can click on a cell to change its color.",
            configuration:
                RibbonListSectionConfiguration(
                    layout: .vertical(numberOfRows: 4, heightDimension: .absolute(70), itemWidthDimension: .absolute(70)),
                    interItemSpacing: 4,
                    interGroupSpacing: 4
                ),
            newColorClosure: { randomColor(hue: .purple, luminosity: .light) }
        ),
        ColorGroup(
            headerTitle: "Orange-ish Colors",
            footerTitle: "A range of orange colors to please your eyes. You can click on a cell to change its color.",
            configuration:
                RibbonListSectionConfiguration(
                    layout: .vertical(numberOfRows: 4, heightDimension: .absolute(70), itemWidthDimension: .absolute(70))
                ),
            newColorClosure: { randomColor(hue: .orange, luminosity: .light) }
        ),
        ColorGroup(
            headerTitle: "Blue-ish Colors",
            footerTitle: "A range of blue colors to please your eyes. You can click on a cell to change its color.",
            configuration:
                RibbonListSectionConfiguration(
                    layout: .horizontal(heightDimension: .absolute(30), itemWidthDimension: .absolute(30))
                ),
            newColorClosure: { randomColor(hue: .blue, luminosity: .light) }
        ),
        ColorGroup(
            headerTitle: "Green-ish Colors",
            footerTitle: "A range of green colors to please your eyes. You can click on a cell to change its color.",
            configuration:
                RibbonListSectionConfiguration(
                    layout: .horizontal(heightDimension: .absolute(30), itemWidthDimension: .absolute(30))
                ),
            newColorClosure: { randomColor(hue: .green, luminosity: .light) }
        )
    ]
}
