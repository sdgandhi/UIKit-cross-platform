//
//  Texture+Size.swift
//  UIKitTests
//
//  Created by Chris on 13.07.17.
//  Copyright © 2017 flowkey. All rights reserved.
//

import SDL_gpu
@testable import UIKit

extension CGImage {
    convenience init?(size: CGSize) {
        var gpuImage = GPU_Image()
        gpuImage.w = UInt16(size.width)
        gpuImage.h = UInt16(size.height)
        self.init(&gpuImage)
    }
}
