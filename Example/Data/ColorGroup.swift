//  Copyright © 2020 Swisscom. All rights reserved.

import UIKit
import RibbonKit

struct ColorGroup {
    let name: String
    let colors: [UIColor]
    let sectionHeight: CGFloat
    let configuration: RibbonConfiguration
}

extension ColorGroup {
    static let exampleGroups: [ColorGroup] = [
        ColorGroup(
            name: "Blue-ish Colors",
            colors: randomColors(count: 100, hue: .blue, luminosity: .light),
            sectionHeight: 30,
            configuration:
                RibbonConfiguration(
                    itemSize: .init(width: 30, height: 30),
                    minimumLineSpacing: 5
                )
        ),
        ColorGroup(
            name: "Green-ish Colors",
            colors: randomColors(count: 100, hue: .green, luminosity: .light),
            sectionHeight: 50,
            configuration:
                RibbonConfiguration(
                    itemSize: .init(width: 50, height: 50),
                    minimumLineSpacing: 5
                )
        ),
        ColorGroup(
            name: "Red-ish Colors",
            colors: randomColors(count: 100, hue: .red, luminosity: .light),
            sectionHeight: 70,
            configuration:
                RibbonConfiguration(
                    itemSize: .init(width: 70, height: 70),
                    minimumLineSpacing: 5
                )
        ),
        ColorGroup(
            name: "Purple-ish Colors",
            colors: randomColors(count: 100, hue: .purple, luminosity: .light),
            sectionHeight: 100,
            configuration:
                RibbonConfiguration(
                    itemSize: .init(width: 100, height: 100),
                    minimumLineSpacing: 5
                )
        ),
        ColorGroup(
            name: "Orange-ish Colors",
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
