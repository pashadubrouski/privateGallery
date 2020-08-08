import Foundation
import UIKit



final class DataManager{
    
    static let shared = DataManager()
    init () {}
    
    let defaults = UserDefaults.standard
    
    var password: String = " "

    var imagesArray: [SaveImages] = UserDefaults.standard.value([SaveImages].self, forKey: "photos") ?? []
    var likedArray: [SaveImages] = UserDefaults.standard.value([SaveImages].self, forKey: "likedPhotos") ?? []
    let passwordKey = "password"
    
    func createPassword(password: String){
        defaults.set(password, forKey: passwordKey)
    }
    
    func returnPassword()->String? {
        guard let password = defaults.string(forKey: "password") else {
            return nil
        }
        return password
    }
}

extension UserDefaults {
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}
 



