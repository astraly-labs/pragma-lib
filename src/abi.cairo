use starknet::{ContractAddress, ClassHash};
use pragma_lib::types::{
    DataType, AggregationMode, Currency, Pair, PossibleEntries, Checkpoint, SimpleDataType,
    PragmaPricesResponse, YieldPoint, FutureKeyStatus, RequestStatus, OptionsFeedData, Assertion
};
use openzeppelin::token::erc20::interface::ERC20ABIDispatcher;

#[starknet::interface]
trait IPragmaABI<TContractState> {
    fn get_decimals(self: @TContractState, data_type: DataType) -> u32;
    fn get_data_median(self: @TContractState, data_type: DataType) -> PragmaPricesResponse;
    fn get_data_median_for_sources(
        self: @TContractState, data_type: DataType, sources: Span<felt252>
    ) -> PragmaPricesResponse;
    fn get_data(
        self: @TContractState, data_type: DataType, aggregation_mode: AggregationMode
    ) -> PragmaPricesResponse;
    fn get_data_median_multi(
        self: @TContractState, data_types: Span<DataType>, sources: Span<felt252>
    ) -> Span<PragmaPricesResponse>;
    fn get_data_entry(
        self: @TContractState, data_type: DataType, source: felt252
    ) -> PossibleEntries;
    fn get_data_for_sources(
        self: @TContractState,
        data_type: DataType,
        aggregation_mode: AggregationMode,
        sources: Span<felt252>
    ) -> PragmaPricesResponse;
    fn get_data_entries(self: @TContractState, data_type: DataType) -> Span<PossibleEntries>;
    fn get_data_entries_for_sources(
        self: @TContractState, data_type: DataType, sources: Span<felt252>
    ) -> (Span<PossibleEntries>, u64);
    fn get_last_checkpoint_before(
        self: @TContractState,
        data_type: DataType,
        timestamp: u64,
        aggregation_mode: AggregationMode,
    ) -> (Checkpoint, u64);
    fn get_data_with_USD_hop(
        self: @TContractState,
        base_currency_id: felt252,
        quote_currency_id: felt252,
        aggregation_mode: AggregationMode,
        typeof: SimpleDataType,
        expiration_timestamp: Option::<u64>
    ) -> PragmaPricesResponse;
    fn get_publisher_registry_address(self: @TContractState) -> ContractAddress;
    fn get_latest_checkpoint_index(
        self: @TContractState, data_type: DataType, aggregation_mode: AggregationMode
    ) -> (u64, bool);
    fn get_latest_checkpoint(
        self: @TContractState, data_type: DataType, aggregation_mode: AggregationMode
    ) -> Checkpoint;
    fn get_checkpoint(
        self: @TContractState,
        data_type: DataType,
        checkpoint_index: u64,
        aggregation_mode: AggregationMode
    ) -> Checkpoint;
    fn get_sources_threshold(self: @TContractState) -> u32;
    fn get_admin_address(self: @TContractState) -> ContractAddress;
    fn get_implementation_hash(self: @TContractState) -> ClassHash;
    fn publish_data(ref self: TContractState, new_entry: PossibleEntries);
    fn publish_data_entries(ref self: TContractState, new_entries: Span<PossibleEntries>);
    fn set_admin_address(ref self: TContractState, new_admin_address: ContractAddress);
    fn update_publisher_registry_address(
        ref self: TContractState, new_publisher_registry_address: ContractAddress
    );
    fn add_currency(ref self: TContractState, new_currency: Currency);
    fn update_currency(ref self: TContractState, currency_id: felt252, currency: Currency);
    fn add_pair(ref self: TContractState, new_pair: Pair);
    fn set_checkpoint(
        ref self: TContractState, data_type: DataType, aggregation_mode: AggregationMode
    );
    fn set_checkpoints(
        ref self: TContractState, data_types: Span<DataType>, aggregation_mode: AggregationMode
    );
    fn set_sources_threshold(ref self: TContractState, threshold: u32);
    fn upgrade(ref self: TContractState, impl_hash: ClassHash);
}


