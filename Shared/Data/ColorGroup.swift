//  Copyright © 2021 Roman Blum. All rights reserved.

import UIKit
import RibbonKit

struct ColorItem: Hashable {
    let id = UUID()
    let color: UIColor

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class ColorGroup {

    let headerTitle: String
    let footerTitle: String
    let configuration: RibbonListSectionConfiguration
    let hue: Hue
    let luminosity: Luminosity

    private(set) var colors: [ColorItem]

    init(headerTitle: String, footerTitle: String, configuration: RibbonListSectionConfiguration, hue: Hue, luminosity: Luminosity) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.colors = (0..<3).map { _ in .init(color: randomColor(hue: hue, luminosity: luminosity)) }
        self.configuration = configuration
        self.hue = hue
        self.luminosity = luminosity
    }

    func insertRandom() -> Int {
        let index = colors.isEmpty ? 0 : Int.random(in: 0..<colors.count)
        let color = randomColor(hue: hue, luminosity: luminosity)
        colors.insert(.init(color: color), at: index)
        return index
    }

    func removeRandom() -> Int? {
        guard !colors.isEmpty else { return nil }
        let index = Int.random(in: 0..<colors.count)
        colors.remove(at: index)
        return index
    }
}

extension ColorGroup: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(headerTitle)
        hasher.combine(footerTitle)
        hasher.combine(configuration)
        hasher.combine(hue)
        hasher.combine(luminosity)
    }

    static func == (lhs: ColorGroup, rhs: ColorGroup) -> Bool {
        lhs.hashValue == rhs.hashValue
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
            hue: .blue,
            luminosity: .light
        ),
        ColorGroup(
            headerTitle: "Green-ish Colors",
            footerTitle: "A range of green colors to please your eyes. You can click on a cell to change its color.",
            configuration:
                RibbonListSectionConfiguration(
                    layout: .horizontal(heightDimension: .absolute(50), itemWidthDimension: .absolute(50))
                ),
            hue: .green,
            luminosity: .light
        ),
        ColorGroup(
            headerTitle: "Red-ish Colors",
            footerTitle: "A range of red colors to please your eyes. You can click on a cell to change its color.",
            configuration:
                RibbonListSectionConfiguration(
                    layout: .horizontal(heightDimension: .absolute(70), itemWidthDimension: .absolute(70))
                ),
            hue: .red,
            luminosity: .light
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
            hue: .purple,
            luminosity: .light
        ),
        ColorGroup(
            headerTitle: "Orange-ish Colors",
            footerTitle: "A range of orange colors to please your eyes. You can click on a cell to change its color.",
            configuration:
                RibbonListSectionConfiguration(
                    layout: .vertical(numberOfRows: 4, heightDimension: .absolute(70), itemWidthDimension: .absolute(70))
                ),
            hue: .orange,
            luminosity: .light
        ),
        ColorGroup(
            headerTitle: "Blue-ish Colors",
            footerTitle: "A range of blue colors to please your eyes. You can click on a cell to change its color.",
            configuration:
                RibbonListSectionConfiguration(
                    layout: .horizontal(heightDimension: .absolute(30), itemWidthDimension: .absolute(30))
                ),
            hue: .blue,
            luminosity: .light
        ),
        ColorGroup(
            headerTitle: "Green-ish Colors",
            footerTitle: "A range of green colors to please your eyes. You can click on a cell to change its color.",
            configuration:
                RibbonListSectionConfiguration(
                    layout: .horizontal(heightDimension: .absolute(30), itemWidthDimension: .absolute(30))
                ),
            hue: .green,
            luminosity: .light
        ),
        ColorGroup(
            headerTitle: "Yellow-ish Colors",
            footerTitle: "A range of yellow colors to please your eyes. You can click on a cell to change its color.",
            configuration:
                RibbonListSectionConfiguration(
                    layout: .list()
                ),
            hue: .yellow,
            luminosity: .light
        )
    ]
}
