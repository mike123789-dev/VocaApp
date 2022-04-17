//
//  VisionClient.swift
//  Voca
//
//  Created by 강병민 on 2022/04/17.
//

import UIKit
import ComposableArchitecture
import Vision


public struct VisionClient {
  var recognizeText: ([UIImage]) -> Effect<[TextItem], NSError>
}

extension VisionClient {
  public static var live = Self(
    recognizeText: { images in
        return .future { callback in
            for image in images {
                guard let cgImage = image.cgImage else { return }
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                do {
                    let request = VNRecognizeTextRequest { request, error in
                        if let error = error {
                            callback(.failure(error as NSError))
                            return
                        }
                        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                        
                        let items = observations
                            .compactMap { $0.topCandidates(1).first }
                            .map{ TextItem(text: $0.string) }
                        
                        callback(.success(items))
                    }
                    
                    request.recognitionLevel = .accurate
                    request.usesLanguageCorrection = true
                    try requestHandler.perform([request])
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
        
        
    })
}
