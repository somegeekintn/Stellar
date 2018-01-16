//
//  Price.swift
//  Stellar
//
//  Created by Casey Fleser on 1/15/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation


// See https://raw.githubusercontent.com/stellar/js-stellar-base/master/src/generated/stellar-xdr_generated.js
//
//	xdr.struct("Price", [
//	  ["n", xdr.lookup("Int32")],
//	  ["d", xdr.lookup("Int32")],
//	]);

class Price: XDRDecodable, CustomStringConvertible {
	let n				: Int32
	let d				: Int32

	var description		: String {
		return "n: \(self.n), d: \(self.d)"
	}
	
	required init?(xdr: ExDR, capacity: Int = 1) {
		guard let n		= Int32(xdr: xdr) else { return nil }
		guard let d		= Int32(xdr: xdr) else { return nil }

		self.n = n
		self.d = d
	}
}


