//
//  ViewController.swift
//  faceDetection02
//
//  Created by Jaeho Jung on 2023/01/21.
//

import UIKit
import Vision

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let image = UIImage(named: "tomCruise01") else {return}
        guard let image = UIImage(named: "tomCruise&woman0") else {return}
        
        DispatchQueue.main.async { [self] in
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            
            let scaleHeight = view.frame.width / image.size.width * image.size.height
            
            imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaleHeight)
            imageView.backgroundColor = .blue
    
            view.addSubview(imageView)
            
            let request = VNDetectFaceRectanglesRequest { (req, err) in
                
                if let err = err {
                    print("fialed to detect faces:", err)
                    return
                }

                req.results?.forEach({ (res) in
                    print(res)
                    
                    guard let faceObservation = res as? VNFaceObservation else {return}
                    
                    
                    DispatchQueue.main.async {
                        let x = self.view.frame.width * faceObservation.boundingBox.origin.x

                        let height = scaleHeight * faceObservation.boundingBox.height

                        let y = scaleHeight * (1 - faceObservation.boundingBox.height) - height
                        
                        let width = self.view.frame.width * faceObservation.boundingBox.width

                        let redView = UIView()
                        redView.backgroundColor = .red
                        redView.alpha = 0.4
                        redView.frame = CGRect(x: x, y:y, width: width, height: height)
                        self.view.addSubview(redView)
                        
                        print(faceObservation.boundingBox)

                    }
                })
            }
            
            request.usesCPUOnly = true
            
            guard let cgImage = image.cgImage else {return}
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [ : ])
            do {
                try handler.perform([request])
            } catch let reqErr {
                print("faield to perform request", reqErr)
            }
        }
    }
}

