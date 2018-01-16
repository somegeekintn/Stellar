//
//  DecoratedSignature.swift
//  Stellar
//
//  Created by Casey Fleser on 1/15/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation


// See https://raw.githubusercontent.com/stellar/js-stellar-base/master/src/generated/stellar-xdr_generated.js
//
//	xdr.struct("DecoratedSignature", [
//	  ["hint", xdr.lookup("SignatureHint")],
//	  ["signature", xdr.lookup("Signature")],
//	]);
//
//	xdr.typedef("Signature", xdr.varOpaque(64));
//
//	xdr.typedef("SignatureHint", xdr.opaque(4));

class DecoratedSignature: XDRDecodable, CustomStringConvertible {
	let hint		: String
	let signature	: String

	var description	: String {
		return "hint: \(self.hint), signature: \(self.signature)"
	}
	
	required init?(xdr: ExDR, capacity: Int = 1) {
		guard let hintBytes		= xdr.decodeBytes(4) else { return nil }
		guard let sigBytes		= xdr.decodeBytes(64, variable: true) else { return nil }
		var hintEncodeBytes	= [Int8](repeating: 0, count: 32)

		hintEncodeBytes.replaceSubrange(28..<32, with: hintBytes)
		hintEncodeBytes.insert(6 << 3, at: 0)

		self.hint = String(Base32Encode(data: Data(bytes: hintEncodeBytes, count: hintEncodeBytes.count)).suffix(9).prefix(5))
		self.signature = Data(bytes: sigBytes, count: sigBytes.count).base64EncodedString()
	}
}

