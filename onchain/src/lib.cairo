#[starknet::interface]
trait IVenuela<TContractState> {
    fn get_version(self: @TContractState) -> felt252;
}

#[starknet::contract]
mod Venuela {
    #[storage]
    struct Storage {
        balance: felt252,
    }

    #[abi(embed_v0)]
    impl VenuelaImpl of super::IVenuela<ContractState> {
        fn get_version(self: @ContractState) -> felt252 {
            1
        }
    }
}
