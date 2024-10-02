#[starknet::interface]
trait IPeach<TContractState> {
    fn get_version(self: @TContractState) -> felt252;
}

#[starknet::contract]
mod Peach {
    #[storage]
    struct Storage {
        balance: felt252,
    }

    #[abi(embed_v0)]
    impl PeachImpl of super::IPeach<ContractState> {
        fn get_version(self: @ContractState) -> felt252 {
            1
        }
    }
}
