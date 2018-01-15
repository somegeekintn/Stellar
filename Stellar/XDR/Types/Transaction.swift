//
//  Transaction.swift
//  Stellar
//
//  Created by Casey Fleser on 1/14/18.
//  Copyright © 2018 Quiet Spark. All rights reserved.
//

import Foundation


// See https://raw.githubusercontent.com/stellar/js-stellar-base/master/src/generated/stellar-xdr_generated.js
//
//	xdr.struct("Transaction", [
//	  ["sourceAccount", xdr.lookup("AccountId")],
//	  ["fee", xdr.lookup("Uint32")],
//	  ["seqNum", xdr.lookup("SequenceNumber")],
//	  ["timeBounds", xdr.option(xdr.lookup("TimeBounds"))],
//	  ["memo", xdr.lookup("Memo")],
//	  ["operations", xdr.varArray(xdr.lookup("Operation"), 100)],
//	  ["ext", xdr.lookup("TransactionExt")],
//	]);
//
//	xdr.union("TransactionExt", {
//	  switchOn: xdr.int(),
//	  switchName: "v",
//	  switches: [
//		[0, xdr.void()],
//	  ],
//	  arms: {
//	  },
//	});

class Transaction: XDRDecodable, CustomStringConvertible {
	let accountID	: PublicKey
	let fee			: UInt32
	let seqNum		: UInt64
	let timeBounds	: TimeBounds?
	let memo		: Memo
	let operations	: [Operation]

	var description	: String {
		var desc		= "Transaction: "
		
		desc.append("\n\taccountID: \(self.accountID)")
		desc.append("\n\tfee: \(self.fee)")
		desc.append("\n\tseqNum: \(self.seqNum)")
		desc.append("\n\ttimeBounds: \(self.timeBounds.map({ "\($0)" }) ?? "none")")
		desc.append("\n\tmemo: \(self.memo)")
		desc.append("\n\toperations: \(self.operations)")

		return desc
	}
	
	required init?(xdr: ExDR) {
		guard let accountID		= PublicKey(xdr: xdr) else { return nil }
		guard let fee			= UInt32(xdr: xdr) else { return nil }
		guard let seqNum		= UInt64(xdr: xdr) else { return nil }
		guard let timeBounds	= TimeBounds?(xdr: xdr) else { return nil }
		guard let memo			= Memo(xdr: xdr) else { return nil }
		guard let operations	= [Operation](xdr: xdr, capacity: 100) else { return nil }
		guard Int32(xdr: xdr) != nil else { return nil }	// TransactionExt unused

		self.accountID = accountID
		self.fee = fee
		self.seqNum = seqNum
		self.timeBounds = timeBounds
		self.memo = memo
		self.operations = operations
	}
}
