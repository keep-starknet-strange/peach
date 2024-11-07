import { constants, hash } from "./deps.ts";

export const STORAGE_ADDRESS_BOUND = 2n ** 251n;

type SupportedChainId = Exclude<
	constants.StarknetChainId,
	typeof constants.StarknetChainId.SN_GOERLI
>;

type AddressesMap = Record<SupportedChainId, string>;

export const PEACH_CORE_ADDRESSES: AddressesMap = {
	[constants.StarknetChainId.SN_MAIN]: "0x0",
	[constants.StarknetChainId.SN_SEPOLIA]:
		"0x3ebf879e7e4e64c72370efceeb478e3e0f320d4df669ea32acb25a692d6409f",
};
export const TRANSFER_SINGLE: string =
	hash.getSelectorFromName("TransferSingle");
export const TRANSFER_BATCH: string = hash.getSelectorFromName("TransferBatch");

const DEFAULT_NETWORK_NAME = constants.NetworkName.SN_SEPOLIA;

export const SN_CHAIN_ID = (constants.StarknetChainId[
	(Deno.env.get("SN_NETWORK") ?? "") as constants.NetworkName
] ?? constants.StarknetChainId[DEFAULT_NETWORK_NAME]) as SupportedChainId;

export const STREAM_URLS = {
	[constants.StarknetChainId.SN_MAIN]: "https://mainnet.starknet.a5a.ch",
	[constants.StarknetChainId.SN_SEPOLIA]: "https://sepolia.starknet.a5a.ch",
};

export const STARTING_BLOCK = Number(Deno.env.get("STARTING_BLOCK")) ?? 0;

export const BALANCES_VAR_NAMES = "ERC1155_balances";
