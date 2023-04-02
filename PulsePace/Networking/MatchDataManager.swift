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
    var firstMessageHandler: MessageHandler?

    init(publisher: any DatabaseAdapter<MatchEventMessage>,
         subscriber: any DatabaseListenerAdapter<MatchEventMessage>,
         matchId: String) {
        self.publisher = publisher
        self.subscriber = subscriber
        self.matchId = matchId
        self.matchPath = DatabasePath.getPath(fromPaths: [DatabasePath.matches, matchId, DatabasePath.events])
        setupMatchEventsConfig()
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

    private func setupMatchEventsConfig() {
        deleteAllMatchEvents()
        setupMessageHandlers()
    }

    private func deleteAllMatchEvents() {
        publisher.deleteData(at: matchPath) { _ in }
    }

    private func setupMessageHandlers() {
        let baseMessageHandler = MatchMessageDecoder()
        let sampleMessageHandler = SampleMessageDecoder()
        let missTapMessageHandler = MissTapMessageDecoder()
        let missSlideMessageHandler = MissSlideMessageDecoder()
        let missHoldMessageHandler = MissHoldMessageDecoder()
        let bombDisruptorMessageHandler = BombDisruptorMessageDecoder()

        _ = baseMessageHandler
            .setNext(handler: sampleMessageHandler)
            .setNext(handler: bombDisruptorMessageHandler)
            .setNext(handler: missTapMessageHandler)
            .setNext(handler: missSlideMessageHandler)
            .setNext(handler: missHoldMessageHandler)

        firstMessageHandler = baseMessageHandler
    }
}
