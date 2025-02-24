//
//  UIImage+SwiftyGif.swift
//

#if !os(macOS)

import ImageIO
import UIKit

public typealias GifLevelOfIntegrity = Float

extension GifLevelOfIntegrity {
    public static let highestNoFrameSkipping: GifLevelOfIntegrity = 1
    public static let `default`: GifLevelOfIntegrity = 0.8
    public static let lowForManyGifs: GifLevelOfIntegrity = 0.5
    public static let lowForTooManyGifs: GifLevelOfIntegrity = 0.2
    public static let superLowForSlideShow: GifLevelOfIntegrity = 0.1
}

// MARK: - Inits

public extension UIImage {
    func clear() {
        imageData = nil
        imageSource = nil
        displayOrder = nil
        imageCount = nil
        imageSize = nil
        displayRefreshFactor = nil
    }
    
    // MARK: Logic
    
    private func convertToDelay(_ pointer:UnsafeRawPointer?) -> Float? {
        if pointer == nil {
            return nil
        }
        
        return unsafeBitCast(pointer, to:AnyObject.self).floatValue
    }
    
    /// Compute backing data for this gif
    ///
    /// - Parameter delaysArray: decoded delay times for this gif
    /// - Parameter levelOfIntegrity: 0 to 1, 1 meaning no frame skipping
    private func calculateFrameDelay(_ delaysArray: [Float], levelOfIntegrity: GifLevelOfIntegrity) {
        let levelOfIntegrity = max(0, min(1, levelOfIntegrity))
        var delays = delaysArray

        var displayRefreshFactors = [Int]()

        displayRefreshFactors.append(contentsOf: [60, 30, 20, 15, 12, 10, 6, 5, 4, 3, 2, 1])
        
        // maxFramePerSecond,default is 60
        let maxFramePerSecond = displayRefreshFactors[0]

        // frame numbers per second
        var displayRefreshRates = displayRefreshFactors.map { maxFramePerSecond / $0 }

        if #available(iOS 10.3, *) {
            // Will be 120 on devices with ProMotion display, 60 otherwise.
            let maximumFramesPerSecond = UIScreen.main.maximumFramesPerSecond
            if maximumFramesPerSecond == 120 {
                displayRefreshRates.append(maximumFramesPerSecond)
                displayRefreshFactors.insert(maximumFramesPerSecond, at: 0)
            }
        }

        // time interval per frame
        let displayRefreshDelayTime = displayRefreshRates.map { 1 / Float($0) }
        
        // calculate the time when each frame should be displayed at(start at 0)
        for i in delays.indices.dropFirst() {
            delays[i] += delays[i - 1]
        }
        
        //find the appropriate Factors then BREAK
        for (i, delayTime) in displayRefreshDelayTime.enumerated() {
            let displayPosition = delays.map { Int($0 / delayTime) }
           
            var frameLoseCount: Float = 0
            
            for j in displayPosition.indices.dropFirst() where displayPosition[j] == displayPosition[j - 1] {
                frameLoseCount += 1
            }
            
            if displayPosition.first == 0 {
                frameLoseCount += 1
            }
            
            if frameLoseCount <= Float(displayPosition.count) * (1 - levelOfIntegrity) || i == displayRefreshDelayTime.count - 1 {
                imageCount = displayPosition.last
                displayRefreshFactor = displayRefreshFactors[i]
                displayOrder = []
                var oldIndex = 0
                var newIndex = 1
                let imageCount = self.imageCount ?? 0
                
                while newIndex <= imageCount && oldIndex < displayPosition.count {
                    if newIndex <= displayPosition[oldIndex] {
                        displayOrder?.append(oldIndex)
                        newIndex += 1
                    } else {
                        oldIndex += 1
                    }
                }
                break
            }
        }
    }
    
    /// Compute frame size for this gif
    private func calculateFrameSize(){
        guard let imageSource = imageSource,
            let imageCount = imageCount,
            let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
                return
        }
        
        let image = UIImage(cgImage: cgImage)
        imageSize = Int(image.size.height * image.size.width * 4) * imageCount / 1_000_000
    }
}

// MARK: - Properties

private let _imageSourceKey = malloc(4)
private let _displayRefreshFactorKey = malloc(4)
private let _imageSizeKey = malloc(4)
private let _imageCountKey = malloc(4)
private let _displayOrderKey = malloc(4)
private let _imageDataKey = malloc(4)

public extension UIImage {
    
    var imageSource: CGImageSource? {
        get {
            let result = objc_getAssociatedObject(self, _imageSourceKey!)
            return result == nil ? nil : (result as! CGImageSource)
        }
        set {
            objc_setAssociatedObject(self, _imageSourceKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var displayRefreshFactor: Int?{
        get { return objc_getAssociatedObject(self, _displayRefreshFactorKey!) as? Int }
        set { objc_setAssociatedObject(self, _displayRefreshFactorKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var imageSize: Int?{
        get { return objc_getAssociatedObject(self, _imageSizeKey!) as? Int }
        set { objc_setAssociatedObject(self, _imageSizeKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var imageCount: Int?{
        get { return objc_getAssociatedObject(self, _imageCountKey!) as? Int }
        set { objc_setAssociatedObject(self, _imageCountKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var displayOrder: [Int]?{
        get { return objc_getAssociatedObject(self, _displayOrderKey!) as? [Int] }
        set { objc_setAssociatedObject(self, _displayOrderKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var imageData:Data? {
        get {
            let result = objc_getAssociatedObject(self, _imageDataKey!)
            return result == nil ? nil : (result as? Data)
        }
        set {
            objc_setAssociatedObject(self, _imageDataKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension String {
    fileprivate func pathExtension() -> String {
        return (self as NSString).pathExtension
    }
}

#endif
