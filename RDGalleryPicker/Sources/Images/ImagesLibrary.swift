import UIKit
import Photos

class ImagesLibrary {

  var albums: [Album] = []
  var albumsFetchResults = [PHFetchResult<PHAssetCollection>]()

  // MARK: - Initialization

  init() { }

  // MARK: - Logic
func reload(limit: Int = Int.max, _ completion: @escaping () -> Void) {
    DispatchQueue.global().async {
      self.reloadSync(limit: limit)
      DispatchQueue.main.async {
        completion()
      }
    }
  }

  fileprivate func reloadSync(limit: Int = Int.max) {
    let types: [PHAssetCollectionType] = [ .smartAlbum, .album]

    albumsFetchResults = types.map {
      return PHAssetCollection.fetchAssetCollections(with: $0, subtype: .any, options: nil)
    }

    albums = []

    for result in albumsFetchResults {
      result.enumerateObjects({ (collection, _, _) in
        let album = Album(collection: collection)
        album.reload(fetchLimit: limit)

        if !album.items.isEmpty {
          self.albums.append(album)
        }
      })
    }

    // Move Camera Roll first
    if let index = albums.firstIndex(where: { $0.collection.assetCollectionSubtype == . smartAlbumUserLibrary }) {
      albums.g_moveToFirst(index)
    }
  }
}
