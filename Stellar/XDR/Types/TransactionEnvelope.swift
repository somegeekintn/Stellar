//
//  TransactionEnvelope.swift
//  Stellar
//
//  Created by Casey Fleser on 1/15/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation


// See https://raw.githubusercontent.com/stellar/js-stellar-base/master/src/generated/stellar-xdr_generated.js
//
//	xdr.struct("TransactionEnvelope", [
//	  ["tx", xdr.lookup("Transaction")],
//	  ["signatures", xdr.varArray(xdr.lookup("DecoratedSignature"), 20)],
//	]);

class TransactionEnvelope: XDRDecodable, CustomStringConvertible {
	let tx			: Transaction
	let signatures	: [DecoratedSignature]

	var description	: String {
		return "TransactionEnvelope\n\ttx: \(self.tx)\n\tsignatures: \(self.signatures)"
	}
	
	required init?(xdr: ExDR, capacity: Int = 1) {
		guard let tx			= Transaction(xdr: xdr) else { return nil }
		guard let signatures	= [DecoratedSignature](xdr: xdr, capacity: 20) else { return nil }

		self.tx = tx
		self.signatures = signatures
	}
}

