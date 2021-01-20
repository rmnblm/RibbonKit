//  Copyright © 2020 Swisscom. All rights reserved.

import SwiftUI
import RibbonKit

struct Ribbon<Section: Hashable, Item: Hashable>: Hashable {
    let section: Section
    let headerHeight: CGFloat
    let configuration: RibbonConfiguration
    let items: [Item]
}

struct RibbonList<Section: Hashable, Item: Hashable, Cell: View, Header: View>: UIViewRepresentable {

    private class HostCell: UICollectionViewCell {
        private var hostController: UIHostingController<Cell>?

        override func prepareForReuse() {
            if let hostView = hostController?.view {
                hostView.removeFromSuperview()
            }
            hostController = nil
        }

        var hostedCell: Cell? {
            willSet {
                guard let view = newValue else { return }
                hostController = UIHostingController(rootView: view)
                if let hostView = hostController?.view {
                    hostView.frame = contentView.bounds
                    hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    contentView.addSubview(hostView)
                }
            }
        }

        override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
            layer.borderWidth = isFocused ? 3.0 : 0.0
            layer.borderColor = isFocused ? UIColor.red.cgColor : UIColor.clear.cgColor
        }
    }

    private class HostHeaderView: UITableViewHeaderFooterView {
        private var hostController: UIHostingController<Header>?

        override func prepareForReuse() {
            if let hostView = hostController?.view {
                hostView.removeFromSuperview()
            }
            hostController = nil
        }

        var hostedHeaderView: Header? {
            willSet {
                guard let view = newValue else { return }
                hostController = UIHostingController(rootView: view)
                if let hostView = hostController?.view {
                    hostView.frame = self.bounds
                    hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    addSubview(hostView)
                }
            }
        }
    }

    @Binding var ribbons: [Ribbon<Section, Item>]

    let cellBuilder: (IndexPath) -> Cell
    let headerBuilder: (Int) -> Header?

    init(
        ribbons: Binding<[Ribbon<Section, Item>]>,
        @ViewBuilder cellBuilder: @escaping (IndexPath) -> Cell,
        @ViewBuilder headerBuilder: @escaping (Int) -> Header?
    ) {
        self._ribbons = ribbons
        self.cellBuilder = cellBuilder
        self.headerBuilder = headerBuilder
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> RibbonListView {
        let list = RibbonKit.RibbonListView()
        list.delegate = context.coordinator
        list.dataSource = context.coordinator
        list.register(HostCell.self, forCellWithReuseIdentifier: "Cell")
        list.register(HostHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        return list
    }

    func updateUIView(_ uiView: RibbonListView, context: Context) {
        let coordinator = context.coordinator
        let ribbonsHash = ribbons.hashValue
        if coordinator.ribbonsHash != ribbonsHash {
            coordinator.parent = self
            uiView.reloadData()
            coordinator.ribbonsHash = ribbonsHash
        }
    }

    class Coordinator: NSObject, RibbonListViewDelegate, RibbonListViewDataSource {

        fileprivate var ribbonsHash: Int? = nil
        fileprivate var isFocusable: Bool = true
        var parent: RibbonList

        init(_ parent: RibbonList) {
            self.parent = parent
        }
        
        func ribbonList(_ ribbonList: RibbonListView, configurationForSectionAt section: Int) -> RibbonConfiguration? {
            return parent.ribbons[section].configuration
        }

        func ribbonList(_ ribbonList: RibbonListView, heightForHeaderInSection section: Int) -> CGFloat {
            return parent.ribbons[section].headerHeight
        }

        func ribbonList(_ ribbonList: RibbonListView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = ribbonList.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HostCell
            cell.hostedCell = parent.cellBuilder(indexPath)
            return cell
        }

        func ribbonList(_ ribbonList: RibbonListView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = ribbonList.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! HostHeaderView
            headerView.hostedHeaderView = parent.headerBuilder(section)
            return headerView
        }

        func numberOfSections(in ribbonList: RibbonListView) -> Int {
            return parent.ribbons.count
        }

        func ribbonList(_ ribbonList: RibbonListView, numberOfItemsInSection section: Int) -> Int {
            return parent.ribbons[section].items.count
        }
        
        func ribbonList(_ ribbonList: RibbonListView, canFocusItemAt indexPath: IndexPath) -> Bool {
            return isFocusable
        }
        
        func ribbonList(_ ribbonList: RibbonListView, didUpdateFocusIn context: RibbonListViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
            #if os(tvOS)
            if let indexPath = context.previouslyFocusedIndexPath { ribbonList.cellForItem(at: indexPath)?.layer.zPosition = 0 }
            if let indexPath = context.nextFocusedIndexPath { ribbonList.cellForItem(at: indexPath)?.layer.zPosition = 1 }

            guard let nextIndexPath = context.nextFocusedIndexPath else { return }
            if let previousIndexPath = context.previouslyFocusedIndexPath, previousIndexPath.section == nextIndexPath.section { return }

            let headerHeight = ribbonList.delegate?.ribbonList(ribbonList, heightForHeaderInSection: nextIndexPath.section) ?? 0.0
            let sectionHeight = ribbonList.delegate?.ribbonList(ribbonList, heightForSectionAt: nextIndexPath.section) ?? 0.0
            let footerHeight = ribbonList.delegate?.ribbonList(ribbonList, heightForFooterInSection: nextIndexPath.section) ?? 0.0
            
            let yOffset = (headerHeight + sectionHeight + footerHeight) * CGFloat(nextIndexPath.section)
            coordinator.addCoordinatedAnimations({
                ribbonList.setContentOffsetY(yOffset, animated: true)
            }, completion: nil)
            #endif
        }
    }
}
