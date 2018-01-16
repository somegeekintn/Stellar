//
//  PaymentOp.swift
//  Stellar
//
//  Created by Casey Fleser on 1/15/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation


// See https://raw.githubusercontent.com/stellar/js-stellar-base/master/src/generated/stellar-xdr_generated.js
//
//	xdr.struct("PaymentOp", [
//	  ["destination", xdr.lookup("AccountId")],
//	  ["asset", xdr.lookup("Asset")],
//	  ["amount", xdr.lookup("Int64")],
//	]);

class PaymentOp: XDRDecodable, CustomStringConvertible {
	let destination		: PublicKey
	let asset			: Asset
	let amount			: Int64

	var description		: String {
		return "dest: \(self.destination), asset: \(self.asset), amount: \(self.amount)"
	}
	
	required init?(xdr: ExDR, capacity: Int = 1) {
		guard let destination	= PublicKey(xdr: xdr) else { return nil }
		guard let asset			= Asset(xdr: xdr) else { return nil }
		guard let amount		= Int64(xdr: xdr) else { return nil }

		self.destination = destination
		self.asset = asset
		self.amount = amount
	}
}
