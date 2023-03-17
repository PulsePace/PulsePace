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

    func createTimelineView(for object: Object, with beatOffset: Double, and zoom: Double) -> TimelineView
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
    let startTime: Double
    let endTime: Double
    let beatOffset: Double
    let zoom: Double

    init(object: TapHitObject, beatOffset: Double, zoom: Double) {
        self.startTime = object.beat
        self.endTime = object.endTime
        self.beatOffset = beatOffset
        self.zoom = zoom
    }

    var body: some View {
        Circle()
            .strokeBorder(.black, lineWidth: 2)
            .background(Circle().fill(.white))
            .frame(width: 40, height: 40)
            .offset(x: (startTime + beatOffset) * zoom)
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
        self.endTime = object.endTime
        self.vertices = object.vertices
        self.cursorTime = cursorTime
    }

    var timeDifference: Double {
        if cursorTime >= startTime && cursorTime <= endTime {
            return 0
        } else {
            let diffFromStart = startTime - cursorTime
            let diffFromEnd = endTime - cursorTime
            return cursorTime < startTime ? diffFromStart : diffFromEnd
        }
    }

    var body: some View {
        ZStack {
            DrawShapeBorder(points: [position] + vertices).stroked()

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

            if let lastVertex = vertices.last {
                Circle()
                    .fill(.white)
                    .frame(width: 100, height: 100)
                    .position(x: lastVertex.x,
                              y: lastVertex.y) // TODO: constants
            }

            ForEach(vertices, id: \.self) { position in
                Circle()
                    .fill(.white)
                    .frame(width: 20, height: 20)
                    .position(x: position.x,
                              y: position.y) // TODO: constants
            }
        }
        .opacity(max(0, 1 - 0.5 * abs(timeDifference)))
    }
}

struct SlideHitObjectTimelineView: HitObjectTimelineView {
    let startTime: Double
    let endTime: Double
    let beatOffset: Double
    let zoom: Double

    init(object: SlideHitObject, beatOffset: Double, zoom: Double) {
        self.startTime = object.beat
        self.endTime = object.endTime
        self.beatOffset = beatOffset
        self.zoom = zoom
    }

    var body: some View {
        Rectangle()
            .strokeBorder(.black, lineWidth: 2)
            .background(.white.opacity(0.5))
            .frame(width: (endTime - startTime) * zoom, height: 40)
            .offset(x: (startTime + beatOffset) * zoom + 20)

        Circle()
            .strokeBorder(.black, lineWidth: 2)
            .background(Circle().fill(.white))
            .frame(width: 40, height: 40)
            .offset(x: (startTime + beatOffset) * zoom)

        Circle()
            .strokeBorder(.black, lineWidth: 2)
            .background(Circle().fill(.white))
            .frame(width: 40, height: 40)
            .offset(x: (endTime + beatOffset) * zoom)
    }
}

struct HoldHitObjectCanvasView: HitObjectCanvasView {
    let position: CGPoint
    let startTime: Double
    let endTime: Double
    let cursorTime: Double

    init(object: HoldHitObject, cursorTime: Double) {
        self.position = object.position
        self.startTime = object.beat
        self.endTime = object.endTime
        self.cursorTime = cursorTime
    }

    var timeDifference: Double {
        if cursorTime >= startTime && cursorTime <= endTime {
            return 0
        } else {
            let diffFromStart = startTime - cursorTime
            let diffFromEnd = endTime - cursorTime
            return cursorTime < startTime ? diffFromStart : diffFromEnd
        }
    }

