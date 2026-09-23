import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias NftsCompletion = (Result<[Nft], Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func loadNfts(ids: [String], completion: @escaping NftsCompletion)
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadNfts(ids: [String], completion: @escaping NftsCompletion) {
        let group = DispatchGroup()
        let syncQueue = DispatchQueue(label: "nftService.loadNfts.sync")
        
        var loadedNfts = Array<Nft?>(repeating: nil, count: ids.count)
        
        var loadingError: Error?
        
        for (index, nftID) in ids.enumerated() {
            group.enter()
            
            loadNft(id: nftID) { result in
                
                syncQueue.async {
                    switch result {
                    case .success(let nft):
                        loadedNfts[index] = nft
                    case .failure(let error):
                        if loadingError == nil {
                            loadingError = error
                        }
                    }
                    
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            if let loadingError {
                completion(.failure(loadingError))
                return
            }
            let nfts = loadedNfts.compactMap { $0 }
            completion(.success(nfts))
        }
    }
}
