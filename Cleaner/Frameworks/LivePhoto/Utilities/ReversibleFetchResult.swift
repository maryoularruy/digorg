import Photos

/// Provides access to a photo library fetch result in reversed or original order.
///
/// When `isReversed` is true, index 0 returns the last asset of the original fetch result, 1 the
/// second to last and so on.
struct ReversibleFetchResult {
    
    let isReversed: Bool
    private let underlying: PHFetchResult<PHAsset>
    
    init(fetchResult: PHFetchResult<PHAsset>, isReversed: Bool) {
        self.underlying = fetchResult
        self.isReversed = isReversed
    }
}

extension ReversibleFetchResult {
    
    /// If the index is not valid, returns `nil`.
    func asset(at index: Int) -> PHAsset? {
        guard (0..<count).contains(index) else { return nil }
        
        return isReversed
            ? underlying[count - 1 - index]
            : underlying[index]
    }
    
    func index(of asset: PHAsset) -> Int? {
        let index = underlying.index(of: asset)
        
        guard index != NSNotFound,
              (0..<count).contains(index) else { return nil }
        
        return isReversed
            ? (count - 1 - index)
            : index
    }
    
    func contains(_ asset: PHAsset) -> Bool {
        underlying.contains(asset)
    }
    
    // Make access explicit so we don't accidentally query the original result with wrong indices.
    /// The underlying fetch result in its original order.
    func getFetchResult() -> PHFetchResult<PHAsset> {
        underlying
    }
    
    var count: Int {
        underlying.count
    }
    
    var isEmpty: Bool {
        count == 0
    }
}
