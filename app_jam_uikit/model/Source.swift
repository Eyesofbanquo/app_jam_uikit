//
//  Source.swift
//  app_jam_uikit
//
//  Created by Markim Shaw on 2/19/21.
//

import CoreData
import Foundation

class Source: NSManagedObject, Decodable {
  
  enum CodingKeys: String, CodingKey {
    case imageId = "image_id"
    case thumbUrl = "thumb_url"
    case url, type
    case createdAt = "created_at"
  }
  
  required convenience init(from decoder: Decoder) throws {
    
    guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
      fatalError()
    }
    
    self.init(context: context)
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.imageId = try container.decode(String.self, forKey: .imageId)
    self.thumbUrl = try container.decode(String.self, forKey: .thumbUrl)
    self.url = try container.decode(String.self, forKey: .url)
    self.type = try container.decode(String.self, forKey: .type)
    self.createdAt = try container.decode(String.self, forKey: .createdAt)
  }
}
