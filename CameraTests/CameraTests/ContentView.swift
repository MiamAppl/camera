//
//  ContentView.swift
//  CameraTests
//
//  Created by Bilel Hattay on 14/03/2021.
//

//import UIKit
//import SwiftUI
//import AVKit

//
//struct RecordingView: View {
//    @State private var timer = 5
//    @State private var onComplete = false
//    @State private var recording = false
//
//    var body: some View {
//        ZStack {
//            VideoRecordingView(timeLeft: $timer, onComplete: $onComplete, recording: $recording)
//            VStack {
//                Button(action: {
//                    self.recording.toggle()
//                }, label: {
//                    Text("Toggle Recording")
//                })
//                    .foregroundColor(.white)
//                    .padding()
//                Button(action: {
//                    self.timer -= 1
//                    print(self.timer)
//                }, label: {
//                    Text("Toggle timer")
//                })
//                    .foregroundColor(.white)
//                    .padding()
//                Button(action: {
//                    self.onComplete.toggle()
//                }, label: {
//                    Text("Toggle completion")
//                })
//                    .foregroundColor(.white)
//                    .padding()
//            }
//        }
//    }
//
//}
//
//struct RecordingView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingView()
//    }
//}
//
//
//struct VideoRecordingView: UIViewRepresentable {
//
//    @Binding var timeLeft: Int
//    @Binding var onComplete: Bool
//    @Binding var recording: Bool
//    func makeUIView(context: UIViewRepresentableContext<VideoRecordingView>) -> PreviewView {
//        let recordingView = PreviewView()
//        recordingView.onComplete = {
//            self.onComplete = true
//        }
//
//        recordingView.onRecord = { timeLeft, totalShakes in
//            self.timeLeft = timeLeft
//            self.recording = true
//        }
//
//        recordingView.onReset = {
//            self.recording = false
//            self.timeLeft = 30
//        }
//        return recordingView
//    }
//
//    func updateUIView(_ uiViewController: PreviewView, context: UIViewRepresentableContext<VideoRecordingView>) {
//
//    }
//}
//
//extension PreviewView: AVCaptureFileOutputRecordingDelegate{
//    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//        print(outputFileURL.absoluteString)
//    }
//}
//
//class PreviewView: UIView {
//    private var captureSession: AVCaptureSession?
//    private var shakeCountDown: Timer?
//    let videoFileOutput = AVCaptureMovieFileOutput()
//    var recordingDelegate:AVCaptureFileOutputRecordingDelegate!
//    var recorded = 0
//    var secondsToReachGoal = 30
//
//    var onRecord: ((Int, Int)->())?
//    var onReset: (() -> ())?
//    var onComplete: (() -> ())?
//
//    init() {
//        super.init(frame: .zero)
//
//        var allowedAccess = false
//        let blocker = DispatchGroup()
//        blocker.enter()
//        AVCaptureDevice.requestAccess(for: .video) { flag in
//            allowedAccess = flag
//            blocker.leave()
//        }
//        blocker.wait()
//
//        if !allowedAccess {
//            print("!!! NO ACCESS TO CAMERA")
//            return
//        }
//
//        // setup session
//        let session = AVCaptureSession()
//        session.beginConfiguration()
//
//        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
//                                                  for: .video, position: .front)
//        guard videoDevice != nil, let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), session.canAddInput(videoDeviceInput) else {
//            print("!!! NO CAMERA DETECTED")
//            return
//        }
//        session.addInput(videoDeviceInput)
//        session.commitConfiguration()
//        self.captureSession = session
//    }
//
//    override class var layerClass: AnyClass {
//        AVCaptureVideoPreviewLayer.self
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
//        return layer as! AVCaptureVideoPreviewLayer
//    }
//
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//        recordingDelegate = self
//        startTimers()
//        if nil != self.superview {
//            self.videoPreviewLayer.session = self.captureSession
//            self.videoPreviewLayer.videoGravity = .resizeAspect
//            self.captureSession?.startRunning()
//            self.startRecording()
//        } else {
//            self.captureSession?.stopRunning()
//        }
//    }
//
//    private func onTimerFires(){
//        print("🟢 RECORDING \(videoFileOutput.isRecording)")
//        secondsToReachGoal -= 1
//        recorded += 1
//        onRecord?(secondsToReachGoal, recorded)
//
//        if(secondsToReachGoal == 0){
//            stopRecording()
//            shakeCountDown?.invalidate()
//            shakeCountDown = nil
//            onComplete?()
//            videoFileOutput.stopRecording()
//        }
//    }
//
//    func startTimers(){
//        if shakeCountDown == nil {
//            shakeCountDown = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
//                self?.onTimerFires()
//            }
//        }
//    }
//
//    func startRecording(){
//        captureSession?.addOutput(videoFileOutput)
//
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let filePath = documentsURL.appendingPathComponent("tempPZDC")
//
//        videoFileOutput.startRecording(to: filePath, recordingDelegate: recordingDelegate)
//    }
//
//    func stopRecording(){
//        videoFileOutput.stopRecording()
//        print("🔴 RECORDING \(videoFileOutput.isRecording)")
//    }
//}
//// -----------------------------------------------------------------------------------------------------
////final class CameraViewController: UIViewController {
////    let cameraController = CameraController()
////    var previewView: UIView!
////
////    override func viewDidLoad() {
////
////        previewView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
////        previewView.contentMode = UIView.ContentMode.scaleAspectFit
////        view.addSubview(previewView)
////
////        cameraController.prepare {(error) in
////            if let error = error {
////                print(error)
////            }
////
////            try? self.cameraController.displayPreview(on: self.previewView)
////        }
////
////    }
////}
////
////extension CameraViewController : UIViewControllerRepresentable{
////    public typealias UIViewControllerType = CameraViewController
////
////    public func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> CameraViewController {
////        return CameraViewController()
////    }
////
////    public func updateUIViewController(_ uiViewController: CameraViewController, context: UIViewControllerRepresentableContext<CameraViewController>) {
////    }
////}
////
//struct ContentView: View {
//   var body: some View {
//    RecordingView()
//        .edgesIgnoringSafeArea(.top)
//   }
//}

