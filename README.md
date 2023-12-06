# Pragma Cairo SDK

The easiest way to import all dependencies needed to interact with Pragma on Starknet.

## Usage

```bash
scarb add pragma --git https://github.com/astraly-labs/pragma-lib
```

**BTC/USD Spot Median Price**

```rust
use pragma_lib::abi::{IPragmaABIDispatcher, IPragmaABIDispatcherTrait};
use pragma_lib::types::{AggregationMode, DataType, PragmaPricesResponse};
use starknet::ContractAddress;

const KEY: felt252 = 'BTC/USD';

fn get_asset_price_median(oracle_address: ContractAddress, asset : DataType) -> u128 { 
    let oracle_dispatcher = IOracleABIDispatcher{contract_address : oracle_address};
    let output: PragmaPricesResponse = oracle_dispatcher.get_data(asset, AggregationMode::Median(()));
    return output.price;
}
```