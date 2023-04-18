//
//  TABusinessService.swift
//  Tangent
//
//  Created by Vikram Singh on 3/31/23.
//

import Foundation

protocol TangentsUpdateListener {
    func tangentsWereUpdated(businesses: [TABusiness])
}

//TODO: Docstrings
class TABusinessService: NSObject, Debuggable {
    
    let debug = true
    
    static let shared = TABusinessService()
    
    private var tangentsWereUpdatedListeners = [TangentsUpdateListener]()
    
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
    
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG: \(message)")
        }
    }
    
    func appendListener(_ listener: TangentsUpdateListener) {
        self.tangentsWereUpdatedListeners.append(listener)
    }
}
