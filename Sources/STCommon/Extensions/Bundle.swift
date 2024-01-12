//
//  Bundle.swift
//  Misli.com
//
//  Created by Selay Turkmen on 29.04.2020.
//  Copyright © 2020 Misli.com. All rights reserved.
//

import Foundation

public extension Bundle {

    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }

        fatalError("Could not load view with type " + String(describing: type))
    }
    
    enum Environment {
        case DEV, STAGE, PROD
    }
    
    static var environment: Environment {
        guard let configFileUrl = self.main.object(forInfoDictionaryKey: "EnvironmentConfigUrl") as? String else {
            return .DEV
        }
        switch configFileUrl {
        case "DevLink": return .DEV
        case "Config_stage": return .STAGE
        case "Config_prod": return .PROD
        default: return .DEV
        }
    }
}
