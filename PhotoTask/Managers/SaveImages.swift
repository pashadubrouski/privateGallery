import Foundation
import UIKit

final class SaveImages: Codable {
    var image : UIImage?
    var isLiked : Bool?
    var comment : String?
    
    private enum CodingKeys: String, CodingKey { // набор ключей под которыми будут упаковываться проперти
        case image
        case isLiked
        case comment
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws { //обязательная инициализация //процедура сборки объекта из даты
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: .image)
        image = UIImage(data: data)
        isLiked = try container.decode(Bool.self, forKey: .isLiked)
        comment = try container.decode(String.self, forKey: .comment)
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let photo = image {
            guard let data = photo.jpegData(compressionQuality: 1) else {
                return
            }
            try container.encode(data, forKey: CodingKeys.image)
            try container.encode(self.isLiked, forKey: CodingKeys.isLiked)
            try container.encode(self.comment, forKey: CodingKeys.comment)
        }
    }
}
