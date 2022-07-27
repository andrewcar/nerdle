//
//  Frame.swift
//  Nerdle MessagesExtension
//
//  Created by Andrew Carvajal on 7/26/22.
//

import UIKit

struct Frame {
    
    // general
    static let padding: CGFloat = 5
    
    struct Logo {
        static let size = CGSize(width: 117, height: 30)
        static let bottomPadding: CGFloat = 10
        static let maxY: CGFloat = size.height + (padding * 2)
        
        static func originX(viewFrame: CGRect) -> CGFloat {
            (viewFrame.width / 2) - (size.width / 2)
        }
        static func frame(_ viewFrame: CGRect) -> CGRect {
            CGRect(x: originX(viewFrame: viewFrame), y: padding, width: size.width, height: size.height)
        }
    }
    
    struct Grid {
        static func outerPadding(_ viewFrame: CGRect) -> CGFloat {
            viewFrame.width / 7
        }
        static let bottomPadding: CGFloat = 20
        static func letterSize(_ viewFrame: CGRect) -> CGSize {
            let width = (viewFrame.width - (padding * 4) - (outerPadding(viewFrame) * 2)) / 5
            return CGSize(width: width, height: width)
        }
        static func maxY(_ viewFrame: CGRect) -> CGFloat {
            Frame.Logo.bottomPadding + Frame.Logo.size.height + (padding * 6) + (letterSize(viewFrame).height * 6)
        }
        static func frame(_ viewFrame: CGRect) -> CGRect {
            CGRect(x: 0, y: Frame.Logo.maxY, width: viewFrame.width, height: viewFrame.height)
        }
        static func originX(_ viewFrame: CGRect) -> CGFloat {
            (viewFrame.width / 2) - (letterSize(viewFrame).width / 2)
        }
    }
    
    struct Keyboard {
        static func frame(_ viewFrame: CGRect) -> CGRect {
            CGRect(
                x: 0,
                y: Frame.Grid.maxY(viewFrame) + Frame.Grid.bottomPadding,
                width: viewFrame.width,
                height: Frame.Grid.frame(viewFrame).width)
        }
    }
    
    struct SendButton {
        static func frame(_ viewFrame: CGRect) -> CGRect {
            let size = CGSize(width: 50, height: 50)
            return CGRect(
                x: viewFrame.width - size.width - (padding * 5),
                y: Grid.maxY(viewFrame) + 230,
                width: size.width,
                height: size.height)
        }
    }
}
