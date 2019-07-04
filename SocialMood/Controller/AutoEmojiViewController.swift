//
//  AutoEmojiViewController.swift
//  SocialMood
//
//  Created by Bachir SAHALI on 04/07/2019.
//  Copyright © 2019 Néphélim Cohen. All rights reserved.
//

import UIKit
import AVKit
import Vision

class AutoEmojiViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

 
    @IBOutlet weak var emojiButton: UIButton!
    
    
    
    @IBOutlet weak var em: UIButton!
    
    var objectToSend: Mood!
    
    // AVCapture variables to hold sequence data
    var session: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var videoDataOutput: AVCaptureVideoDataOutput?
    var videoDataOutputQueue: DispatchQueue?
    
    var captureDevice: AVCaptureDevice?
    var captureDeviceResolution: CGSize = CGSize()
    
    // Layer UI for drawing Vision results
    var rootLayer: CALayer?
    var detectionOverlayLayer: CALayer?
    
    
    // Vision requests
    private var detectionRequests: [VNDetectFaceRectanglesRequest]?
    private var trackingRequests: [VNTrackObjectRequest]?
    
    lazy var sequenceRequestHandler = VNSequenceRequestHandler()
    
    var outerLips9: CGPoint?
    var innerLips5: CGPoint?
    var outerLips5: CGPoint?
    var outerLips3: CGPoint?
    var innerLips3: CGPoint?
    var innerLips0: CGPoint?
    var innerLips2: CGPoint?
    var innerLips1: CGPoint?
    var innerLips4: CGPoint?
    
    
    var sleep = 0
    
    
    
    @IBAction func emojiSelected(_ sender: UIButton) {
        
        
        self.performSegue(withIdentifier: "seg2", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "seg2"){
            let displayVC = segue.destination as! SocialViewController
            displayVC.recievedEmoji = objectToSend
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       
        // Do any additional setup after loading the view.
        self.session = self.setupAVCaptureSession()
        
        self.prepareVisionRequest()
        
        self.session?.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.session?.stopRunning()
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Ensure that the interface stays locked in Portrait.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // Ensure that the interface stays locked in Portrait.
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    // MARK: - AVCapture Setup -
    
    /// - Tag: CreateCaptureSession
    fileprivate func setupAVCaptureSession() -> AVCaptureSession? {
        let captureSession = AVCaptureSession()
        do {
            let inputDevice = try self.configureFrontCamera(for: captureSession)
            self.configureVideoDataOutput(for: inputDevice.device, resolution: inputDevice.resolution, captureSession: captureSession)
            return captureSession
        } catch let executionError as NSError {
            self.presentError(executionError)
        } catch {
            self.presentErrorAlert(message: "An unexpected failure has occured")
        }
        
        self.teardownAVCapture()
        
        return nil
    }
    
    
    // Removes infrastructure for AVCapture as part of cleanup.
    fileprivate func teardownAVCapture() {
        self.videoDataOutput = nil
        self.videoDataOutputQueue = nil
        
        if let previewLayer = self.previewLayer {
            previewLayer.removeFromSuperlayer()
            self.previewLayer = nil
        }
    }
    
    
    /// - Tag: ConfigureDeviceResolution
    fileprivate func highestResolution420Format(for device: AVCaptureDevice) -> (format: AVCaptureDevice.Format, resolution: CGSize)? {
        var highestResolutionFormat: AVCaptureDevice.Format? = nil
        var highestResolutionDimensions = CMVideoDimensions(width: 0, height: 0)
        
        for format in device.formats {
            let deviceFormat = format as AVCaptureDevice.Format
            
            let deviceFormatDescription = deviceFormat.formatDescription
            if CMFormatDescriptionGetMediaSubType(deviceFormatDescription) == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange {
                let candidateDimensions = CMVideoFormatDescriptionGetDimensions(deviceFormatDescription)
                if (highestResolutionFormat == nil) || (candidateDimensions.width > highestResolutionDimensions.width) {
                    highestResolutionFormat = deviceFormat
                    highestResolutionDimensions = candidateDimensions
                }
            }
        }
        
        if highestResolutionFormat != nil {
            let resolution = CGSize(width: CGFloat(highestResolutionDimensions.width), height: CGFloat(highestResolutionDimensions.height))
            return (highestResolutionFormat!, resolution)
        }
        
        return nil
    }
    
    fileprivate func configureFrontCamera(for captureSession: AVCaptureSession) throws -> (device: AVCaptureDevice, resolution: CGSize) {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
        
        if let device = deviceDiscoverySession.devices.first {
            if let deviceInput = try? AVCaptureDeviceInput(device: device) {
                if captureSession.canAddInput(deviceInput) {
                    captureSession.addInput(deviceInput)
                }
                
                if let highestResolution = self.highestResolution420Format(for: device) {
                    try device.lockForConfiguration()
                    device.activeFormat = highestResolution.format
                    device.unlockForConfiguration()
                    
                    return (device, highestResolution.resolution)
                }
            }
        }
        
        throw NSError(domain: "ViewController", code: 1, userInfo: nil)
    }
    
    /// - Tag: CreateSerialDispatchQueue
    fileprivate func configureVideoDataOutput(for inputDevice: AVCaptureDevice, resolution: CGSize, captureSession: AVCaptureSession) {
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        
        // Create a serial dispatch queue used for the sample buffer delegate as well as when a still image is captured.
        // A serial dispatch queue must be used to guarantee that video frames will be delivered in order.
        let videoDataOutputQueue = DispatchQueue(label: "com.bashalir.emoSelection")
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        }
        
        videoDataOutput.connection(with: .video)?.isEnabled = true
        
        if let captureConnection = videoDataOutput.connection(with: AVMediaType.video) {
            if captureConnection.isCameraIntrinsicMatrixDeliverySupported {
                captureConnection.isCameraIntrinsicMatrixDeliveryEnabled = true
            }
        }
        
        self.videoDataOutput = videoDataOutput
        self.videoDataOutputQueue = videoDataOutputQueue
        
        self.captureDevice = inputDevice
        self.captureDeviceResolution = resolution
    }
    
    
    
    // MARK: Performing Vision Requests
    
    /// - Tag: WriteCompletionHandler
    fileprivate func prepareVisionRequest() {
        
        //self.trackingRequests = []
        var requests = [VNTrackObjectRequest]()
        
        let faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: { (request, error) in
            
            if error != nil {
                print("FaceDetection error: \(String(describing: error)).")
            }
            
            guard let faceDetectionRequest = request as? VNDetectFaceRectanglesRequest,
                let results = faceDetectionRequest.results as? [VNFaceObservation] else {
                    return
            }
            DispatchQueue.main.async {
                // Add the observations to the tracking list
                for observation in results {
                    let faceTrackingRequest = VNTrackObjectRequest(detectedObjectObservation: observation)
                    requests.append(faceTrackingRequest)
                }
                self.trackingRequests = requests
            }
        })
        
        
        
        
        // Start with detection.  Find face, then track it.
        self.detectionRequests = [faceDetectionRequest]
        
        self.sequenceRequestHandler = VNSequenceRequestHandler()
        
    }
    
    // MARK: Helper Methods for Handling Device Orientation & EXIF
    
    fileprivate func radiansForDegrees(_ degrees: CGFloat) -> CGFloat {
        return CGFloat(Double(degrees) * Double.pi / 180.0)
    }
    
    func exifOrientationForDeviceOrientation(_ deviceOrientation: UIDeviceOrientation) -> CGImagePropertyOrientation {
        
        switch deviceOrientation {
        case .portraitUpsideDown:
            return .rightMirrored
            
        case .landscapeLeft:
            return .downMirrored
            
        case .landscapeRight:
            return .upMirrored
            
        default:
            return .leftMirrored
        }
    }
    
    func exifOrientationForCurrentDeviceOrientation() -> CGImagePropertyOrientation {
        return exifOrientationForDeviceOrientation(UIDevice.current.orientation)
    }
    
    // MARK: Helper Methods for Error Presentation
    
    fileprivate func presentErrorAlert(withTitle title: String = "Unexpected Failure", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true)
    }
    
    fileprivate func presentError(_ error: NSError) {
        self.presentErrorAlert(withTitle: "Failed with error \(error.code)", message: error.localizedDescription)
    }
    
    
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    /// - Tag: PerformRequests
    // Handle delegate method callback on receiving a sample buffer.
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        var requestHandlerOptions: [VNImageOption: AnyObject] = [:]
        
        let cameraIntrinsicData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil)
        if cameraIntrinsicData != nil {
            requestHandlerOptions[VNImageOption.cameraIntrinsics] = cameraIntrinsicData
        }
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to obtain a CVPixelBuffer for the current output frame.")
            return
        }
        
        let exifOrientation = self.exifOrientationForCurrentDeviceOrientation()
        
        guard let requests = self.trackingRequests, !requests.isEmpty else {
            // No tracking object detected, so perform initial detection
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                                            orientation: exifOrientation,
                                                            options: requestHandlerOptions)
            
            do {
                guard let detectRequests = self.detectionRequests else {
                    return
                }
                try imageRequestHandler.perform(detectRequests)
            } catch let error as NSError {
                NSLog("Failed to perform FaceRectangleRequest: %@", error)
            }
            return
        }
        
        do {
            try self.sequenceRequestHandler.perform(requests,
                                                    on: pixelBuffer,
                                                    orientation: exifOrientation)
        } catch let error as NSError {
            NSLog("Failed to perform SequenceRequest: %@", error)
        }
        
        // Setup the next round of tracking.
        var newTrackingRequests = [VNTrackObjectRequest]()
        for trackingRequest in requests {
            
            guard let results = trackingRequest.results else {
                return
            }
            
            guard let observation = results[0] as? VNDetectedObjectObservation else {
                return
            }
            
            if !trackingRequest.isLastFrame {
                if observation.confidence > 0.3 {
                    trackingRequest.inputObservation = observation
                } else {
                    trackingRequest.isLastFrame = true
                }
                newTrackingRequests.append(trackingRequest)
            }
        }
        self.trackingRequests = newTrackingRequests
        
        if newTrackingRequests.isEmpty {
            // Nothing to track, so abort.
            return
        }
        
        // Perform face landmark tracking on detected faces.
        var faceLandmarkRequests = [VNDetectFaceLandmarksRequest]()
        
        
        
        // Perform landmark detection on tracked faces.
        for trackingRequest in newTrackingRequests {
            
            
            if let outerLips9 = outerLips9, let innerLips5 = innerLips5, let outerLips5 = outerLips5, let outerLips3 = outerLips3, let innerLips3 = innerLips3, let innerLips0 = innerLips0, let innerLips1 = innerLips1, let innerLips4 = innerLips4 {
                
                
                
                
                
                
                if (outerLips9.y > innerLips5.y || outerLips5.y > innerLips3.y)
                {  if  (innerLips1.y > innerLips4.y + 0.1) && (innerLips0.y > innerLips5.y + 0.1) {
                    print("Hilarious")
                    
                  
                    
                } else {
                    print("Happy")
                    emojiButton.setImage(#imageLiteral(resourceName: "Cool"), for: .normal)
                    
                    } }
                else if (outerLips9.y + 0.015 < innerLips5.y && outerLips5.y + 0.015 < innerLips3.y  ) {
                    print("Sad")
                    emojiButton.setImage(#imageLiteral(resourceName: "Sad"), for: .normal)
                }
                    
                else {
                    print("Neutral")
                    emojiButton.setImage(#imageLiteral(resourceName: "Middle"), for: .normal)
                }
                
                
                
                //                print(innerLips1.y, innerLips4.y )
                
                
                
                
                
                
            }
            
            let faceLandmarksRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request, error) in
                
                if error != nil {
                    print("FaceLandmarks error: \(String(describing: error)).")
                }
                
                guard let landmarksRequest = request as? VNDetectFaceLandmarksRequest,
                    let results = landmarksRequest.results as? [VNFaceObservation] else {
                        return
                }
                
                
                
                // Perform all UI updates (drawing) on the main queue, not the background queue on which this handler is being called.
                DispatchQueue.main.async {
                    print("2")
                    
                    self.analyseFaceObservation(results)
                }
            })
            
            
            
            guard let trackingResults = trackingRequest.results else {
                return
            }
            
            guard let observation = trackingResults[0] as? VNDetectedObjectObservation else {
                return
            }
            let faceObservation = VNFaceObservation(boundingBox: observation.boundingBox)
            faceLandmarksRequest.inputFaceObservations = [faceObservation]
            
            // Continue to track detected facial landmarks.
            faceLandmarkRequests.append(faceLandmarksRequest)
            
            
            
            
            
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                                            orientation: exifOrientation,
                                                            options: requestHandlerOptions)
            
            do {
                try imageRequestHandler.perform(faceLandmarkRequests)
            } catch let error as NSError {
                NSLog("Failed to perform FaceLandmarkRequest: %@", error)
            }
        }
    }
    
    
    
    
    
    func analyseFaceObservation(_ faceObservations: [VNFaceObservation]) {
        
        
        
        
        for faceObservation in faceObservations {
            
            
            
            
            outerLips9 = faceObservation.landmarks?.outerLips?.normalizedPoints[9]
            innerLips5 = faceObservation.landmarks?.innerLips?.normalizedPoints[5]
            outerLips5 = faceObservation.landmarks?.outerLips?.normalizedPoints[5]
            outerLips3 = faceObservation.landmarks?.outerLips?.normalizedPoints[3]
            innerLips3 = faceObservation.landmarks?.innerLips?.normalizedPoints[3]
            innerLips0 = faceObservation.landmarks?.innerLips?.normalizedPoints[0]
            innerLips1 = faceObservation.landmarks?.innerLips?.normalizedPoints[1]
            innerLips4 = faceObservation.landmarks?.innerLips?.normalizedPoints[4]
            
            
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            
            
            if let outerLips9 = self.outerLips9, let innerLips5 = self.innerLips5, let outerLips5 = self.outerLips5, let outerLips3 = self.outerLips3, let innerLips3 = self.innerLips3, let innerLips0 = self.innerLips0, let innerLips1 = self.innerLips1, let innerLips4 = self.innerLips4 {
                
                if (outerLips9.y > innerLips5.y || outerLips5.y > innerLips3.y)
                {  if  (innerLips1.y > innerLips4.y + 0.1) && (innerLips0.y > innerLips5.y + 0.1) {
                    print("Hilarious")
                    
                    objectToSend = Mood(emojiSelected: "Happy", note: "", socialSelected: [])
                   
                        
                    em.setImage(#imageLiteral(resourceName: "Happy@5x.png") , for: .normal)
                   
                    
                    
                } else {
                    print("Happy")
                    
                  objectToSend = Mood(emojiSelected: "Cool", note: "", socialSelected: [])
                    em.setImage(#imageLiteral(resourceName: "Happy@5x.png"), for: .normal)
                    
                    } }
                else if (outerLips9.y + 0.015 < innerLips5.y && outerLips5.y + 0.015 < innerLips3.y  ) {
                    print("Sad")
                    
                    objectToSend = Mood(emojiSelected: "Sad", note: "", socialSelected: [])
            
                    em.setImage(#imageLiteral(resourceName: "Sad@5x.png"), for: .normal)
                  
                    
                }
                    
                else {
                    print("Neutral")
                    
                    objectToSend = Mood(emojiSelected: "Middle", note: "", socialSelected: [])
                    
                     em.setImage(#imageLiteral(resourceName: "Middle@5x.png"), for: .normal)
                    
                }
                
                
                //                }
                
                
            }
            
        }
        
    }
    
    
    
}







