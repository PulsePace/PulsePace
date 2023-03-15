//
//  BeatmapDesignerView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/03/11.
//

import SwiftUI
import AVKit

struct BeatmapDesignerView: View {
    @StateObject var viewModel: BeatmapDesignerViewModel

    init(viewModel: BeatmapDesignerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            VStack {
                Slider(value: $viewModel.offset, in: 0...10)
                Slider(value: $viewModel.zoom, in: 0...1_000)
                Slider(value: $viewModel.divisorIndex, in: 0...Double(viewModel.divisorList.count - 1), step: 1)
                if let player = viewModel.audioManager.player {
                    renderSlider(player: player)
                    renderPlaybackButtons(player: player)
                }
            }
            .zIndex(.infinity)

            ZStack {
                ForEach(viewModel.hitObjects.toArray(), id: \.id) { hitObject in
                    renderHitObject(hitObject)
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .background(.black)
            .onTapGesture { position in
                let interval = 1 / (viewModel.bps * viewModel.divisor)
                let beat = ((viewModel.sliderValue - viewModel.offset) / interval).rounded()
                viewModel.hitObjects.enqueue(TapHitObject(position: position, beat: beat * interval))
            }
        }
        .onAppear {
            viewModel.audioManager.startPlayer(track: "test")
        }
        .onDisappear {
            viewModel.audioManager.stopPlayer()
        }
    }

    func renderSlider(player: AVAudioPlayer) -> some View {
        ZStack {
            GeometryReader { geometry in
                let numberOfBeats: CGFloat = player.duration * viewModel.bps
                let height = geometry.size.height
                let mainBeatSpacing = viewModel.zoom / viewModel.bps
                let subBeatSpacing = mainBeatSpacing / viewModel.divisor

                Path { path in
                    for index in 0...Int(numberOfBeats * viewModel.divisor) {
                        let vOffset = viewModel.zoom * viewModel.offset + CGFloat(index) * subBeatSpacing
                        path.move(to: CGPoint(x: vOffset, y: 0))
                        path.addLine(to: CGPoint(x: vOffset, y: height))
                    }
                }
                .stroke(.blue)

                Path { path in
                    for index in 0...Int(numberOfBeats) {
                        let mainBeatOffset = viewModel.zoom * viewModel.offset + CGFloat(index) * mainBeatSpacing

                        path.move(to: CGPoint(x: mainBeatOffset, y: 0))
                        path.addLine(to: CGPoint(x: mainBeatOffset, y: height))
                    }
                }
                .stroke(.white)

                ForEach(viewModel.hitObjects, id: \.id) { hitObject in
                    Circle()
                        .fill(.white)
                        .offset(x: (viewModel.offset + hitObject.beat) * viewModel.zoom - 20)
                }
            }
            .background(.red)
            .frame(width: viewModel.zoom * player.duration, height: 40)
            .offset(x: viewModel.zoom * (player.duration / 2 - viewModel.sliderValue))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        viewModel.sliderValue = player.currentTime - gesture.translation.width / viewModel.zoom
                        viewModel.isEditing = true
                        player.pause()
                    }
                    .onEnded { _ in
                        player.currentTime = viewModel.sliderValue
                        viewModel.isEditing = false
                        player.play()
                    }
            )
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: 5, height: 60)
        }
        .padding()
    }

    func renderPlaybackButtons(player: AVAudioPlayer) -> some View {
        HStack {
            PlaybackControlButtonView(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill",
                                      fontSize: 44) {
                viewModel.audioManager.togglePlayer()
            }

            PlaybackControlButtonView(systemName: "plus.circle.fill") {
                viewModel.audioManager.increasePlaybackRate()
            }

            PlaybackControlButtonView(systemName: "minus.circle.fill") {
                viewModel.audioManager.decreasePlaybackRate()
            }
        }
    }

    func renderHitObject(_ hitObject: any HitObject) -> some View {
        let absoluteTime = hitObject.beat - viewModel.sliderValue + viewModel.offset
        return ZStack {
            Circle()
                .strokeBorder(.white, lineWidth: 4)
                .frame(width: min(800, max(100, 100 + 200 * absoluteTime)),
                       height: min(800, max(100, 100 + 200 * absoluteTime)))
                .position(x: hitObject.position.x,
                          y: hitObject.position.y)

            Circle()
                .fill(.white)
                .frame(width: 100, height: 100)
                .position(x: hitObject.position.x,
                          y: hitObject.position.y) // TODO: constants

        }
        .opacity(max(0, 1 - 0.5 * abs(absoluteTime)))
    }
}

struct BeatmapDesignerView_Previews: PreviewProvider {
    static var previews: some View {
        BeatmapDesignerView(viewModel: BeatmapDesignerViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
