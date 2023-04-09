//
//  TestView.swift
//  PulsePace
//
//  Created by Peter Jung on 2023/04/08.
//

import SwiftUI
import UniformTypeIdentifiers

struct TestView: View {
    @State var show = false

    var body: some View {
        Button(action: {
            self.show.toggle()
        }) {
            Text("Document Picker")
        }
        .sheet(isPresented: $show) {
            DocumentPicker()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.mp3]) // TODO: parameterise
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            do {
                var documentData = [Data]()
                for url in urls {
                    let isAccessing = url.startAccessingSecurityScopedResource()
                    documentData.append(try Data(contentsOf: url))
                    if isAccessing {
                        url.stopAccessingSecurityScopedResource()
                    }
                }
                if let data = documentData.first {
                    let firebaseStorage = FirebaseStorage()
                    firebaseStorage.upload(data: data) { result in
                        switch result {
                        case .success(let url):
                            print("Upload succeeded, URL: \(url)")
                        case .failure(let error):
                            print("Upload failed, error: \(error)")
                        }
                    }
                }
            } catch {
                print(error)
                print("no data")
            }
        }
    }
}
