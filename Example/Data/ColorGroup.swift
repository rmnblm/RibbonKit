//  Copyright © 2020 Swisscom. All rights reserved.

import UIKit
import RibbonKit

struct ColorGroup {
    let headerTitle: String
    let footerTitle: String
    let colors: [UIColor]
    let configuration: RibbonConfiguration
}

extension ColorGroup {
    static let exampleGroups: [ColorGroup] = [
        ColorGroup(
            headerTitle: "Blue-ish Colors",
            footerTitle: "A range of blue colors to please your eyes. You can click on a cell to change its color.",
            colors: randomColors(count: 100, hue: .blue, luminosity: .light),
            configuration:
                RibbonConfiguration(
                    sectionHeight: 30,
                    itemSize: .init(width: 30, height: 30),
                    minimumLineSpacing: 1
                )
        ),
        ColorGroup(
            headerTitle: "Green-ish Colors",
            footerTitle: "A range of green colors to please your eyes. You can click on a cell to change its color.",
            colors: randomColors(count: 100, hue: .green, luminosity: .light),
            configuration:
                RibbonConfiguration(
                    sectionHeight: 50,
                    itemSize: .init(width: 50, height: 50),
                    minimumLineSpacing: 2
                )
        ),
        ColorGroup(
            headerTitle: "Red-ish Colors",
            footerTitle: "A range of red colors to please your eyes. You can click on a cell to change its color.",
            colors: randomColors(count: 100, hue: .red, luminosity: .light),
            configuration:
                RibbonConfiguration(
                    sectionHeight: 70,
                    itemSize: .init(width: 70, height: 70),
                    minimumLineSpacing: 3
                )
        ),
        ColorGroup(
            headerTitle: "Purple-ish Colors",
            footerTitle: "A range of purple colors to please your eyes. You can click on a cell to change its color.",
            colors: randomColors(count: 100, hue: .purple, luminosity: .light),
            configuration:
                RibbonConfiguration(
                    numberOfRows: 4,
                    itemSize: .init(width: 100, height: 20),
                    minimumLineSpacing: 4,
                    minimumInteritemSpacing: 4
                )
        ),
        ColorGroup(
            headerTitle: "Orange-ish Colors",
            footerTitle: "A range of orange colors to please your eyes. You can click on a cell to change its color.",
            colors: randomColors(count: 100, hue: .orange, luminosity: .light),
            configuration:
                RibbonConfiguration(
                    sectionHeight: 120,
                    itemSize: .init(width: 120, height: 120),
                    minimumLineSpacing: 5
                )
        )
    ]
}
