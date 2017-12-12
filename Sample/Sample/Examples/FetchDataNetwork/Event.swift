//
//  Event.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/13/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import Foundation

class Event {
    let repo: String
    let name: String
    let imageUrl: URL
    let action: String

    init?(dictionary: JObject) {
        guard let repoDict = dictionary["repo"] as? JObject,
            let actor = dictionary["actor"] as? JObject,
            let repoName = repoDict["name"] as? String,
            let actorName = actor["display_login"] as? String,
            let actorUrlString = actor["avatar_url"] as? String,
            let actorUrl = URL(string: actorUrlString),
            let actionType = dictionary["type"] as? String
            else {
                return nil
        }

        repo = repoName
        name = actorName
        imageUrl = actorUrl
        action = actionType
    }
}
