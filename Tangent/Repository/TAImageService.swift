//
//  TAImageService.swift
//  Tangent
//
//  Created by Vikram Singh on 5/16/23.
//

import Foundation
import UIKit

final class TAImageService {
    
    static let shared = TAImageService()
    
    private init() { }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
