#[starknet::contract]
pub mod Peach {
    use core::num::traits::Zero;
    use openzeppelin_access::ownable::OwnableComponent;
    use openzeppelin_introspection::src5::SRC5Component;
    use openzeppelin_token::erc1155::{ERC1155Component, ERC1155HooksEmptyImpl};
    use openzeppelin_token::erc20::{ERC20ABIDispatcher, ERC20ABIDispatcherTrait};
    use openzeppelin_upgrades::UpgradeableComponent;
    use openzeppelin_upgrades::interface::IUpgradeable;
    use peach::contracts::peach::interface::{IPeach, PeachEvent, TicketTier};
    use peach::utils::validable::Validable;
    use starknet::storage::{
        Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePointerReadAccess, StoragePointerWriteAccess
    };
    use starknet::{get_caller_address, ContractAddress, ClassHash};

    //
    // Components
    //

    component!(path: ERC1155Component, storage: erc1155, event: ERC1155Event);
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);
    component!(path: UpgradeableComponent, storage: upgradeable, event: UpgradeableEvent);

    // Ownable
    #[abi(embed_v0)]
    impl OwnableMixinImpl = OwnableComponent::OwnableMixinImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    // ERC1155 Mixin
    #[abi(embed_v0)]
    impl ERC1155MixinImpl = ERC1155Component::ERC1155MixinImpl<ContractState>;
    impl ERC1155InternalImpl = ERC1155Component::InternalImpl<ContractState>;

    // Upgradeable
    impl UpgradeableInternalImpl = UpgradeableComponent::InternalImpl<ContractState>;

    //
    // Storage
    //

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        erc1155: ERC1155Component::Storage,
        #[substorage(v0)]
        src5: SRC5Component::Storage,
        #[substorage(v0)]
        upgradeable: UpgradeableComponent::Storage,
        // (event_id, tier_id) -> ticket_tier
        ticket_tiers: Map<(u64, u8), Option<TicketTier>>,
        // event_id -> treasury_address
        events_treasury_addresses: Map<u64, Option<ContractAddress>>,
        // currencty token
        currency_token: ERC20ABIDispatcher,
    }

    //
    // Errors
    //

    pub mod Errors {
        pub const INVALID_EVENT: felt252 = 'Event is not valid';
        pub const NULL_AMOUNT: felt252 = 'Amount cannot be null';
        pub const TICKET_TIER_NOT_FOUND: felt252 = 'Ticket tier not found';
        pub const NOT_ENOUGH_TICKETS_LEFT: felt252 = 'Not enough tickets left';
    }

    //
    // Events
    //

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        #[flat]
        ERC1155Event: ERC1155Component::Event,
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        #[flat]
        SRC5Event: SRC5Component::Event,
        #[flat]
        UpgradeableEvent: UpgradeableComponent::Event,
        EventCreated: EventCreated,
        TicketPurchased: TicketPurchased,
    }

    // Emitted on event creation
    #[derive(Drop, starknet::Event)]
    pub struct EventCreated {
        #[key]
        pub id: u64,
    }

    // Emitted on ticket purchase
    #[derive(Drop, starknet::Event)]
    pub struct TicketPurchased {
        #[key]
        pub event_id: u64,
        #[key]
        pub ticket_tier_id: u8,
        pub buyer_address: ContractAddress,
        pub recipient: ContractAddress,
        pub amount: u32,
    }

    //
    // Constructor
    //

    #[constructor]
    fn constructor(
        ref self: ContractState, owner: ContractAddress, base_uri: ByteArray, currency_token: ContractAddress
    ) {
        // init owner
        self.ownable.initializer(:owner);

        // init erc1155
        self.erc1155.initializer(base_uri);

        // init contract
        self.initializer(:currency_token);
    }

    //
    // Peach impl
    //

    #[abi(embed_v0)]
    impl PeachImpl of IPeach<ContractState> {
        fn get_treasury_address(self: @ContractState, event_id: u64) -> Option<ContractAddress> {
            self.events_treasury_addresses.read(event_id)
        }

        fn get_ticket_tier(self: @ContractState, event_id: u64, ticket_tier_id: u8) -> Option<TicketTier> {
            self.ticket_tiers.read((event_id, ticket_tier_id))
        }

        fn create_event(ref self: ContractState, event: PeachEvent) {
            // Check: owner only
            self.ownable.assert_only_owner();

            // Check: verify event validity
            assert(event.is_valid(), Errors::INVALID_EVENT);

            // Effects: store tickets tiers
            let mut tier_id: u8 = 0;

            for ticket_tier_param in event
                .ticket_tiers_params {
                    self
                        .ticket_tiers
                        .write((event.id, tier_id), Option::Some(TicketTier { params: *ticket_tier_param, supply: 0 }));
                    tier_id += 1;
                };

            // Effects: store treasury address
            self.events_treasury_addresses.write(event.id, Option::Some(event.treasury_address));

            // Log event creation
            self.emit(EventCreated { id: event.id });
        }

        fn buy_ticket(
            ref self: ContractState, event_id: u64, ticket_tier_id: u8, recipient: ContractAddress, amount: u32
        ) {
            // Checks: amount not null
            assert(amount.is_non_zero(), Errors::NULL_AMOUNT);

            // Checks: ticket tier exists
            let mut ticket_tier = self
                .get_ticket_tier(:event_id, :ticket_tier_id)
                .expect(Errors::TICKET_TIER_NOT_FOUND);

            // Checks: ticket tier supply
            assert(ticket_tier.supply + amount <= ticket_tier.params.max_supply, Errors::NOT_ENOUGH_TICKETS_LEFT);

            // Effects: update supply
            ticket_tier.supply += amount;
            self.ticket_tiers.write((event_id, ticket_tier_id), Option::Some(ticket_tier));

            // Effects: mint tickets
            let token_id = u256 { low: event_id.into(), high: ticket_tier_id.into() };
            self
                .erc1155
                .mint_with_acceptance_check(to: recipient, :token_id, value: amount.into(), data: array![].span());

            // Interaction: spend currency token
            let currency_token = self.currency_token.read();
            let caller = get_caller_address();
            // safe to unwrap due to ticket tier existance check
            let treasury_address = self.get_treasury_address(:event_id).unwrap();

            currency_token.transfer_from(sender: caller, recipient: treasury_address, amount: ticket_tier.params.price);

            // Log event creation
            self.emit(TicketPurchased { event_id, ticket_tier_id, buyer_address: caller, recipient, amount });
        }
    }

    //
    // Upgradeable impl
    //

    #[abi(embed_v0)]
    impl UpgradeableImpl of IUpgradeable<ContractState> {
        /// Upgrades the contract class hash to `new_class_hash`.
        /// This may only be called by the contract owner.
        fn upgrade(ref self: ContractState, new_class_hash: ClassHash) {
            self.ownable.assert_only_owner();
            self.upgradeable.upgrade(new_class_hash);
        }
    }

    //
    // Internals
    //

    #[generate_trait]
    pub impl InternalImpl of InternalTrait {
        fn initializer(ref self: ContractState, currency_token: ContractAddress) {
            self.currency_token.write(ERC20ABIDispatcher { contract_address: currency_token });
        }
    }
}
