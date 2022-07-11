//
//  ViewController.swift
//  URLSessionStartProject
//
//  Created by Alexey Pavlov on 29.11.2021.
//

import UIKit
import CryptoKit

class ViewController: UIViewController {

    private let endpointClient = EndpointClient(applicationSettings: ApplicationSettingsService())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        executeCall()
    }
    
    private func executeCall() {
        let endpoint = GetNameEndpoint()
        let completion: EndpointClient.ObjectEndpointCompletion<Cards> = { result, response in
            guard let responseUnwrapped = response else { return }

            print("\n\n response = \(responseUnwrapped.allHeaderFields) ;\n \(responseUnwrapped.statusCode) \n")
            switch result {
            case .success(let cards):
                cards.cards.forEach {
                    if let name = $0.name { print("Имя карты: \(name)") }
                    if let manaCost = $0.manaCost { print("Затраты на ману: \(manaCost)") }
                    if let type = $0.type { print("Тип: \(type)") }
                    if let rarity = $0.rarity { print("Редкость: \(rarity)") }
                    if let setName = $0.setName { print("Название сета: \(setName)") }
                    if let artist = $0.artist { print("Художник: \(artist)") }
                    if let number = $0.number { print("Номер: \(number)") }
                    print("")
                }
            case .failure(let error):
                print(error)
            }
        }
        endpointClient.executeRequest(endpoint, completion: completion)
    }
}

final class GetNameEndpoint: ObjectResponseEndpoint<Cards> {
    
    override var method: RESTClient.RequestType { return .get }
    
    let publicKey = "be9aca449e446872c174ee5ca783b29a"
    let privateKey = "fa43bba24313ffec6887c39c20979fa965da9ae8"
    let tsValue = "1"
    
    
    override var path: String { "/v1/cards" }
    
    override init() {
        super.init()
        queryItems = [
            URLQueryItem(name: "name", value: "Black Lotus|Opt111")
        ]
    }
}

func decodeJSONOld() {
    let str = """
        {\"team\": [\"ios\", \"android\", \"backend\"]}
    """
    
    let data = Data(str.utf8)
    
    do {
        if let json = try JSONSerialization.jsonObject(
            with: data,
            options: []
        ) as? [String: Any] {
            if let names = json["team"] as? [String] {
                print(names)
            }
        }
    } catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
    }
}

extension String {
    var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
