//
//  ViewController.swift
//  ImageProcessor
//
//  Created by Mark Hoggatt on 30/03/2018.
//  Copyright © 2018 Code Europa. All rights reserved.
//

import Cocoa

class ViewController: NSViewController
{
	@IBOutlet weak var targetImage: NSImageView!

	override func viewDidLoad()
	{
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let openDialogue = NSOpenPanel()
		openDialogue.prompt = "Load Image"
		openDialogue.canChooseFiles = true
		openDialogue.canChooseDirectories = false
		openDialogue.allowedFileTypes = ["jpg"]
		let fileResponse : NSApplication.ModalResponse = openDialogue.runModal()
		let fileUrl : URL?
		switch fileResponse
		{
		case .continue, .OK:
			fileUrl = openDialogue.urls[0]
		default:
			fileUrl = nil
		}

		guard let imgUrl : URL = fileUrl
			else
		{
			return
		}

		guard let uncorrectedImg = CIImage(contentsOf: imgUrl)
		else
		{
			return
		}

		let currentOrientation = uncorrectedImg.properties["Orientation"] as! Int32
		let img = uncorrectedImg.oriented(forExifOrientation: currentOrientation)
		let treatedImg = NSImage(size: img.extent.size)
		let treatedRect = NSRectFromCGRect(img.extent)
		treatedImg.lockFocus()
		img.draw(at: NSZeroPoint, from: treatedRect, operation: .copy, fraction: 1.0)
		treatedImg.unlockFocus()

		targetImage.image = treatedImg
	}

	override var representedObject: Any?
	{
		didSet
		{
		// Update the view, if already loaded.
		}
	}
}
