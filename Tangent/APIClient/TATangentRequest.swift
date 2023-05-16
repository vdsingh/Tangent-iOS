//
//  TATangentRequest.swift
//  Tangent
//
//  Created by Vikram Singh on 3/31/23.
//

import Foundation

/// Used to create requests to TA endpoints
final class TATangentRequest: NSObject, TAAPIRequest {

    /// API Constants
    private struct Constants {
        static let baseUrl = "http://localhost:3000"
    }

    /// Desired Endpoint
    private let endpoint: TAEndpoint

    /// Body for the request
    private let requestBody: TARequestBody?

    /// Path Components for API if any
    private let pathComponents: [String]

    /// Query Parameters for API if any
    private let queryParameters: [URLQueryItem]

    /// Constructed url for the API request in string format
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        if !pathComponents.isEmpty {
            for component in pathComponents {
                string += "/\(component)"
            }
        }

        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")

            string += argumentString
        }

        return string
    }

    /// Encodes the requestBody into data to be used in a request.
    private var requestBodyData: Data? {
        if let requestBody = self.requestBody {
            // Encode the object as JSON data
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(requestBody) else {
                printError("encoding object as JSON data")
                return nil
            }

            if let string = String(data: data, encoding: String.Encoding.utf8) {
                printDebug("Request Body DATA: \(string)")
            } else {
                printError("Unable to convert request body data to string.")
            }
            return data
        }

        printDebug("requestBody is nil.")
        return nil
    }
    
    /// Turns the properties of an encodable object into an array of URLQueryItems
    /// - Parameter object: The encodable object
    /// - Returns: An array of URLQueryItems from the properties of the encodable object
    static func queryItems<T: Encodable>(from object: T) -> [URLQueryItem]? {
        guard let encodedData = try? JSONEncoder().encode(object),
            let jsonObject = try? JSONSerialization.jsonObject(with: encodedData, options: []),
            let dictionary = jsonObject as? [String: Any] else {
                return nil
        }
        
        let queryItems = dictionary.compactMap { key, value -> URLQueryItem? in
            guard let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return nil
            }
            return URLQueryItem(name: key, value: encodedValue)
        }
        
        return queryItems
    }

    /// Reads the relevant flags and prints debug messages only if they are enabled
    /// - Parameter message: The message to print
    private func printDebug(_ message: String) {
        if Flags.debugAPIClient {
            print("$LOG: \(message)")
        }
    }

    // MARK: - Public

    /// Desired HTTP Method
    public let httpMethod: HTTPMethod

    /// Computed and constructed URL Request
    public var urlRequest: URLRequest? {
        let url = URL(string: urlString)
        guard let unwrappedURL = url else {
            fatalError("$ERR unwrapping URL.")
        }

        var urlRequest = URLRequest(url: unwrappedURL)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.httpBody = requestBodyData

        return urlRequest
    }

    /// Constructor for request
    /// - Parameters:
    ///   - endpoint: target endpoint
    ///   - pathComponents: Collection of path components
    ///   - queryParameters: Collection of query parameteres
    public init(
        endpoint: TAEndpoint,
        requestBody: TARequestBody?,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.requestBody = requestBody
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
        self.httpMethod = endpoint.httpMethod
        
    }
}

/// Static functions to construct commonly used TATangentRequest objects live here
extension TATangentRequest {
    
    /// Creates a Tangents Request object from a TATangentRequestParameters object
    /// - Parameter requestParams: The TATangentRequestParameters which contains the information for the request
    /// - Returns: A TATangentRequest that can be used to request tangents
    static func createTangentsRequest(requestParams: TATangentRequestParameters) -> TATangentRequest? {
        
        guard let queryItems = TATangentRequest.queryItems(from: requestParams) else {
            print("$ERR (TATangentRequest): Error converting the TATangentRequestBody to an array of Query Items.")
            return nil
        }
        
        let request = TATangentRequest(
            endpoint: .tangents,
            requestBody: nil,
            queryParameters: queryItems
        )
        
        return request
    }
}
