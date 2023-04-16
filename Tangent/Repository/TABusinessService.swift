//
//  TABusinessService.swift
//  Tangent
//
//  Created by Vikram Singh on 3/31/23.
//

import Foundation

//TODO: Docstrings
class TABusinessService: NSObject, Debuggable {
    
    let debug = true
    
    static let shared = TABusinessService()
    
    private override init() { }
    
    func fetchTangents(
        requestBody: TATangentRequestBody,
        completion: @escaping (Result<TATangentResponse, Error>) -> Void
    ) {
        printDebug("Fetching tangents.")
        
        if let request = TATangentRequest.createTangentsRequest(requestParams: requestBody) {
            
            TARestAPIService.shared.execute(
                request,
                expecting: TATangentResponse.self,
                completion: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let tangentResponse):
                        printDebug("BUSINESSES: \(tangentResponse.businesses)")
                        completion(.success(tangentResponse))
                    case .failure(let error):
                        printError("(TABusinessService) \(String(describing: error))")
                        completion(.failure(error))
                    }
                }
            )
        }
    }
    
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG: \(message)")
        }
    }
}
