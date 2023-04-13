//
//  TARestAPIService.swift
//  Tangent
//
//  Created by Vikram Singh on 3/25/23.
//

import Foundation

/// Used to execute REST API requests
final class TARestAPIService: Debuggable {
    
    let debug = true
    
    /// The singleton instance that is used to access service functionality
    public static let shared = TARestAPIService()
    
    /// Private initializer forces use of shared.
    private init() { }
    
    /// Possible errors that can be encountered
    enum TAServiceError: Error {
        case failedToUnwrapURLRequest
        case failedToUnwrapData
        case failedToUnwrapResponse
        case failedToGetData
        case invalidResponseCode
        case failedToDecodeData
    }
    
    /// Executes requests and receives/decodes response
    /// - Parameters:
    ///   - request: The request that we are sending
    ///   - expecting: The type of object that we are expecting in response
    ///   - completion: The completion handler
    public func execute <T: TAAPIResponse>(
        _ request: TAAPIRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        printDebug("Executing a TAService request: \(String(describing: request.urlRequest))")
        
        // Unwrap the urlRequest property from the TARequest object
        guard let urlRequest = request.urlRequest else {
            completion(.failure(TAServiceError.failedToUnwrapURLRequest))
            print("$Error: url request is nil.")
            return
        }
        
        let task = URLSession.shared.dataTask(
            with: urlRequest,
            completionHandler: { [weak self] data, response, error in
                guard let self = self else {
                    fatalError("$Error: TAService self is nil.")
                }
                
                // There was an error fetching the data.
                if let error = error {
                    print("$Error: \(String(describing: error))")
                    completion(.failure(error))
                }
                
                // The data came back nil
                guard let data = data else {
                    print("$Error: data is nil.")
                    completion(.failure(TAServiceError.failedToUnwrapData))
                    return
                }
                
                // There was an invalid response code.
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("$Error: couldn't read response as HTTPURLResponse.")
                    completion(.failure(TAServiceError.failedToUnwrapResponse))
                    return
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    if let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                        print("Data: \(JSONString)")
                    }
                    
                    print("$Error: invalid response code: \(httpResponse.statusCode).")
                    completion(.failure(TAServiceError.invalidResponseCode))
                    return
                }
                
                // Try to decode the data
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(type, from: data)
                    self.printDebug("successfully decoded data to type \(type). Response Object: \(responseObject)")
                    completion(.success(responseObject))
                } catch let error {
                    if let decodingError = error as? DecodingError {
                        // There was an error decoding the data
                        self.printDebug("$Error decoding response data \(String(describing: decodingError))")
                        completion(.failure(TAServiceError.failedToDecodeData))
                    } else {
                        // There was some other error
                        self.printDebug("$Error: \(String(describing: error))")
                        completion(.failure(error))
                    }
                }
            }
        )
        task.resume()
    }
    
    /// Reads the relevant flags and prints debug messages only if they are enabled
    /// - Parameter message: The message to print
    func printDebug(_ message: String) {
        if Flags.debugAPIClient || self.debug {
            print("$Log (TARestAPIService): \(message)")
        }
    }
}

