import SwiftUI
import PhotosUI

struct PhotoSection: View {
    @Bindable var vm: EntryFormViewModel
    @State private var pickerItem: PhotosPickerItem? = nil
    @State private var showingURLAlert = false

    var body: some View {
        Section("Photos") {
            // Photo thumbnails
            if !vm.stagedPhotos.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(vm.stagedPhotos.indices, id: \.self) { i in
                            ZStack(alignment: .topTrailing) {
                                CoffeePhotoView(photo: vm.stagedPhotos[i], contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))

                                Button {
                                    vm.stagedPhotos.remove(at: i)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.white, .black.opacity(0.6))
                                }
                                .offset(x: 6, y: -6)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            // Add photo buttons
            HStack(spacing: 16) {
                // Camera
                PhotoButton(icon: "camera", label: "Camera") {
                    vm.showingCamera = true
                }

                // Photo Library
                PhotosPickerButton(icon: "photo", label: "Library", item: $pickerItem)
                    .onChange(of: pickerItem) { _, newItem in
                        guard let newItem else { return }
                        Task {
                            if let data = try? await newItem.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                vm.addPhoto(from: uiImage, source: .library)
                            }
                        }
                    }

                // Web Search
                PhotoButton(icon: "magnifyingglass", label: "Search") {
                    vm.showingImageSearch = true
                }

                // URL
                PhotoButton(icon: "link", label: "URL") {
                    showingURLAlert = true
                }
            }
            .padding(.vertical, 4)
        }
        .sheet(isPresented: $vm.showingCamera) {
            CameraPickerView { image in
                vm.addPhoto(from: image, source: .camera)
            }
        }
        .sheet(isPresented: $vm.showingImageSearch) {
            ImageSearchSheet { result in
                vm.addPhoto(from: result)
            }
        }
        .alert("Image URL", isPresented: $showingURLAlert) {
            TextField("https://...", text: $vm.pendingURLInput)
                .keyboardType(.URL)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            Button("Add") {
                vm.addPhoto(fromURLString: vm.pendingURLInput)
                vm.pendingURLInput = ""
            }
            Button("Cancel", role: .cancel) { vm.pendingURLInput = "" }
        } message: {
            Text("Paste a direct image URL.")
        }
    }
}

// MARK: - Helper subviews

private struct PhotoButton: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                Text(label)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

private struct PhotosPickerButton: View {
    let icon: String
    let label: String
    @Binding var item: PhotosPickerItem?

    var body: some View {
        PhotosPicker(selection: $item, matching: .images) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                Text(label)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Camera UIViewControllerRepresentable

struct CameraPickerView: UIViewControllerRepresentable {
    var onCapture: (UIImage) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(onCapture: onCapture) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onCapture: (UIImage) -> Void
        init(onCapture: @escaping (UIImage) -> Void) { self.onCapture = onCapture }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            picker.dismiss(animated: true)
            if let image = info[.originalImage] as? UIImage {
                onCapture(image)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
