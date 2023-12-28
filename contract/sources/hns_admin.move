module hns::hns_admin {

    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use sui::transfer;

    struct AdminCap has key,store {
        id: UID
    }

    fun init(ctx: &mut TxContext){
        transfer::transfer(AdminCap{
            id:object::new(ctx),
        }, tx_context::sender(ctx));
    }

}