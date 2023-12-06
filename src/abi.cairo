use starknet::{ContractAddress, ClassHash};
use pragma_lib::types::{
    DataType, AggregationMode, Currency, Pair, PossibleEntries, Checkpoint, SimpleDataType,
    PragmaPricesResponse
};

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
}