#[starknet::interface]
trait ISummaryStatsABI<TContractState> {
    fn calculate_mean(
        self: @TContractState,
        data_type: DataType,
        start: u64,
        stop: u64,
        aggregation_mode: AggregationMode
    ) -> (u128, u32);

    fn calculate_volatility(
        self: @TContractState,
        data_type: DataType,
        start_tick: u64,
        end_tick: u64,
        num_samples: u64,
        aggregation_mode: AggregationMode
    ) -> (u128, u32);

    fn calculate_twap(
        self: @TContractState,
        data_type: DataType,
        aggregation_mode: AggregationMode,
        time: u64,
        start_time: u64,
    ) -> (u128, u32);


    fn get_oracle_address(self: @TContractState) -> ContractAddress;

    fn get_options_data(self: @TContractState, instrument_name: felt252) -> OptionsFeedData;
    fn get_options_data_hash(self: @TContractState, update_data: OptionsFeedData) -> felt252;
}

#[starknet::interface]
trait IYieldCurveABI<TContractState> {
    fn get_yield_points(self: @TContractState, decimals: u32) -> Span<YieldPoint>;
    fn get_admin_address(self: @TContractState,) -> ContractAddress;
    fn get_oracle_address(self: @TContractState,) -> ContractAddress;
    fn get_future_spot_pragma_source_key(self: @TContractState,) -> felt252;
    fn get_pair_id(self: @TContractState, idx: u64) -> felt252;
    fn get_pair_id_is_active(self: @TContractState, pair_id: felt252) -> bool;
    fn get_pair_ids(self: @TContractState,) -> Span<felt252>;
    fn get_future_expiry_timestamp(self: @TContractState, pair_id: felt252, idx: u64) -> u64;
    fn get_future_expiry_timestamps(self: @TContractState, pair_id: felt252) -> Span<u64>;
    fn get_on_key(self: @TContractState, idx: u64) -> felt252;
    fn get_on_key_is_active(self: @TContractState, on_key: felt252) -> bool;
    fn get_on_keys(self: @TContractState,) -> Span<felt252>;
    fn get_future_expiry_timestamp_status(
        self: @TContractState, pair_id: felt252, future_expiry_timestamp: u64
    ) -> FutureKeyStatus;
    fn get_future_expiry_timestamp_is_active(
        self: @TContractState, pair_id: felt252, future_expiry_timestamp: u64
    ) -> bool;
    fn get_future_expiry_timestamp_expiry(
        self: @TContractState, pair_id: felt252, future_expiry_timestamp: u64
    ) -> u64;

    //
    // Setters
    //

    fn set_admin_address(ref self: TContractState, new_address: ContractAddress);
    fn set_future_spot_pragma_source_key(ref self: TContractState, new_source_key: felt252);
    fn set_oracle_address(ref self: TContractState, oracle_address: ContractAddress);
    fn add_pair_id(ref self: TContractState, pair_id: felt252, is_active: bool);
    fn set_pair_id_is_active(ref self: TContractState, pair_id: felt252, is_active: bool);
    fn add_future_expiry_timestamp(
        ref self: TContractState,
        pair_id: felt252,
        future_expiry_timestamp: u64,
        is_active: bool,
        expiry_timestamp: u64
    );
    fn set_future_expiry_timestamp_status(
        ref self: TContractState,
        pair_id: felt252,
        future_expiry_timestamp: u64,
        new_future_expiry_timestamp_status: FutureKeyStatus,
    );

    fn set_future_expiry_timestamp_is_active(
        ref self: TContractState,
        pair_id: felt252,
        future_expiry_timestamp: u64,
        new_is_active: bool
    );

    fn add_on_key(ref self: TContractState, on_key: felt252, is_active: bool);

    fn set_on_key_is_active(ref self: TContractState, on_key: felt252, is_active: bool);
}

