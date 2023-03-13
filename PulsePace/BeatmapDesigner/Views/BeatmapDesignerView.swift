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
            if let player = viewModel.audioManager.player {
                renderSlider(player: player)
                renderPlaybackButtons(player: player)
            }

            ZStack {
                ForEach(viewModel.hitObjects, id: \.id) { hitObject in
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
                viewModel.hitObjects.append(TapHitObject(position: position, beat: viewModel.sliderValue))
            }
        }
        .onAppear {
            viewModel.audioManager.startPlayer(track: "test")
        }
        .onDisappear {
            viewModel.audioManager.togglePlayer()
        }
    }

    func renderSlider(player: AVAudioPlayer) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: 2 * player.duration, height: 20)
                .offset(x: player.duration - 2 * viewModel.sliderValue)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            viewModel.sliderValue = player.currentTime - gesture.translation.width / 2
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
                .foregroundColor(.black)
                .frame(width: 5, height: 40)
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
        ZStack {
            Circle()
                .strokeBorder(.white, lineWidth: 4)
                .frame(width: min(800, max(100, 100 + 200 * (hitObject.beat - viewModel.sliderValue))),
                       height: min(800, max(100, 100 + 200 * (hitObject.beat - viewModel.sliderValue))))
                .position(x: hitObject.position.x,
                          y: hitObject.position.y)

            Circle()
                .fill(.white)
                .frame(width: 100, height: 100)
                .position(x: hitObject.position.x,
                          y: hitObject.position.y) // TODO: constants

        }
        .opacity(max(0, 1 - 0.5 * abs(hitObject.beat - viewModel.sliderValue)))
    }
}

struct BeatmapDesignerView_Previews: PreviewProvider {
    static var previews: some View {
        BeatmapDesignerView(viewModel: BeatmapDesignerViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(AudioManager())
    }
}
