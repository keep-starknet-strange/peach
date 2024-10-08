use starknet::{ContractAddress, ClassHash};

#[derive(Copy, Drop, Serde, starknet::Store)]
pub struct TicketTierParams {
    pub price: u256,
    pub max_supply: u32,
}

#[derive(Copy, Drop, Serde, starknet::Store)]
pub struct TicketTier {
    pub params: TicketTierParams,
    pub supply: u32,
}

#[derive(Copy, Drop, Serde)]
pub struct PeachEvent {
    pub id: u64,
    pub ticket_tiers_params: Span<TicketTierParams>,
    pub treasury_address: ContractAddress,
}

#[starknet::interface]
pub trait IPeach<TState> {
    fn get_treasury_address(self: @TState, event_id: u64) -> Option<ContractAddress>;
    fn get_ticket_tier(self: @TState, event_id: u64, ticket_tier_id: u8) -> Option<TicketTier>;

    fn create_event(ref self: TState, event: PeachEvent);
    fn buy_ticket(ref self: TState, event_id: u64, ticket_tier_id: u8, recipient: ContractAddress, amount: u32);
}

#[starknet::interface]
pub trait PeachABI<TState> {
    // IPeach
    fn get_treasury_address(self: @TState, event_id: u64) -> Option<ContractAddress>;
    fn get_ticket_tier(self: @TState, event_id: u64, ticket_tier_id: u8) -> Option<TicketTier>;
    fn create_event(ref self: TState, event: PeachEvent);
    fn buy_ticket(ref self: TState, event_id: u64, ticket_tier_id: u8, recipient: ContractAddress, amount: u32);

    // IERC1155
    fn balance_of(self: @TState, account: ContractAddress, token_id: u256) -> u256;
    fn balance_of_batch(self: @TState, accounts: Span<ContractAddress>, token_ids: Span<u256>) -> Span<u256>;
    fn safe_transfer_from(
        ref self: TState, from: ContractAddress, to: ContractAddress, token_id: u256, value: u256, data: Span<felt252>
    );
    fn safe_batch_transfer_from(
        ref self: TState,
        from: ContractAddress,
        to: ContractAddress,
        token_ids: Span<u256>,
        values: Span<u256>,
        data: Span<felt252>
    );
    fn is_approved_for_all(self: @TState, owner: ContractAddress, operator: ContractAddress) -> bool;
    fn set_approval_for_all(ref self: TState, operator: ContractAddress, approved: bool);

    // ISRC5
    fn supports_interface(self: @TState, interface_id: felt252) -> bool;

    // IERC1155MetadataURI
    fn uri(self: @TState, token_id: u256) -> ByteArray;

    // IERC1155Camel
    fn balanceOf(self: @TState, account: ContractAddress, tokenId: u256) -> u256;
    fn balanceOfBatch(self: @TState, accounts: Span<ContractAddress>, tokenIds: Span<u256>) -> Span<u256>;
    fn safeTransferFrom(
        ref self: TState, from: ContractAddress, to: ContractAddress, tokenId: u256, value: u256, data: Span<felt252>
    );
    fn safeBatchTransferFrom(
        ref self: TState,
        from: ContractAddress,
        to: ContractAddress,
        tokenIds: Span<u256>,
        values: Span<u256>,
        data: Span<felt252>
    );
    fn isApprovedForAll(self: @TState, owner: ContractAddress, operator: ContractAddress) -> bool;
    fn setApprovalForAll(ref self: TState, operator: ContractAddress, approved: bool);

    // IOwnable
    fn owner(self: @TState) -> ContractAddress;
    fn transfer_ownership(ref self: TState, new_owner: ContractAddress);
    fn renounce_ownership(ref self: TState);

    // IOwnableCamelOnly
    fn transferOwnership(ref self: TState, newOwner: ContractAddress);
    fn renounceOwnership(ref self: TState);

    // IUpgradeable
    fn upgrade(ref self: TState, new_class_hash: ClassHash);
}
