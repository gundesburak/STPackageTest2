//
//  RemoteNotification.swift
//  Misli.com
//
//  Created by Selay Turkmen on 29.05.2020.
//  Copyright © 2020 Misli.com. All rights reserved.
//

import Foundation

class Alert: Codable {
    let title: String?
    let subtitle: String?
    let body: String?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try? container.decode(String.self, forKey: .title)
        subtitle = try? container.decode(String.self, forKey: .subtitle)
        body = try? container.decode(String.self, forKey: .body)
    }
}

class APS: Codable {
    let alert: Alert?
    let badge: Int?
    let sound: String?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        alert = try? container.decode(Alert.self, forKey: .alert)
        badge = try? container.decode(Int.self, forKey: .badge)
        sound = try? container.decode(String.self, forKey: .sound)
    }
}

class RemoteNotification: Codable {
    let aps: APS?
    let badge: String?
    let id: String?
    let title: String?
    let message: String?
    let imageUrl: URL?
    let targetUrl: URL?
    let marketing: String?
}
