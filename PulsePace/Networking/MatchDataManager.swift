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

    var firstMessageHandler: (any MessageHandler)?

    init(publisher: any DatabaseAdapter<MatchEventMessage>,
         subscriber: any DatabaseListenerAdapter<MatchEventMessage>,
         matchId: String, matchEventTypes: [any MatchEvent.Type]) {
        self.publisher = publisher
        self.subscriber = subscriber
        self.matchId = matchId
        self.matchPath = DatabasePath.getPath(fromPaths: [DatabasePath.matches, matchId, DatabasePath.events])
        setupMatchEventsConfig(matchEventTypes)
    }

    func publishEvent(matchEvent: MatchEventMessage) {
        publisher.saveData(in: matchPath, data: matchEvent) { _ in }
    }

    func subscribeEvents(eventManager: EventManager) {
        let eventUpdateHandler: (Result<MatchEventMessage, Error>) -> Void = { [weak self] result in
            switch result {
            case .success(let matchEventMessage):
                self?.firstMessageHandler?
                    .addMessageToEventQueue(eventManager: eventManager, message: matchEventMessage)
            case .failure(let error):
                print(error)
                return
            }
        }
        subscriber.setupAddChildListener(in: matchPath, completion: eventUpdateHandler)
    }

    private func setupMatchEventsConfig(_ matchEventTypes: [any MatchEvent.Type]) {
        deleteAllMatchEvents()
        setupMessageHandlers(matchEventTypes)
    }

    private func deleteAllMatchEvents() {
        publisher.deleteData(at: matchPath) { _ in }
    }

    private func setupMessageHandlers(_ matchEventTypes: [any MatchEvent.Type]) {
        let handlers = matchEventTypes.map { matchEventType in matchEventType.getType.createHandler() }

        let firstHandler = MatchMessageDecoder()
        _ = handlers.reduce(firstHandler as any MessageHandler, { chainedHandler, nextHandler in
            chainedHandler.setNext(handler: nextHandler)
        })

        firstMessageHandler = firstHandler
    }
}
