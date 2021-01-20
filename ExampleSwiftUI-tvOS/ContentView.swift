//  Copyright © 2020 Swisscom. All rights reserved.

import SwiftUI
import RibbonKit

struct BannerSection: Hashable {
    let header: String
    let items: [BannerItem]
}

extension BannerSection {
    static func dummy() -> BannerSection {
        .init(header: Lorem.words(2...3), items: (0..<Int.random(in: 5...20)).map { _ in .dummy() })
    }
}

struct BannerItem: Hashable {
    let title: String
}

extension BannerItem {
    static func dummy() -> BannerItem {
        .init(title: Lorem.words(2...5))
    }
}

extension Ribbon where Section == String, Item == BannerItem {
    static func dummy() -> Ribbon<Section, Item> {
        .init(section: Lorem.words(2...3), headerHeight: 50, configuration: .default, items: (0..<Int.random(in: 5...20)).map { _ in .dummy() })
    }
}

struct ContentView: View {

    static let configuration: RibbonConfiguration = .default

    @State var ribbons: [Ribbon<String, BannerItem>] = (0..<20).map { _ in .dummy() }

    var body: some View {
        VStack {
            HStack {
                Button(action: {}, label: {
                    Text("Button")
                })
                Spacer()
            }
            RibbonList(
                ribbons: $ribbons,
                cellBuilder: { indexPath in
                    Button(action: {}, label: {
                        Text("Button \(indexPath)")
                    })
                },
                headerBuilder: { section in
                    HStack {
                        Text("\(ribbons[section].section)")
                            .bold()
                        Spacer()
                    }
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
