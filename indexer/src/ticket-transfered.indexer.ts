import {
	SN_CHAIN_ID,
	STREAM_URLS,
	STARTING_BLOCK,
	BALANCES_VAR_NAMES,
	PEACH_CORE_ADDRESSES,
	TRANSFER_SINGLE,
	TRANSFER_BATCH,
} from "./constants.ts";
import { Block, hash, uint256 } from "./deps.ts";
import { getStorageLocation } from "./utils.ts";

const filter = {
	header: {
		weak: true,
	},
	events: [
		{
			fromAddress: PEACH_CORE_ADDRESSES[SN_CHAIN_ID],
			keys: [TRANSFER_SINGLE],
			includeReceipt: false,
		},
	],
	stateUpdate: {
		storageDiffs: [{ contractAddress: PEACH_CORE_ADDRESSES[SN_CHAIN_ID] }],
	},
};

const streamUrl = STREAM_URLS[SN_CHAIN_ID];
const startingBlock = STARTING_BLOCK;

export const config = {
	streamUrl,
	startingBlock,
	network: "starknet",
	finality: "DATA_STATUS_PENDING",
	filter,
	sinkType: "postgres",
	sinkOptions: {
		tableName: "tickets",
	},
};

function getBalance(
	storageMap: Map<bigint, bigint>,
	address: string,
	eventId: string,
	ticketTierId: string,
): bigint {
	const addressBalanceLocation = getStorageLocation(
		address,
		BALANCES_VAR_NAMES,
		eventId,
		ticketTierId,
	);

	const addressBalanceLow = storageMap.get(addressBalanceLocation);
	const addressBalanceHigh = storageMap.get(addressBalanceLocation + 1n);

	return uint256.uint256ToBN({
		low: addressBalanceLow ?? 0n,
		high: addressBalanceHigh ?? 0n,
	});
}

export default function decodeUSDCTransfers({
	header,
	events,
	stateUpdate,
}: Block) {
	const { blockNumber, blockHash, timestamp } = header!;

	// Step 2: collect balances for each address.
	const storageMap = new Map<bigint, bigint>();
	const storageDiffs = stateUpdate?.stateDiff?.storageDiffs ?? [];

	for (const storageDiff of storageDiffs) {
		for (const storageEntry of storageDiff.storageEntries ?? []) {
			if (!storageEntry.key || !storageEntry.value) {
				continue;
			}

			const key = BigInt(storageEntry.key);
			const value = BigInt(storageEntry.value);

			storageMap.set(key, value);
		}
	}

	// Setp 3: aggregate everyting
	return (events ?? [])
		.map(({ event, transaction }) => {
			if (!event.data) return null;

			const transactionHash = transaction.meta.hash;
			const transferId = `${transactionHash}_${event.index ?? 0}`;
			const IndexInBlock =
				(transaction.meta.transactionIndex ?? 0) * 1_000 + (event.index ?? 0);

			const [_eventName, _operator, from, to] = event.keys;
			const [eventId, ticketTierId, _amountLow, _amountHigh] = event.data;
			const senderBalance = getBalance(storageMap, from, eventId, ticketTierId);
			const recipientBalance = getBalance(
				storageMap,
				to,
				eventId,
				ticketTierId,
			);

			return [
				{
					block_hash: blockHash,
					block_number: +(blockNumber ?? 0),
					block_timestamp: timestamp,
					transaction_hash: transactionHash,
					id: transferId + "_from",
					index_in_block: IndexInBlock,
					event_id: eventId,
					ticket_tier_id: ticketTierId,
					owner: from,
					balance: senderBalance.toString(),
					created_at: new Date().toISOString(),
				},
				{
					block_hash: blockHash,
					block_number: +(blockNumber ?? 0),
					block_timestamp: timestamp,
					transaction_hash: transactionHash,
					id: transferId + "_to",
					index_in_block: IndexInBlock,
					event_id: eventId,
					ticket_tier_id: ticketTierId,
					owner: to,
					balance: recipientBalance.toString(),
					created_at: new Date().toISOString(),
				},
			];
		})
		.flat()
		.filter(Boolean);
}
