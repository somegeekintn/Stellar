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
		if let base64Data = Data(base64Encoded: XDRTestData.setOptions.blob) {
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

