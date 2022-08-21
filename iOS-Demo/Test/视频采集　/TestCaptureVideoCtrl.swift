//
//  TestCaptureVideoCtrl.swift
//  iOS-Demo
//
//  Created by farben on 2022/8/14.
//  Copyright © 2022 LBS. All rights reserved.
//

import UIKit
import FDFullscreenPopGesture

class TestCaptureVideoCtrl: XLBaseViewController {
    
    var manager: LBSCatureVideoManager!;

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.fd_prefersNavigationBarHidden = true
        manager = LBSCatureVideoManager.videoPreset(AVCaptureSession.Preset.hd4K3840x2160.rawValue, devicePosition: AVCaptureDevice.Position.back, deletate: self)
        manager.videoPermission()
        
        manager.startRunning()

        self.manager.startRecordVideoAction()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        manager.stopRecordVideoAction { url in

        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        manager.stopRunning()
      
    }
}

extension TestCaptureVideoCtrl {
    private func _setupPreviewView() {
        let current = UIApplication.shared.statusBarOrientation
        let previewLayer = manager.previewlayer
        // 摆正摄像头镜像
        var rotationAngle: CGFloat = 0
        if(UIInterfaceOrientation.landscapeLeft == current) {
            rotationAngle = Double.pi / 2
        } else if(UIInterfaceOrientation.landscapeRight == current) {
            rotationAngle = -Double.pi / 2
        }
        let trans = CATransform3DMakeRotation(rotationAngle, 0, 0, 1)
        previewLayer?.transform = trans
        if let previewLayer = previewLayer {
            view.layer.insertSublayer(previewLayer, at: 0)
        }
    }
}

extension TestCaptureVideoCtrl:LBSCatureVideoManagerDelegate {
    func onPermissionOfCamer(_ camerState: AVAuthorizationStatus) {
        if(camerState == .authorized) {
            _setupPreviewView()
        }
    }
    
    func onCaptureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
    }
}
