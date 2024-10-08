use core::starknet::ContractAddress;
use openzeppelin::presets::interfaces::{ERC20UpgradeableABIDispatcher};
use openzeppelin::utils::serde::SerializedAppend;
use peach::contracts::peach::interface::{PeachABIDispatcher, PeachABIDispatcherTrait};
use snforge_std::{declare, DeclareResultTrait, ContractClassTrait, start_cheat_caller_address};
use super::{constants, utils};

fn setup_peach(erc20_contract_address: ContractAddress) -> PeachABIDispatcher {
    // declare Peach contract
    let peach_contract_class = declare("Peach").unwrap().contract_class();

    // deploy peach
    let mut calldata = array![];

    calldata.append_serde(constants::OWNER());
    calldata.append_serde(constants::BASE_URI());
    calldata.append_serde(erc20_contract_address);

    let (contract_address, _) = peach_contract_class.deploy(@calldata).unwrap();

    PeachABIDispatcher { contract_address }
}

fn setup() -> (PeachABIDispatcher, ERC20UpgradeableABIDispatcher) {
    // deploy an ERC20
    let erc20 = utils::setup_erc20(constants::OWNER());

    // deploy peach
    let peach = setup_peach(erc20.contract_address);

    (peach, erc20)
}

#[test]
fn test_create_event() {
    let (peach, _) = setup();
    let event = constants::EVENT_1();
    let owner = constants::OWNER();

    // create event
    start_cheat_caller_address(peach.contract_address, owner);
    peach.create_event(:event);
}
