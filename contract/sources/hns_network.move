module hns::hns_network {

    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::clock::{Self,Clock};

    struct NetworkStatus has key {
        id: UID,
        height: u64,
        transactions: u64,
        coin: u64,
        value: u64,
        burned: u64,
        timestamp: u64
    }

    struct UpdateNetworkCap has key,store {
        id: UID
    }

    fun init(ctx: &mut TxContext){
        transfer::transfer(UpdateNetworkCap{
            id:object::new(ctx),
        }, tx_context::sender(ctx));
        transfer::share_object(NetworkStatus{
            id:object::new(ctx),
            height: 0,
            transactions: 0,
            coin: 0,
            value: 0,
            burned: 0,
            timestamp: 0
        });
    }

    entry fun update_network_status(_cap: &UpdateNetworkCap, status: &mut NetworkStatus,height:u64,transactions:u64,coin:u64,value:u64,burned:u64,clock:&Clock){
        status.height = height;
        status.transactions = transactions;
        status.coin = coin;
        status.value = value;
        status.burned = burned;
        status.timestamp = clock::timestamp_ms(clock);
    }

}