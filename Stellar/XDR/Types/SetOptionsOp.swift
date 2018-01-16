//
//  SetOptionsOp.swift
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
//	xdr.struct("SetOptionsOp", [
//	  ["inflationDest", xdr.option(xdr.lookup("AccountId"))],
//	  ["clearFlags", xdr.option(xdr.lookup("Uint32"))],
//	  ["setFlags", xdr.option(xdr.lookup("Uint32"))],
//	  ["masterWeight", xdr.option(xdr.lookup("Uint32"))],
//	  ["lowThreshold", xdr.option(xdr.lookup("Uint32"))],
//	  ["medThreshold", xdr.option(xdr.lookup("Uint32"))],
//	  ["highThreshold", xdr.option(xdr.lookup("Uint32"))],
//	  ["homeDomain", xdr.option(xdr.lookup("String32"))],
//	  ["signer", xdr.option(xdr.lookup("Signer"))],
//	]);

class SetOptionsOp: XDRDecodable, CustomStringConvertible {
	let inflationDest	: PublicKey?
	let clearFlags		: UInt32?
	let setFlags		: UInt32?
	let masterWeight	: UInt32?
	let lowThreshold	: UInt32?
	let medThreshold	: UInt32?
	let highThreshold	: UInt32?
	let homeDomain		: String?
	let signer			: Signer?

	var description		: String {
		var optionDesc	= [String]()
		
		optionDesc.append("inflationDest: \(self.inflationDest.map({ "\($0)" }) ?? "none")")
		optionDesc.append("clearFlags: \(self.clearFlags.map({ "\($0)" }) ?? "none")")
		optionDesc.append("setFlags: \(self.setFlags.map({ "\($0)" }) ?? "none")")
		optionDesc.append("masterWeight: \(self.masterWeight.map({ "\($0)" }) ?? "none")")
		optionDesc.append("lowThreshold: \(self.lowThreshold.map({ "\($0)" }) ?? "none")")
		optionDesc.append("medThreshold: \(self.medThreshold.map({ "\($0)" }) ?? "none")")
		optionDesc.append("highThreshold: \(self.highThreshold.map({ "\($0)" }) ?? "none")")
		optionDesc.append("homeDomain: \(self.homeDomain.map({ "\($0)" }) ?? "none")")
		optionDesc.append("signer: \(self.signer.map({ "\($0)" }) ?? "none")")

		return optionDesc.joined(separator: ", ")
	}
	
	required init?(xdr: ExDR, capacity: Int = 1) {
		guard let inflationDest	= PublicKey?(xdr: xdr) else { return nil }
		guard let clearFlags	= UInt32?(xdr: xdr) else { return nil }
		guard let setFlags		= UInt32?(xdr: xdr) else { return nil }
		guard let masterWeight	= UInt32?(xdr: xdr) else { return nil }
		guard let lowThreshold	= UInt32?(xdr: xdr) else { return nil }
		guard let medThreshold	= UInt32?(xdr: xdr) else { return nil }
		guard let highThreshold	= UInt32?(xdr: xdr) else { return nil }
		guard let homeDomain	= String?(xdr: xdr, capacity: 32) else { return nil }
		guard let signer		= Signer?(xdr: xdr) else { return nil }

		self.inflationDest = inflationDest
		self.clearFlags = clearFlags
		self.setFlags = setFlags
		self.masterWeight = masterWeight
		self.lowThreshold = lowThreshold
		self.medThreshold = medThreshold
		self.highThreshold = highThreshold
		self.homeDomain = homeDomain
		self.signer = signer
	}
}

