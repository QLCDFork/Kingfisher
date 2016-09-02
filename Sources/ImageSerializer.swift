//
//  ImageSerializer.swift
//  Kingfisher
//
//  Created by Wei Wang on 2016/09/02.
//
//  Copyright (c) 2016 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

/// An `CacheSerializer` would be used to convert some data to an image object for 
/// retrieving from disk cache or vice versa for storing to disk cache.
public protocol CacheSerializer {
    func data(with image: Image, original: Data?) -> Data?
    func image(with data: Data, options: KingfisherOptionsInfo?) -> Image?
}

public struct DefaultCacheSerializer: CacheSerializer {
    
    public static let `default` = DefaultCacheSerializer()
    private init() {}
    
    public func data(with image: Image, original: Data?) -> Data? {
        let imageFormat = original?.kf_imageFormat ?? .unknown
        
        let data: Data?
        switch imageFormat {
        case .PNG: data = image.pngRepresentation()
        case .JPEG: data = image.jpegRepresentation(compressionQuality: 1.0)
        case .GIF: data = image.gifRepresentation()
        case .unknown: data = original ?? image.kf_normalized().pngRepresentation()
        }
        
        return data
    }
    
    public func image(with data: Data, options: KingfisherOptionsInfo?) -> Image? {
        let scale = (options ?? KingfisherEmptyOptionsInfo).scaleFactor
        let preloadAllGIFData = (options ?? KingfisherEmptyOptionsInfo).preloadAllGIFData
        
        return Image.kf_image(data: data, scale: scale, preloadAllGIFData: preloadAllGIFData)
    }
}