//
//  Texture.swift
//  UIKit
//
//  Created by Chris on 19.06.17.
//  Copyright © 2017 flowkey. All rights reserved.
//

import SDL
import SDL_gpu
import Foundation

public class CGImage {
    let rawPointer: UnsafeMutablePointer<GPU_Image>

    public let width: Int
    public let height: Int

    /**
     Initialize a `CGImage` by passing a reference to a `GPU_Image`, which is usually the result of SDL_gpu's `GPU_*Image*` creation functions. May be null.
     */
    internal init?(_ pointer: UnsafeMutablePointer<GPU_Image>?) {
        guard let pointer = pointer else {
            // We check for GPU errors on render, so clear any error that may have caused GPU_Image to be nil.
            // It's possible there are unrelated errors on the stack at this point, but we immediately catch and
            // handle any errors that interest us *when they occur*, so it's fine to clear unrelated ones here.
            UIApplication.shared?.glRenderer.clearErrors()
            return nil
        }

        rawPointer = pointer

        GPU_SetSnapMode(rawPointer, GPU_SNAP_POSITION_AND_DIMENSIONS)
        GPU_SetBlendMode(rawPointer, GPU_BLEND_NORMAL_FACTOR_ALPHA)
        GPU_SetImageFilter(rawPointer, GPU_FILTER_LINEAR)

        width = Int(rawPointer.pointee.w)
        height = Int(rawPointer.pointee.h)
    }

    convenience init?(surface: UnsafeMutablePointer<SDLSurface>) {
        self.init(GPU_CopyImageFromSurface(surface))
    }

    func replacePixels(with bytes: UnsafePointer<UInt8>, bytesPerPixel: Int) {
        var rect = GPU_Rect(x: 0, y: 0, w: Float(rawPointer.pointee.w), h: Float(rawPointer.pointee.h))
        GPU_UpdateImageBytes(rawPointer, &rect, bytes, Int32(rawPointer.pointee.w) * Int32(bytesPerPixel))
    }

    deinit {
        GPU_FreeImage(rawPointer)
    }
}
