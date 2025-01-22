//
//  UIImageView+loadURL.swift
//  WeatherTask
//
//  Created by Albert Mnatsakanyan on 1/21/25.
//

import UIKit

extension UIImageView {
    func load(url: URL?) {
        guard let url else {
            self.image = UIImage(systemName: "photo.artframe")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
