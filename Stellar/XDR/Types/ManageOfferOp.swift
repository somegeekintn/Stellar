//
//  ManageOfferOp.swift
//  Stellar
//
//  Created by Casey Fleser on 1/15/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation


// See https://raw.githubusercontent.com/stellar/js-stellar-base/master/src/generated/stellar-xdr_generated.js
//
//	xdr.struct("ManageOfferOp", [
//	  ["selling", xdr.lookup("Asset")],
//	  ["buying", xdr.lookup("Asset")],
//	  ["amount", xdr.lookup("Int64")],
//	  ["price", xdr.lookup("Price")],
//	  ["offerId", xdr.lookup("Uint64")],
//	]);

class ManageOfferOp: XDRDecodable, CustomStringConvertible {
	let selling			: Asset
	let buying			: Asset
	let amount			: Int64
	let price			: Price
	let offerId			: UInt64

	var description		: String {
		return "selling: \(self.selling), buying: \(self.buying), amount: \(self.amount), price: \(self.price), offerId: \(self.offerId))"
	}
	
	required init?(xdr: ExDR) {
		guard let selling		= Asset(xdr: xdr) else { return nil }
		guard let buying		= Asset(xdr: xdr) else { return nil }
		guard let amount		= Int64(xdr: xdr) else { return nil }
		guard let price			= Price(xdr: xdr) else { return nil }
		guard let offerId		= UInt64(xdr: xdr) else { return nil }

		self.selling = selling
		self.buying = buying
		self.amount = amount
		self.price = price
		self.offerId = offerId
	}
}