    var body: some View {
        ZStack {
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

struct HoldHitObjectTimelineView: HitObjectTimelineView {
    let startTime: Double
    let endTime: Double
    let beatOffset: Double
    let zoom: Double

    init(object: HoldHitObject, beatOffset: Double, zoom: Double) {
        self.startTime = object.beat
        self.endTime = object.endTime
        self.beatOffset = beatOffset
        self.zoom = zoom
    }

    var body: some View {
        Rectangle()
            .strokeBorder(.black, lineWidth: 2)
            .background(.white.opacity(0.5))
            .frame(width: (endTime - startTime) * zoom, height: 40)
            .offset(x: (startTime + beatOffset) * zoom + 20)

        Circle()
            .strokeBorder(.black, lineWidth: 2)
            .background(Circle().fill(.white))
            .frame(width: 40, height: 40)
            .offset(x: (startTime + beatOffset) * zoom)

        Circle()
            .strokeBorder(.black, lineWidth: 2)
            .background(Circle().fill(.white))
            .frame(width: 40, height: 40)
            .offset(x: (endTime + beatOffset) * zoom)
    }
}

class TapHitObjectViewFactory: HitObjectViewFactory {
    func createTimelineView(
        for object: TapHitObject,
        with beatOffset: Double,
        and zoom: Double
    ) -> TapHitObjectTimelineView {
        TapHitObjectTimelineView(object: object, beatOffset: beatOffset, zoom: zoom)
    }

    func createCanvasView(for object: TapHitObject, at cursorTime: Double) -> TapHitObjectCanvasView {
        TapHitObjectCanvasView(object: object, cursorTime: cursorTime)
    }
}

class SlideHitObjectViewFactory: HitObjectViewFactory {
    func createTimelineView(
        for object: SlideHitObject,
        with beatOffset: Double,
        and zoom: Double
    ) -> SlideHitObjectTimelineView {
        SlideHitObjectTimelineView(object: object, beatOffset: beatOffset, zoom: zoom)
    }

    func createCanvasView(for object: SlideHitObject, at cursorTime: Double) -> SlideHitObjectCanvasView {
        SlideHitObjectCanvasView(object: object, cursorTime: cursorTime)
    }
}

class HoldHitObjectViewFactory: HitObjectViewFactory {
    func createTimelineView(
        for object: HoldHitObject,
        with beatOffset: Double,
        and zoom: Double
    ) -> HoldHitObjectTimelineView {
        HoldHitObjectTimelineView(object: object, beatOffset: beatOffset, zoom: zoom)
    }

    func createCanvasView(for object: HoldHitObject, at cursorTime: Double) -> HoldHitObjectCanvasView {
        HoldHitObjectCanvasView(object: object, cursorTime: cursorTime)
    }
}

class ViewFactoryCreator {
    func createTimelineView(for object: any HitObject, with beatOffset: Double, and zoom: Double) -> some View {
        if let tapHitObject = object as? TapHitObject {
            return AnyView(TapHitObjectViewFactory()
                .createTimelineView(for: tapHitObject, with: beatOffset, and: zoom)
            )
        } else if let slideHitObject = object as? SlideHitObject {
            return AnyView(SlideHitObjectViewFactory()
                .createTimelineView(for: slideHitObject, with: beatOffset, and: zoom)
            )
        } else if let holdHitObject = object as? HoldHitObject {
            return AnyView(HoldHitObjectViewFactory()
                .createTimelineView(for: holdHitObject, with: beatOffset, and: zoom)
            )
        }
        fatalError("Unknown hit object type")
    }

    func createCanvasView(for object: any HitObject, at cursorTime: Double) -> some View {
        if let tapHitObject = object as? TapHitObject {
            return AnyView(TapHitObjectViewFactory().createCanvasView(for: tapHitObject, at: cursorTime))
        } else if let slideHitObject = object as? SlideHitObject {
            return AnyView(SlideHitObjectViewFactory().createCanvasView(for: slideHitObject, at: cursorTime))
        } else if let holdHitObject = object as? HoldHitObject {
            return AnyView(HoldHitObjectViewFactory().createCanvasView(for: holdHitObject, at: cursorTime))
        }
        fatalError("Unknown hit object type")
    }
}
