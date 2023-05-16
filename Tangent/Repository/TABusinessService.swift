//
//  TABusinessService.swift
//  Tangent
//
//  Created by Vikram Singh on 3/31/23.
//

import Foundation

/// Protocol for components that want to listen for Tangents Updates
protocol TangentsUpdateListener {
    
    /// Handler for when Tangents are updated
    /// - Parameter businesses: The updated businesses
    func tangentsWereUpdated(businesses: [TABusiness])
}

/// Interface to interact with Tangent Business related objects
class TABusinessService: NSObject, Debuggable {
    
    let debug = true
    
    static let shared = TABusinessService()
    
    /// All of the listeners that are listening for udpates
    private var tangentsWereUpdatedListeners = [TangentsUpdateListener]()
    
    private override init() { }
    
    /// Fetch updated Tangents
    /// - Parameters:
    ///   - requestBody: The Request details
    ///   - completion: What to do after receiving a response
    func fetchTangents(
        requestBody: TATangentRequestParameters,
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
                        for listener in self.tangentsWereUpdatedListeners {
                            
                            //TODO: remove once duplicates issue has been fixed
                            var addedIDs = Set<String>()
                            var businesses = [TABusiness]()
                            
                            for business in tangentResponse.businesses {
                                if(addedIDs.contains(business.id)) {
                                    continue
                                }
                                addedIDs.insert(business.id)
                                businesses.append(business)
                            }
                            
                            listener.tangentsWereUpdated(businesses: businesses)
                        }
                    case .failure(let error):
                        printError("(TABusinessService) \(String(describing: error))")
                        completion(.failure(error))
                    }
                }
            )
        }
    }
    
    /// Adds an updates listener
    /// - Parameter listener: The listener
    func appendListener(_ listener: TangentsUpdateListener) {
        self.tangentsWereUpdatedListeners.append(listener)
    }
}

extension TABusinessService {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG: \(message)")
        }
    }
}
