
import UIKit
import Photos

class Album {

  let collection: PHAssetCollection
  var items: [Image] = []

  // MARK: - Initialization

  init(collection: PHAssetCollection) {
    self.collection = collection
  }

func reload(fetchLimit: Int = Int.max) {
    items = []
    
    let itemsFetchResult = PHAsset.fetchAssets(in: collection, options: Utils.fetchOptions(limit: fetchLimit))
    itemsFetchResult.enumerateObjects({ (asset, count, stop) in
      if asset.mediaType == .image  || asset.mediaType == .video {
        self.items.append(Image(asset: asset))
      }
    })
  }
}