#[starknet::interface]
trait IRandomness<TContractState> {
    fn update_status(
        ref self: TContractState,
        requestor_address: ContractAddress,
        request_id: u64,
        new_status: RequestStatus
    );
    fn request_random(
        ref self: TContractState,
        seed: u64,
        callback_address: ContractAddress,
        callback_fee_limit: u128,
        publish_delay: u64,
        num_words: u64,
        calldata: Array<felt252>
    ) -> u64;
    fn cancel_random_request(
        ref self: TContractState,
        request_id: u64,
        requestor_address: ContractAddress,
        seed: u64,
        minimum_block_number: u64,
        callback_address: ContractAddress,
        callback_fee_limit: u128,
        num_words: u64
    );
    fn submit_random(
        ref self: TContractState,
        request_id: u64,
        requestor_address: ContractAddress,
        seed: u64,
        minimum_block_number: u64,
        callback_address: ContractAddress,
        callback_fee_limit: u128,
        callback_fee: u128,
        random_words: Span<felt252>,
        proof: Span<felt252>,
        calldata: Array<felt252>
    );
    fn get_pending_requests(
        self: @TContractState, requestor_address: ContractAddress, offset: u64, max_len: u64
    ) -> Span<felt252>;

    fn get_request_status(
        self: @TContractState, requestor_address: ContractAddress, request_id: u64
    ) -> RequestStatus;
    fn requestor_current_index(self: @TContractState, requestor_address: ContractAddress) -> u64;
    fn get_public_key(self: @TContractState, requestor_address: ContractAddress) -> felt252;
    fn get_payment_token(self: @TContractState) -> ContractAddress;
    fn set_payment_token(ref self: TContractState, token_contract: ContractAddress);
    fn upgrade(ref self: TContractState, impl_hash: ClassHash);
    fn refund_operation(ref self: TContractState, caller_address: ContractAddress, request_id: u64);
    fn get_total_fees(
        self: @TContractState, caller_address: ContractAddress, request_id: u64
    ) -> u256;
    fn get_out_of_gas_requests(
        self: @TContractState, requestor_address: ContractAddress,
    ) -> Span<u64>;
    fn withdraw_funds(ref self: TContractState, receiver_address: ContractAddress);
    fn get_contract_balance(self: @TContractState) -> u256;
    fn compute_premium_fee(self: @TContractState, caller_address: ContractAddress) -> u128;
    fn get_admin_address(self: @TContractState,) -> ContractAddress;
    fn set_admin_address(ref self: TContractState, new_admin_address: ContractAddress);
}

#[starknet::interface]
pub trait IOptimisticOracle<TContractState> {
    fn assert_truth_with_defaults(
        ref self: TContractState, claim: ByteArray, asserter: ContractAddress
    ) -> felt252;

    fn assert_truth(
        ref self: TContractState,
        claim: ByteArray,
        asserter: ContractAddress,
        callback_recipient: ContractAddress,
        escalation_manager: ContractAddress,
        liveness: u64,
        currency: ERC20ABIDispatcher,
        bond: u256,
        identifier: felt252,
        domain_id: u256
    ) -> felt252;

    fn dispute_assertion(
        ref self: TContractState, assertion_id: felt252, disputer: ContractAddress
    );

    fn settle_assertion(ref self: TContractState, assertion_id: felt252);

    fn get_minimum_bond(self: @TContractState, currency: ContractAddress) -> u256;

    fn stamp_assertion(self: @TContractState, assertion_id: felt252) -> ByteArray;

    fn default_identifier(self: @TContractState,) -> felt252;

    fn get_assertion(self: @TContractState, assertion_id: felt252) -> Assertion;

    fn sync_params(ref self: TContractState, identifier: felt252, currency: ContractAddress);

    fn settle_and_get_assertion_result(ref self: TContractState, assertion_id: felt252) -> bool;

    fn get_assertion_result(self: @TContractState, assertion_id: felt252) -> bool;

    fn set_admin_properties(
        ref self: TContractState,
        default_currency: ContractAddress,
        default_liveness: u64,
        burned_bond_percentage: u256
    );
}