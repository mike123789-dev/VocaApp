//
//  FaceDetectionView.swift
//  Voca
//
//  Created by 강병민 on 2022/04/16.
//

import SwiftUI

struct FaceDetectionView: UIViewControllerRepresentable {
    var didDetectFacePosition: ((FacePosition) -> Void)?

    typealias UIViewControllerType = FaceDetectionViewController
    
    func makeUIViewController(context: Context) -> FaceDetectionViewController {
        let viewController = FaceDetectionViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: FaceDetectionViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }

    
    class Coordinator: NSObject, FaceDetectionDelegate {
        let scannerView: FaceDetectionView
        
        init(with scannerView: FaceDetectionView) {
            self.scannerView = scannerView
        }
        
        
        // MARK: - VNDocumentCameraViewControllerDelegate
        func didDetectFacePosition(_ position: FacePosition) {
            scannerView.didDetectFacePosition?(position)
        }
    }
    
}
