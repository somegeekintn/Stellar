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
		let blob = "AAAAAJ2kP2xLaOVLj6DRwX1mMyA0mubYnYvu0g8OdoDqxXuFAAAAZADjfzAAASnUAAAAAAAAAAEAAAATYTVkZmNjYWFjYjZhNGE2N2IxNgAAAAABAAAAAAAAAAEAAAAAfYea3UlYx+oB1SUN7JS071XzM+onRosbwqtnJe/vxAYAAAAAAAAAC+p8h7AAAAAAAAAAAerFe4UAAABAKDztNBWHiXL568wCEcJUaxPbCX0Ixz3E8oJ2FojVe2x/nxlcEAFS6CfFuFI4aNZK26Fefa+b9NY5g1BZO/WyCQ=="

		if let base64Data = Data(base64Encoded: blob) {
			let exdr = ExDR(data: base64Data)
			
//			if let tx = Transaction(xdr: exdr) {
//				print("tx: \(tx)")
//			}
			if let txEnv = TransactionEnvelope(xdr: exdr) {
				print("txEnv: \(txEnv)")
			}
		}
	}
}

