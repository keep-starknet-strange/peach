import {
	SN_CHAIN_ID,
	STREAM_URLS,
	STARTING_BLOCK,
	PEACH_CORE_ADDRESSES,
} from "./constants.ts";
import { Block, hash } from "./deps.ts";

const filter = {
	header: {
		weak: true,
	},
	events: [
		{
			fromAddress: PEACH_CORE_ADDRESSES[SN_CHAIN_ID],
			keys: [hash.getSelectorFromName("EventCreated")],
			includeReceipt: false,
		},
	],
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
		tableName: "onchain_events",
	},
};

export default function decodeEvent({ events }: Block) {
	return (events ?? [])
		.map(({ event, transaction }) => {
			if (!event.data) return null;

			const [event_id] = event.data;
			return {
				id: `${transaction.meta.hash}_${event.index ?? 0}`,
				event_id: event_id,
				onchain: true,
			};
		})
		.filter(Boolean);
}
