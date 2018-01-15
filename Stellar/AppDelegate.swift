//
//  AppDelegate.swift
//  Stellar
//
//  Created by Casey Fleser on 1/14/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		self.xdrTest()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func xdrTest() {
//		let payment = "AAAAAJ2kP2xLaOVLj6DRwX1mMyA0mubYnYvu0g8OdoDqxXuFAAAAZADjfzAAASnUAAAAAAAAAAEAAAATYTVkZmNjYWFjYjZhNGE2N2IxNgAAAAABAAAAAAAAAAEAAAAAfYea3UlYx+oB1SUN7JS071XzM+onRosbwqtnJe/vxAYAAAAAAAAAC+p8h7AAAAAAAAAAAerFe4UAAABAKDztNBWHiXL568wCEcJUaxPbCX0Ixz3E8oJ2FojVe2x/nxlcEAFS6CfFuFI4aNZK26Fefa+b9NY5g1BZO/WyCQ=="
//		let manageOffer = "AAAAALRKCRGI5VZM3UG3f7U5faC7sTG9fRJQBdgW5WjPX4wvAAAAZACa35wAAH5BAAAAAAAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAUNOWQAAAAAAIkIugebRE9iAkIoVqPSIjMOTqC+vInyXGsAsHNE7ObgAAAAAFUo4PAAAEUEAAAPoAAAAAAAAAAAAAAAAAAAAAc9fjC8AAABAejsy2hf/T2ywYNZZVRI+tQ9G3o9Ox6rHHhd8DbB/+3CJzWcJ4/yK3Aaw1VqDbO0xr2tzV7jljjFnzkASwCGpBg=="
		let paymentAndOffer = "AAAAAKzv9/fXSZ4/MYBFIgr3eQQz4v5utp4WxVIo5Jik+yY6AAAAyADuV5gAAADTAAAAAAAAAAAAAAACAAAAAQAAAABaSx+NQbFWAINd6rBR6+Ysqe86VFfDq56LYSyxpI7pnQAAAAEAAAAA87a2hY9uVFDaIHqRPGCi6fM2zcIWvwuZJhEWYgmH3CMAAAAAAAAAAABMS0AAAAABAAAAAPO2toWPblRQ2iB6kTxgounzNs3CFr8LmSYRFmIJh9wjAAAAAwAAAAFYTE0AAAAAAGU4n5B07NlUHicOUkSTvzK5R2JFArV8F8IRr/3lSLgQAAAAAUVUSAAAAAAAZTifkHTs2VQeJw5SRJO/MrlHYkUCtXwXwhGv/eVIuBAAAAACEUoMAAAAASMACYloAAAAAAAAAAAAAAAAAAAAA6SO6Z0AAABAWhL5e4sXIJrXOxkSN6uTBdhWVsSxJCRa08rshMYz7tlf1d705BfvjJDGtQVQHRCILqg0zSqe4OOYeWDc40ncCAmH3CMAAABAlCudwa7+d0oaLjZy/lw4C+Ui6wu5dkYrgyEW0DGMVhgNOREnLLVElIgQ0iU0M+iTNvy/ceHI2VZ3qdsm2+SHDlEiycMAAABAH8sQw/6zfyI1XphRsotSx96uFptUI3C7NoQIJ9n5lEaGQjbUYn7NHRjHMY+8cL7YjgB/FWTrzagpylHd6ewnBQ=="
		if let base64Data = Data(base64Encoded: paymentAndOffer) {
			let exdr = ExDR(data: base64Data)
			
			if let txEnv = TransactionEnvelope(xdr: exdr) {
				print("txEnv: \(txEnv)")
			}
			else {
				print("txEnv failed")
			}
		}
	}
}

