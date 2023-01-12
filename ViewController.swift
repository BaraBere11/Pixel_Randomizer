//
//  ViewController.swift
//  Swift_Second
//
//  Created by Artem Pankov on 2023-01-11.
//

import UIKit

class ViewController: UIViewController {
        
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Get Random Picture", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let colors: [UIColor] = [.systemBlue, .systemRed, .systemPink, .systemPurple]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        view.addSubview(imageView)
        view.addSubview(button)
        imageView.frame = CGRect(x: 0, y:0, width:300, height:300)
        imageView.center = view.center
        createRandomUIImage(width: 600, height: 600)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.frame = CGRect(x: 30, y: view.frame.size.height - 150 - view.safeAreaInsets.bottom, width: view.frame.size.width - 60, height: 55)
    }
    
    func getRandomPhoto() {
        let urlString = "https://source.unsplash.com/random/600x600"
        let url = URL(string: urlString)!
        guard let data = try? Data(contentsOf: url) else {
            return
        }
    }
    
    @objc func didTapButton() {
        createRandomUIImage(width: 600, height: 600)
        view.backgroundColor = colors.randomElement()
    }
    
    public struct PixelData {
            var a: UInt8
            var r: UInt8
            var g: UInt8
            var b: UInt8
        }

    func createRandomUIImage(width: Int, height: Int) {
            var pixels = [PixelData]()
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
            let bitsPerComponent = 8
            let bitsPerPixel = 32

            for _ in 0..<width {
                for _ in 0..<height {
                    pixels.append(PixelData(a: .random(in: 0...255), r: .random(in: 0...255), g: .random(in: 0...255), b: .random(in: 0...255)))
                }
            }

            guard let providerRef = CGDataProvider(data: NSData(bytes: &pixels,
                                    length: pixels.count * MemoryLayout<PixelData>.size)
                )
                else { return }

            guard let cgim = CGImage(
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bitsPerPixel: bitsPerPixel,
                bytesPerRow: width * MemoryLayout<PixelData>.size,
                space: rgbColorSpace,
                bitmapInfo: bitmapInfo,
                provider: providerRef,
                decode: nil,
                shouldInterpolate: true,
                intent: .defaultIntent
                )
                else { return }
            imageView.image = UIImage(cgImage: cgim)
        }


}

