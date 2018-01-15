//
//  TimeBounds.swift
//  Stellar
//
//  Created by Casey Fleser on 1/14/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation


// See https://raw.githubusercontent.com/stellar/js-stellar-base/master/src/generated/stellar-xdr_generated.js
//
//	xdr.struct("TimeBounds", [
//	  ["minTime", xdr.lookup("Uint64")],
//	  ["maxTime", xdr.lookup("Uint64")],
//	]);

class TimeBounds: XDRDecodable {
	let minTime		: UInt64
	let maxTime		: UInt64
	
	required init?(xdr: ExDR) {
		guard let minTime = UInt64(xdr: xdr) else { return nil }
		guard let maxTime = UInt64(xdr: xdr) else { return nil }

		self.minTime = minTime
		self.maxTime = maxTime
	}
}
