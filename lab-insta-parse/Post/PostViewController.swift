//
//  PostViewController.swift
//  lab-insta-parse
//

import UIKit
import PhotosUI
import Photos
import CoreLocation
import ParseSwift

class PostViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var previewImageView: UIImageView!

    private var pickedImage: UIImage?

    // info about the picked photo
    private var pickedDate: Date?
    private var pickedLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onPickedImageTapped(_ sender: UIBarButtonItem) {
        // ask for photo access first so we can read the date and location
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] _ in
            DispatchQueue.main.async {
                self?.showPicker()
            }
        }
    }

    private func showPicker() {
        // passing .shared() makes the picker give us the photo's id
        var config = PHPickerConfiguration(photoLibrary: .shared())

        // only show images
        config.filter = .images

        config.preferredAssetRepresentationMode = .current

        // one image at a time
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)

        // so the picker can hand us the chosen image
        picker.delegate = self

        // show the picker
        present(picker, animated: true)
    }

    @IBAction func onShareTapped(_ sender: Any) {

        view.endEditing(true)
        print("1️⃣ Share tapped")

        guard let image = pickedImage,
              let imageData = image.jpegData(compressionQuality: 0.1) else {
            print("❌ No picked image — bailing out")
            return
        }
        print("2️⃣ Got image data, size: \(imageData.count) bytes")

        let imageFile = ParseFile(name: "image.jpg", data: imageData)

        var post = Post()
        post.imageFile = imageFile
        post.caption = captionTextField.text
        post.user = User.current

        // save when the photo was taken
        post.takenAt = pickedDate

        // save where the photo was taken (if it has a location)
        if let location = pickedLocation {
            post.location = try? ParseGeoPoint(latitude: location.coordinate.latitude,
                                               longitude: location.coordinate.longitude)
        }
        print("3️⃣ About to save post, date: \(String(describing: pickedDate)), location: \(String(describing: pickedLocation?.coordinate))")

        post.save { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("✅ Post Saved! \(post)")
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("❌ SAVE FAILED: \(error)")
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }

    @IBAction func onViewTapped(_ sender: Any) {
        // dismiss keyboard
        view.endEditing(true)
    }

    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // dismiss picker
        picker.dismiss(animated: true)

        guard let result = results.first else { return }

        // look up the photo's date and location using its id
        if let assetId = result.assetIdentifier {
            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
            if let asset = assets.firstObject {
                pickedDate = asset.creationDate
                pickedLocation = asset.location
            }
        }

        // make sure it can be loaded as an image
        let provider = result.itemProvider
        guard provider.canLoadObject(ofClass: UIImage.self) else { return }

        // load the image
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in

            // handle any error
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(description: error.localizedDescription)
                }
                return
            }

            guard let image = object as? UIImage else {
                DispatchQueue.main.async {
                    self?.showAlert()
                }
                return
            }

            DispatchQueue.main.async {
                // show the chosen image in the preview
                self?.previewImageView.image = image
                // store it so we can save it when the user taps Share
                self?.pickedImage = image
            }
        }
    }
}
