//
//  MatchDataManager.swift
//  PulsePace
//
//  Created by Charisma Kausar on 31/3/23.
//

class MatchDataManager {
    let publisher: any DatabaseAdapter<MatchEventMessage>
    let subscriber: any DatabaseListenerAdapter<MatchEventMessage>
    let matchId: String
    let matchPath: String

    init(publisher: any DatabaseAdapter<MatchEventMessage>,
         subscriber: any DatabaseListenerAdapter<MatchEventMessage>,
         matchId: String) {
        self.publisher = publisher
        self.subscriber = subscriber
        self.matchId = matchId
        self.matchPath = DatabasePath.getPath(fromPaths: [DatabasePath.matches, matchId, DatabasePath.events])
        deleteAllEvents()
    }

    func publishEvent(matchEvent: MatchEventMessage) {
        publisher.saveData(in: matchPath, data: matchEvent) { _ in }
    }

    func subscribeEvents(eventManager: EventManager) {
        let eventUpdateHandler: (Result<MatchEventMessage, Error>) -> Void = { result in
            switch result {
            case .success(let matchEventMessage):
                MatchEventDecoder().addToEventQueue(eventManager: eventManager, message: matchEventMessage)
            case .failure(let error):
                print(error)
                return
            }
        }
        subscriber.setupAddChildListener(in: matchPath, completion: eventUpdateHandler)
    }

    func deleteAllEvents() {
        publisher.deleteData(at: matchPath) { _ in }
    }
}