import SwiftUI
 
struct MyCameraView: View {
    @State private var image: UIImage?
    
    var customCameraRepresentable = CustomCameraRepresentable(
        cameraFrame: .zero,
        imageCompletion: { _ in }
    )
    
    var body: some View {
        CustomCameraView(
            customCameraRepresentable: customCameraRepresentable,
            imageCompletion: { newImage in
                self.image = newImage
            }
        )
        .onAppear {
            customCameraRepresentable.startRunningCaptureSession()
        }
        .onDisappear {
            customCameraRepresentable.stopRunningCaptureSession()
        }
        
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}



import SwiftUI

struct CustomCameraView: View {
    var customCameraRepresentable: CustomCameraRepresentable
    var imageCompletion: ((UIImage) -> Void)
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                let frame = CGRect(x: 0, y: 0, width: geometry.size.width, height: geometry.size.height - 100)
                cameraView(frame: frame)
                
                HStack {
                    CameraControlsView(captureButtonAction: { [weak customCameraRepresentable] in
                        customCameraRepresentable?.takePhoto()
                    })
                }
            }
        }
    }
    
    private func cameraView(frame: CGRect) -> CustomCameraRepresentable {
        customCameraRepresentable.cameraFrame = frame
        customCameraRepresentable.imageCompletion = imageCompletion
        return customCameraRepresentable
    }
}

import SwiftUI

struct CameraControlsView: View {
    var captureButtonAction: (() -> Void)
    
    var body: some View {
        CaptureButtonView()
            .onTapGesture {
                captureButtonAction()
            }
    }
}

import SwiftUI

struct CaptureButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        Image(systemName: "camera")
            .font(.largeTitle)
            .padding(20)
            .background(colorScheme == .dark ? Color.white : Color.black)
            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(colorScheme == .dark ? Color.white : Color.black)
                    .scaleEffect(animationAmount)
                    .opacity(Double(2 - animationAmount))
                    .animation(
                        Animation.easeOut(duration: 1)
                            .repeatForever(autoreverses: false)
                    )
            )
            .onAppear {
                animationAmount = 2
            }
    }
}

import SwiftUI
import AVFoundation

final class CustomCameraController: UIViewController {
    static let shared = CustomCameraController()
    
    private var captureSession = AVCaptureSession()
    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    private var currentCamera: AVCaptureDevice?
    private var photoOutput: AVCapturePhotoOutput?
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    weak var captureDelegate: AVCapturePhotoCaptureDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func configurePreviewLayer(with frame: CGRect) {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer.frame = frame
        
        view.layer.insertSublayer(cameraPreviewLayer, at: 0)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    func stopRunningCaptureSession() {
        captureSession.stopRunning()
        
    }
    
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        
        guard let delegate = captureDelegate else {
            print("delegate nil")
            return
        }
        photoOutput?.capturePhoto(with: settings, delegate: delegate)
    }
    
    // MARK: Private
    
    private func setup() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
    }
    
    private func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    private func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .unspecified
        )
        
        for device in deviceDiscoverySession.devices {
            switch device.position {
            case AVCaptureDevice.Position.front:
                frontCamera = device
            case AVCaptureDevice.Position.back:
                backCamera = device
            default:
                break
            }
        }
        
        self.currentCamera = self.backCamera
    }
    
    private func setupInputOutput() {
        do {
            guard let currentCamera = currentCamera else { return }
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera)
            
            captureSession.addInput(captureDeviceInput)
            
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray(
                [AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])],
                completionHandler: nil
            )
            
            guard let photoOutput = photoOutput else { return }
            captureSession.addOutput(photoOutput)
        } catch {
            print(error)
        }
    }
}

final class CustomCameraRepresentable: UIViewControllerRepresentable {
//    @Environment(\.presentationMode) var presentationMode
    
    init(cameraFrame: CGRect, imageCompletion: @escaping ((UIImage) -> Void)) {
        self.cameraFrame = cameraFrame
        self.imageCompletion = imageCompletion
    }
    
    var cameraFrame: CGRect
    var imageCompletion: ((UIImage) -> Void)
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> CustomCameraController {
        CustomCameraController.shared.configurePreviewLayer(with: cameraFrame)
        CustomCameraController.shared.captureDelegate = context.coordinator
        return CustomCameraController.shared
    }
    
    func updateUIViewController(_ cameraViewController: CustomCameraController, context: Context) {}
    
    func takePhoto() {
        CustomCameraController.shared.takePhoto()
    }
    
    func startRunningCaptureSession() {
        CustomCameraController.shared.startRunningCaptureSession()
    }
    
    func stopRunningCaptureSession() {
        CustomCameraController.shared.stopRunningCaptureSession()
    }
}

extension CustomCameraRepresentable {
    final class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        private let parent: CustomCameraRepresentable
        
        init(_ parent: CustomCameraRepresentable) {
            self.parent = parent
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput,
                         didFinishProcessingPhoto photo: AVCapturePhoto,
                         error: Error?) {
            if let imageData = photo.fileDataRepresentation() {
                guard let newImage = UIImage(data: imageData) else { return }
                parent.imageCompletion(newImage)
            }
//            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
