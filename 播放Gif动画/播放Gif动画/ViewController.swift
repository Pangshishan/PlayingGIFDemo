//
//  ViewController.swift
//  播放Gif动画
//
//  Created by 山不在高 on 17/6/20.
//  Copyright © 2017年 山不在高. All rights reserved.
//

import UIKit

// 图片处理框架
import ImageIO

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.获取NSData类型
        guard let filePath = Bundle.main.path(forResource: "demo.gif", ofType: nil) else { return }
        guard let fileData = NSData(contentsOfFile: filePath) else { return }
        
        // 2.根据Data获取CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(fileData, nil) else { return }
        
        // 3.获取gif图片中图片的个数
        let frameCount = CGImageSourceGetCount(imageSource)
        // 记录播放时间
        var duration : TimeInterval = 0
        var images = [UIImage]()
        for i in 0..<frameCount {
            // 3.1.获取图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            // 3.2.获取时长
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) , let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
                let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else { continue }
            duration += frameDuration.doubleValue
            let image = UIImage(cgImage: cgImage)
            images.append(image)
            // 设置停止播放时现实的图片
            if i == frameCount - 1 {
                imageView.image = image
            }
        }
        // 4.播放图片
        imageView.animationImages = images
        // 播放总时间
        imageView.animationDuration = duration
        // 播放次数, 0为无限循环
        imageView.animationRepeatCount = 1
        // 开始播放
        imageView.startAnimating()
        // 停止播放
//        imageView.stopAnimating()
    }
}

