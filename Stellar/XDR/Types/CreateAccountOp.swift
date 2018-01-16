//
//  CreateAccountOp.swift
//  Stellar
//
//  Created by Casey Fleser on 1/15/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation


// See https://raw.githubusercontent.com/stellar/js-stellar-base/master/src/generated/stellar-xdr_generated.js
//
//	xdr.struct("CreateAccountOp", [
//	  ["destination", xdr.lookup("AccountId")],
//	  ["startingBalance", xdr.lookup("Int64")],
//	]);

class CreateAccountOp: XDRDecodable, CustomStringConvertible {
	let destination		: PublicKey
	let startingBalance	: Int64

	var description		: String {
		return "destination: \(self.destination), startingBalance: \(self.startingBalance))"
	}
	
	required init?(xdr: ExDR, capacity: Int = 1) {
		guard let destination		= PublicKey(xdr: xdr) else { return nil }
		guard let startingBalance	= Int64(xdr: xdr) else { return nil }

		self.destination = destination
		self.startingBalance = startingBalance
	}
}
