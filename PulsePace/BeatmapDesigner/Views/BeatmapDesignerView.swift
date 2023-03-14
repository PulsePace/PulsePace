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
            Slider(value: $viewModel.offset, in: 0...10)
            if let player = viewModel.audioManager.player {
                renderSlider(player: player)
                renderPlaybackButtons(player: player)
            }

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
                let interval = 60 / viewModel.bpm
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
                let cols: CGFloat = 400
                let height = geometry.size.height
                let xSpacing = 512 * 60 / viewModel.bpm

                Path { path in
                    for index in 0...Int(cols) {
                        let vOffset = 128 * viewModel.offset + CGFloat(index) * xSpacing / 4
                        path.move(to: CGPoint(x: vOffset, y: 0))
                        path.addLine(to: CGPoint(x: vOffset, y: height))
                    }
                }
                .stroke(.blue)

                Path { path in
                    for index in 0...Int(cols) {
                        let vOffset = 128 * viewModel.offset + CGFloat(index) * xSpacing
                        path.move(to: CGPoint(x: vOffset, y: 0))
                        path.addLine(to: CGPoint(x: vOffset, y: height))
                    }
                }
                .stroke(.white)

                ForEach(viewModel.hitObjects, id: \.id) { hitObject in
                    Circle()
                        .fill(.white)
                        .offset(x: 128 * viewModel.offset + hitObject.beat * 64 * 2 - 20)
                }
            }
            .background(.red)
            .frame(width: 64 * 2 * player.duration, height: 40)
            .offset(x: 64 * (player.duration - 2 * viewModel.sliderValue))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        viewModel.sliderValue = player.currentTime - gesture.translation.width / 128
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
            PlaybackControlButtonView(systemName: "gobackward.10") {

            }

            PlaybackControlButtonView(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill",
                                      fontSize: 44) {
                viewModel.audioManager.togglePlayer()
            }

            PlaybackControlButtonView(systemName: "goforward.10") {

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
            .environmentObject(AudioManager())
    }
}
