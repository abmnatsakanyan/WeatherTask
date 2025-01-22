//
//  LargeTapAreaButton.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/20/25.
//

import UIKit

class LargeTapAreaButton: UIButton {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -10, dy: -10).contains(point)
    }
}
