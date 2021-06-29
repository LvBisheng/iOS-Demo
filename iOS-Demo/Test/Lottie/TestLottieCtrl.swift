//
//  TestLottieCtrl.swift
//  iOS-Demo
//
//  Created by lbs on 2021/6/29.
//  Copyright © 2021 LBS. All rights reserved.
//

import UIKit
import Lottie

enum ProgressKeyFrames: CGFloat {
    
    case start = 140
    
    case end = 187
    
    case complete = 240
    
}

class TestLottieCtrl: UIViewController {
    
    // 1. Create the AnimationView
    private var animationView: AnimationView?
    
    private var downloadView: AnimationView?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        testCoffee()
        testDownload()
    }
    
    private func testCoffee() {
        // 2. Start AnimationView with animation name (without extension)
        
        animationView = .init(name: "coffee")
        animationView?.backgroundColor = .red
        
        // 3. Set animation content mode
        
        animationView!.contentMode = .scaleAspectFit
        
        // 4. Set animation loop mode
        
        animationView!.loopMode = .loop
        
        // 5. Adjust animation speed
        
        animationView!.animationSpeed = 0.5
        
        view.addSubview(animationView!)
        
        // 6. Play animation
        
        animationView!.play()
    }
    
    private func testDownload() {
        // 2. Start AnimationView with animation name (without extension)
        downloadView = .init(name: "download")
        
        // 3. Set animation content mode
        
        downloadView!.contentMode = .scaleAspectFit
        
        // 4. Set animation loop mode
        
        downloadView!.loopMode = .playOnce
        
        // 5. Adjust animation speed
        
        downloadView!.animationSpeed = 0.5
        
        
        view.addSubview(downloadView!)
        startProgress()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutAnimation()
        layoutDownload()
    }
    
    private func layoutAnimation() {
        let w: CGFloat = 100
        let h: CGFloat = 100
        let x = (view.bounds.size.width - w) * 0.5
        let y = (view.bounds.size.height - h) * 0.5
        animationView?.frame = .init(x: x, y: y, width: w, height: h)
    }
    
    private func layoutDownload() {
        let w: CGFloat = 100
        let h: CGFloat = 100
        let x = (view.bounds.size.width - w) * 0.5
        let y = downloadView?.frame.maxY ?? 0 + 50
        downloadView?.frame = .init(x: x, y: y, width: w, height: h)
    }
}

extension TestLottieCtrl {
    // start the download
    
    private func startProgress() {
        
        // play from frame 0 to the start download of progress
        
//        downloadView?.play(fromFrame: 0, toFrame: ProgressKeyFrames.start.rawValue, loopMode: .none) { [weak self] (_) in
//
//            self?.startDownload()
//
//        }
        downloadView?.play(fromFrame: 0, toFrame: ProgressKeyFrames.start.rawValue, loopMode: .none) { [weak self] (_) in
            
//            self?.startDownload()
            
        }
        
    }
    
    // progress from 0 to 100%
    
    private func startDownload() {
        
        // 1. URL to download from
        
        let url = URL(string: "https://media.w3.org/2010/05/sintel/trailer.mp4")!
        
        // 2. Setup download task and start download
        
        let configuration = URLSessionConfiguration.default
        
        let operationQueue = OperationQueue()
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        let downloadTask = session.downloadTask(with: url)
        
        downloadTask.resume()
        
    }
    
    // download is completed, we show the completion state
    
    private func endDownload() {
        
        // download is completed, we show the completion state
        
        downloadView?.play(fromFrame: ProgressKeyFrames.end.rawValue, toFrame: ProgressKeyFrames.complete.rawValue, loopMode: .none)
        
    }
}

// MARK: - Download Delegate

extension TestLottieCtrl: URLSessionDownloadDelegate {
    // handles download progress
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentDownloaded: CGFloat = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            
            self.progress(to: percentDownloaded)
            
        }
        
    }
    
    // sets download progress
    
    private func progress(to progress: CGFloat) {
        
        // 1. We get the range of frames specific for the progress from 0-100%
        
        let progressRange = ProgressKeyFrames.end.rawValue - ProgressKeyFrames.start.rawValue
        
        // 2. Then, we get the exact frame for the current progress
        
        let progressFrame = progressRange * progress
        
        // 3. Then we add the start frame to the progress frame
        // Considering the example that we start in 140, and we moved 30 frames in the progress, we should show frame 170 (140+30)
        
        let currentFrame = progressFrame + ProgressKeyFrames.start.rawValue
        
        // 4. Manually setting the current animation frame
        
        downloadView?.currentFrame = currentFrame
        
        print("Downloading \((progress*100).rounded())%")
        
    }
    
    
    // finishes download
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        DispatchQueue.main.async {
            
            self.endDownload()
            
        }
        
    }
    
}
