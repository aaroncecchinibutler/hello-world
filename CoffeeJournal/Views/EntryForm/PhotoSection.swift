import SwiftUI
import PhotosUI

struct PhotoSection: View {
    @Bindable var vm: EntryFormViewModel
    @State private var pickerItem: PhotosPickerItem?
    @State private var showingURLAlert = false

    var body: some View {
        FormSection(title: "Photos") {
            // Thumbnails
            if !vm.stagedPhotos.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(vm.stagedPhotos.indices, id: \.self) { i in
                            ZStack(alignment: .topTrailing) {
                                CoffeePhotoView(photo: vm.stagedPhotos[i], contentMode: .fill)
                                    .frame(width: 72, height: 72)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder(Color.appBorder, lineWidth: Constants.Layout.borderWidth)
                                    )

                                Button {
                                    vm.stagedPhotos.remove(at: i)
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(Color.textSecondary, Color.appSurface)
                                }
                                .offset(x: 5, y: -5)
                            }
                        }
                    }
                    .padding(.horizontal, Constants.Layout.pageInset)
                    .padding(.vertical, 10)
                }
                .overlay(
                    Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth),
                    alignment: .bottom
                )
            }

            // Add buttons — four equal columns
            HStack(spacing: 0) {
                photoButton(icon: "camera", label: "Camera") {
                    vm.showingCamera = true
                }

                divider

                PhotosPicker(selection: $pickerItem, matching: .images) {
                    photoButtonLabel(icon: "photo", label: "Library")
                }
                .buttonStyle(.plain)
                .onChange(of: pickerItem) { _, item in
                    guard let item else { return }
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let img = UIImage(data: data) {
                            vm.addPhoto(from: img, source: .library)
                        }
                    }
                }

                divider

                photoButton(icon: "magnifyingglass", label: "Search") {
                    vm.showingImageSearch = true
                }

                divider

                photoButton(icon: "link", label: "URL") {
                    showingURLAlert = true
                }
            }
            .frame(height: 56)
            .background(Color.appSurface)
        }
        .sheet(isPresented: $vm.showingCamera) {
            CameraPickerView { vm.addPhoto(from: $0, source: .camera) }
        }
        .sheet(isPresented: $vm.showingImageSearch) {
            ImageSearchSheet { vm.addPhoto(from: $0) }
        }
        .alert("Image URL", isPresented: $showingURLAlert) {
            TextField("https://…", text: $vm.pendingURLInput)
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

    // MARK: - Helpers

    private var divider: some View {
        Rectangle()
            .fill(Color.appBorder)
            .frame(width: Constants.Layout.borderWidth)
    }

    private func photoButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            photoButtonLabel(icon: icon, label: label)
        }
        .buttonStyle(.plain)
    }

    private func photoButtonLabel(icon: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .light))
                .foregroundStyle(Color.textSecondary)
            Text(label)
                .font(Constants.Typography.micro)
                .foregroundStyle(Color.textTertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Camera picker

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
            if let image = info[.originalImage] as? UIImage { onCapture(image) }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
