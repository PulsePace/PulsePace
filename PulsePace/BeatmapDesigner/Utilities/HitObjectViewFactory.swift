//
//  HitObjectViewFactory.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/16.
//

import Foundation
import SwiftUI

protocol HitObjectViewFactory {
    associatedtype Object: HitObject
    associatedtype TimelineView: HitObjectTimelineView
    associatedtype CanvasView: HitObjectCanvasView

    func createTimelineView(for object: Object) -> TimelineView
    func createCanvasView(for object: Object, at cursorTime: Double) -> CanvasView
}

protocol HitObjectCanvasView: View {
    var position: CGPoint { get }
    var startTime: Double { get }
    var endTime: Double { get }
}

protocol HitObjectTimelineView: View {
    var startTime: Double { get }
    var endTime: Double { get }
}

struct TapHitObjectCanvasView: HitObjectCanvasView {
    let position: CGPoint
    let startTime: Double
    let endTime: Double
    let cursorTime: Double

    init(object: TapHitObject, cursorTime: Double) {
        self.position = object.position
        self.startTime = object.beat
        self.endTime = object.beat // TODO: fix
        self.cursorTime = cursorTime
    }

    var body: some View {
        let timeDifference = startTime - cursorTime

        return ZStack {
            Circle()
                .strokeBorder(.white, lineWidth: 4)
                .frame(width: min(800, max(100, 100 + 200 * timeDifference)),
                       height: min(800, max(100, 100 + 200 * timeDifference)))
                .position(x: position.x,
                          y: position.y)

            Circle()
                .fill(.white)
                .frame(width: 100, height: 100)
                .position(x: position.x,
                          y: position.y) // TODO: constants

        }
        .opacity(max(0, 1 - 0.5 * abs(timeDifference)))
    }
}

struct TapHitObjectTimelineView: HitObjectTimelineView {
    let startTime: Double = 0
    let endTime: Double = 0

    var body: some View {
        HStack {}
    }
}

struct SlideHitObjectCanvasView: HitObjectCanvasView {
    let position: CGPoint
    let startTime: Double
    let endTime: Double
    let vertices: [CGPoint]
    let cursorTime: Double

    init(object: SlideHitObject, cursorTime: Double) {
        self.position = object.position
        self.startTime = object.beat
        self.endTime = object.beat // TODO: fix
        self.vertices = object.vertices
        self.cursorTime = cursorTime
    }

    var body: some View {
        let timeDifference = startTime - cursorTime

        return ZStack {
            Circle()
                .strokeBorder(.white, lineWidth: 4)
                .frame(width: min(800, max(100, 100 + 200 * timeDifference)),
                       height: min(800, max(100, 100 + 200 * timeDifference)))
                .position(x: position.x,
                          y: position.y)

            Circle()
                .fill(.white)
                .frame(width: 100, height: 100)
                .position(x: position.x,
                          y: position.y) // TODO: constants

            ForEach(0..<vertices.count) { index in
                let position = vertices[index]
                Circle()
                    .fill(.white)
                    .frame(width: 100, height: 100)
                    .position(x: position.x,
                              y: position.y) // TODO: constants
            }

        }
        .opacity(max(0, 1 - 0.5 * abs(timeDifference)))
    }
}

struct SlideHitObjectTimelineView: HitObjectTimelineView {
    let startTime: Double = 0
    let endTime: Double = 0

    var body: some View {
        HStack {}
    }
}

class TapHitObjectViewFactory: HitObjectViewFactory {
    func createTimelineView(for object: TapHitObject) -> TapHitObjectTimelineView {
        TapHitObjectTimelineView()
    }

    func createCanvasView(for object: TapHitObject, at cursorTime: Double) -> TapHitObjectCanvasView {
        TapHitObjectCanvasView(object: object, cursorTime: cursorTime)
    }
}

class SlideHitObjectViewFactory: HitObjectViewFactory {
    func createTimelineView(for object: SlideHitObject) -> SlideHitObjectTimelineView {
        SlideHitObjectTimelineView()
    }

    func createCanvasView(for object: SlideHitObject, at cursorTime: Double) -> SlideHitObjectCanvasView {
        SlideHitObjectCanvasView(object: object, cursorTime: cursorTime)
    }
}

class ViewFactoryCreator {
    func createTimelineView(for object: any HitObject) -> some View {
        if let tapHitObject = object as? TapHitObject {
            return AnyView(TapHitObjectViewFactory().createTimelineView(for: tapHitObject))
        } else if let slideHitObject = object as? SlideHitObject {
            return AnyView(SlideHitObjectViewFactory().createTimelineView(for: slideHitObject))
        }
        fatalError("Unknown hit object type")
    }

    func createCanvasView(for object: any HitObject, at cursorTime: Double) -> some View {
        if let tapHitObject = object as? TapHitObject {
            return TapHitObjectViewFactory().createCanvasView(for: tapHitObject, at: cursorTime)
        }
        fatalError("Unknown hit object type")
    }
}
