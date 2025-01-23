//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Subash Parajuli on 03/12/2024.
//

import Foundation
import SwiftUI

public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    /* the RemoteFeedLoader domain-specific error type is a lower-level implementation detail of the FeedAPI Module
     
     thus, we don't want to expose it in the highrt-level Feed Feature Module
     
     
     */
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult<Error>
    
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void ) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
                
            }
        }
        
    }
    

    
}
    
