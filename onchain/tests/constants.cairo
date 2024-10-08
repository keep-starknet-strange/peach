use peach::contracts::peach::interface::{PeachEvent, TicketTierParams};
use starknet::{ContractAddress, contract_address_const};

pub fn CALLER() -> ContractAddress {
    contract_address_const::<'caller'>()
}

pub fn SPENDER() -> ContractAddress {
    contract_address_const::<'spender'>()
}

pub fn RECIPIENT() -> ContractAddress {
    contract_address_const::<'recipient'>()
}

pub fn OWNER() -> ContractAddress {
    contract_address_const::<'owner'>()
}

pub fn OTHER() -> ContractAddress {
    contract_address_const::<'other'>()
}

pub fn TREASURY_1() -> ContractAddress {
    contract_address_const::<'treasury1'>()
}

pub const SUPPLY: u256 = 1_000_000_000_000_000_000; // 1 ETH

pub fn NAME() -> ByteArray {
    "NAME"
}

pub fn SYMBOL() -> ByteArray {
    "SYMBOL"
}

pub fn BASE_URI() -> ByteArray {
    "peach.fm"
}

pub fn TICKET_TIERS_PARAMS_GOLD() -> TicketTierParams {
    TicketTierParams { price: 100, max_supply: 1, }
}

pub fn TICKET_TIERS_PARAMS_SILVER() -> TicketTierParams {
    TicketTierParams { price: 10, max_supply: 10, }
}

pub fn TICKET_TIERS_PARAMS_BRONZE() -> TicketTierParams {
    TicketTierParams { price: 1, max_supply: 100, }
}

pub fn EVENT_1() -> PeachEvent {
    PeachEvent {
        id: 1,
        ticket_tiers_params: array![
            TICKET_TIERS_PARAMS_GOLD(), TICKET_TIERS_PARAMS_SILVER(), TICKET_TIERS_PARAMS_BRONZE()
        ]
            .span(),
        treasury_address: TREASURY_1(),
    }
}
