//
//  ManageDataOp.swift
//  Stellar
//
//  Created by Casey Fleser on 1/15/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation


// See https://raw.githubusercontent.com/stellar/js-stellar-base/master/src/generated/stellar-xdr_generated.js
//
//	xdr.typedef("DataValue", xdr.varOpaque(64));
//
//	xdr.struct("ManageDataOp", [
//	  ["dataName", xdr.lookup("String64")],
//	  ["dataValue", xdr.option(xdr.lookup("DataValue"))],
//	]);

class ManageDataOp: XDRDecodable, CustomStringConvertible {
	let dataName		: String
	let dataValue		: String?

	var description		: String {
		return "dataName: \(self.dataName), dataValue: \(self.dataValue ?? "nil"))"
	}
	
	required init?(xdr: ExDR, capacity: Int = 1) {
		guard let dataName		= String(xdr: xdr, capacity: 24) else { return nil }
		guard let hasValue		= Bool(xdr: xdr) else { return nil }
		
		self.dataName = dataName
		if hasValue {
			guard let valueBytes = xdr.decodeBytes(64, variable: true) else { return nil }
			
			self.dataValue = Data(bytes: valueBytes, count: valueBytes.count).base64EncodedString()
		}
		else {
			self.dataValue = nil
		}
	}
}

