//
//  EventService.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/13/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class EventService {
    let events = Variable<[Event]>([])
    var disposeBag = DisposeBag()

    func getEvents() {
        guard let url = URL(string: "https://api.github.com/repos/ReactiveX/RxSwift/events") else {
            return
        }

        RxApi.requestGet(url: url)
            .filter { objects in
                return !objects.isEmpty // filter out any responses that do not contain any event objects
            }
            .map { objects in
                return objects.flatMap(Event.init) // parse [JObject] to [Event] and returns an array of Event objects (non-optional)
            }
            .subscribe(onNext: { [weak self](events) in
                guard let this = self else { return }
                this.processEvents(events) // save and update objects (Event object) recevied
            })
            .addDisposableTo(disposeBag)
    }

    func processEvents(_ newEvents: [Event]) {
        // grab the last 50 events from the repository’s event list
        var updatedEvents = newEvents + events.value
        if updatedEvents.count > 50 {
            updatedEvents = [Event](updatedEvents.prefix(upTo: 50))
        }

        events.value = updatedEvents
    }
}
