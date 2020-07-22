//  Copyright © 2020 Swisscom. All rights reserved.

import UIKit
import RibbonKit

struct ColorGroup {
    let headerTitle: String
    let footerTitle: String
    let colors: [UIColor]
    let sectionHeight: CGFloat
    let configuration: RibbonConfiguration
}

extension ColorGroup {
    static let exampleGroups: [ColorGroup] = [
        ColorGroup(
            headerTitle: "Blue-ish Colors",
            footerTitle: "A range of blue colors to please your eyes. You can click on a cell to change its color.",
            colors: randomColors(count: 100, hue: .blue, luminosity: .light),
            sectionHeight: 30,
            configuration:
                RibbonConfiguration(
                    itemSize: .init(width: 30, height: 30),
                    minimumLineSpacing: 1
                )
        ),
        ColorGroup(
            headerTitle: "Green-ish Colors",
            footerTitle: "A range of green colors to please your eyes. You can click on a cell to change its color.",
            colors: randomColors(count: 100, hue: .green, luminosity: .light),
            sectionHeight: 50,
            configuration:
                RibbonConfiguration(
                    itemSize: .init(width: 50, height: 50),
                    minimumLineSpacing: 2
                )
        ),
        ColorGroup(
            headerTitle: "Red-ish Colors",
            footerTitle: "A range of red colors to please your eyes. You can click on a cell to change its color.",
            colors: randomColors(count: 100, hue: .red, luminosity: .light),
            sectionHeight: 70,
            configuration:
                RibbonConfiguration(
                    itemSize: .init(width: 70, height: 70),
                    minimumLineSpacing: 3
                )
        ),
        ColorGroup(
            headerTitle: "Purple-ish Colors",
            footerTitle: "A range of purple colors to please your eyes. You can click on a cell to change its color.",
            colors: randomColors(count: 100, hue: .purple, luminosity: .light),
            sectionHeight: RibbonConfiguration.sectionHeight(
                numberOfRows: 4,
                itemSize: .init(width: 100, height: 20),
                minimumInteritemSpacing: 4
            ),
            configuration:
                RibbonConfiguration(
                    itemSize: .init(width: 100, height: 20),
                    minimumLineSpacing: 4,
                    minimumInteritemSpacing: 4
                )
        ),
        ColorGroup(
            headerTitle: "Orange-ish Colors",
            footerTitle: "A range of orange colors to please your eyes. You can click on a cell to change its color.",
            colors: randomColors(count: 100, hue: .orange, luminosity: .light),
            sectionHeight: 120,
            configuration:
                RibbonConfiguration(
                    itemSize: .init(width: 120, height: 120),
                    minimumLineSpacing: 5
                )
        )
    ]
}
