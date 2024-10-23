use rustler::{Atom, Error};
use starknet::accounts::{Account, ExecutionEncoding, SingleOwnerAccount};
use starknet::core::types::Call;
use starknet::providers::{jsonrpc::HttpTransport, JsonRpcClient, Url};
use starknet::signers::{LocalWallet, SigningKey};
use starknet_types_core::felt::Felt;
use std::str::FromStr;
use tokio::runtime::Runtime;
macro_rules! handle_starknet_error {
    ($e:expr, $err:expr) => {{
        match $e.map_err(|_| $err) {
            Ok(inner) => inner,
            Err(ref error) => {
                return Err(Error::Term(Box::new(starknet_error_to_term(error))));
            }
        }
    }};
}
mod atoms {
    rustler::atoms! {
        ok,
        error,
        invalid_address,
        invalid_calldata,
        invalid_to_address,
        invalid_selector,
        invalid_pk,
        invalid_provider_url,
        invalid_transaction,
    }
}
#[rustler::nif(schedule = "DirtyCpu")]
fn execute_tx(
    provider_url: &str,
    private_key: &str,
    address: &str,
    chain_id: &str,
    calls: Vec<(&str, &str, Vec<&str>)>,
) -> Result<String, Error> {
    let url = handle_starknet_error!(
        Url::from_str(provider_url),
        StarknetError::InvalidProviderUrl
    );
    let provider = JsonRpcClient::new(HttpTransport::new(url));
    let pk = handle_starknet_error!(Felt::from_hex(private_key), StarknetError::InvalidPk);
    let signer = LocalWallet::from_signing_key(SigningKey::from_secret_scalar(pk));
    let address = handle_starknet_error!(Felt::from_hex(address), StarknetError::InvalidAddress);
    let chain_id = Felt::from_bytes_be_slice(chain_id.as_bytes());
    let account =
        SingleOwnerAccount::new(provider, signer, address, chain_id, ExecutionEncoding::New);
    let calls = calls
        .iter()
        .map(|(to, selector, calldata)| {
            Ok(Call {
                to: handle_starknet_error!(Felt::from_hex(to), StarknetError::InvalidToAddress),
                selector: handle_starknet_error!(
                    Felt::from_hex(selector),
                    StarknetError::InvalidSelector
                ),
                calldata: calldata
                    .iter()
                    .map(|val| {
                        Ok(handle_starknet_error!(
                            Felt::from_hex(val),
                            StarknetError::InvalidCalldata
                        ))
                    })
                    .collect::<Result<Vec<Felt>, Error>>()?,
            })
        })
        .collect::<Result<Vec<Call>, Error>>()?;
    let tx = account.execute_v3(calls);

    // Create a new Tokio runtime
    let rt = Runtime::new().unwrap();

    // Call the async function and block until it completes
    let result = handle_starknet_error!(rt.block_on(tx.send()), StarknetError::InvalidTransaction);
    Ok(result.transaction_hash.to_hex_string())
}

#[allow(clippy::enum_variant_names)]
#[derive(Debug)]
enum StarknetError {
    InvalidAddress,
    InvalidPk,
    InvalidProviderUrl,
    InvalidTransaction,
    InvalidSelector,
    InvalidCalldata,
    InvalidToAddress,
}
fn starknet_error_to_term(err: &StarknetError) -> Atom {
    match err {
        StarknetError::InvalidProviderUrl => atoms::invalid_provider_url(),
        StarknetError::InvalidAddress => atoms::invalid_address(),
        StarknetError::InvalidPk => atoms::invalid_pk(),
        StarknetError::InvalidTransaction => atoms::invalid_transaction(),
        StarknetError::InvalidCalldata => atoms::invalid_calldata(),
        StarknetError::InvalidSelector => atoms::invalid_selector(),
        StarknetError::InvalidToAddress => atoms::invalid_to_address(),
    }
}
rustler::init!("Elixir.Starknet");
