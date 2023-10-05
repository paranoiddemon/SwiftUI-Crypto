//
//  NetworkingManager.swift
//  Crypto
//
//  Created by forys on 2023-10-03.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        // enum 内部的变量 可以引用enum
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "Bad response from URL: \(url)" // 当switch case满足 会自动绑定
            case .unknown: return "Unknown error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, any Error>{
        
        let configuration = URLSessionConfiguration.default
        let cache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: nil)
        URLCache.shared = cache

        // Assign the cache to the session configuration
        configuration.urlCache = cache

        // Create a URLSession instance with the custom configuration
        let session = URLSession(configuration: configuration)
        
        return session.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap{(output) -> Data in
                try handleURLResponse(output: output, url: url)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher() // 类型转换
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let res = output.response as? HTTPURLResponse, // 转换成类型
              res.statusCode >= 200 && res.statusCode < 300 // guard可以同时判断多个条件，只有全都满足才会继续 https://stackoverflow.com/questions/39198626/multiple-conditions-in-guard-statement-in-swift
        else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
