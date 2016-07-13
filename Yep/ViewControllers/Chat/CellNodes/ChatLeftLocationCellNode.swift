//
//  ChatLeftLocationCellNode.swift
//  Yep
//
//  Created by NIX on 16/7/13.
//  Copyright © 2016年 Catch Inc. All rights reserved.
//

import UIKit
import YepKit
import AsyncDisplayKit

class ChatLeftLocationCellNode: ChatLeftBaseCellNode {

    static let mapSize = CGSize(width: 192, height: 108)

    static let nameAttributes = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont.systemFontOfSize(12),
    ]

    var tapMapAction: (() -> Void)?

    lazy var imageNode: ASImageNode = {
        let node = ASImageNode()
        node.contentMode = .ScaleAspectFill

        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatLeftLocationCellNode.tapMap(_:)))
        node.userInteractionEnabled = true
        node.view.addGestureRecognizer(tap)

        return node
    }()

    lazy var locationNameNode: ASTextNode = {
        let node = ASTextNode()
        node.layerBacked = true
        node.maximumNumberOfLines = 1
        return node
    }()

    @objc private func tapMap(sender: UITapGestureRecognizer) {

        tapMapAction?()
    }

    override init() {
        super.init()

        addSubnode(imageNode)
        addSubnode(locationNameNode)
    }

    func configure(withMessage message: Message) {

        self.user = message.fromFriend

        do {
            let locationName = message.textContent

            locationNameNode.attributedText = NSAttributedString(string: locationName, attributes: ChatLeftLocationCellNode.nameAttributes)

            ImageCache.sharedInstance.mapImageOfMessage(message, withSize: ChatLeftLocationCellNode.mapSize, tailDirection: .Left, bottomShadowEnabled: !locationName.isEmpty) { [weak self] mapImage in
                print("mapImage.resizingMode: \(mapImage.resizingMode.rawValue)")
                print("mapImage.capInsets: \(mapImage.capInsets)")
                self?.imageNode.image = mapImage
            }
        }
    }

    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {

        let nameMaxWidth = ChatLeftLocationCellNode.mapSize.width - (10 + 10)
        locationNameNode.measure(CGSize(width: nameMaxWidth, height: CGFloat.max))

        return CGSize(width: constrainedSize.width, height: ChatLeftLocationCellNode.mapSize.height + ChatBaseCellNode.verticalPadding)
    }

    override func layout() {
        super.layout()

        let x = 15 + ChatBaseCellNode.avatarSize.width + 5
        let y = ChatBaseCellNode.topPadding
        let origin = CGPoint(x: x, y: y)
        imageNode.frame = CGRect(origin: origin, size: ChatLeftLocationCellNode.mapSize)

        do {
            let offsetX = (ChatLeftLocationCellNode.mapSize.width - locationNameNode.calculatedSize.width) / 2
            let y = ChatBaseCellNode.topPadding + ChatLeftLocationCellNode.mapSize.height - 20
            let offsetY = (20 - locationNameNode.calculatedSize.height) / 2
            let origin = CGPoint(x: x + offsetX, y: y + offsetY)
            locationNameNode.frame = CGRect(origin: origin, size: locationNameNode.calculatedSize)
        }
    }
}

