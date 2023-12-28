module hns::hns_record {

    use sui::tx_context::{TxContext};
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::table::{Self,Table};
    use std::string::{String};
    use hns::hns_admin::AdminCap;

    const E_NOT_FOUND:u64 = 1;

    struct ItemInfo has store {
        name: String,
        owner: address,
        update_block: u64
    }

    struct OrcaleData has key {
        id:UID,
        dataTable: Table<String,ItemInfo>
    }

    fun init(ctx: &mut TxContext){
        transfer::share_object(OrcaleData{
            id:object::new(ctx),
            dataTable:table::new(ctx)
        });
    }

    entry fun update_name_item(_cap: &AdminCap, data : &mut OrcaleData, name: String,owner:address){
        if(table::contains(&data.dataTable,name)){
            let v = table::borrow_mut(&mut data.dataTable,name);
            v.name = name;
            v.owner = owner;
        } else {
            table::add(&mut data.dataTable,name,ItemInfo{
                name,
                owner,
                update_block:0
            });
        }
    }

    public fun get_item(data : &OrcaleData,name:String):&ItemInfo {
        assert!(table::contains(&data.dataTable,name),E_NOT_FOUND);
        table::borrow(&data.dataTable,name)
    }

    public fun contain_name(data : &OrcaleData,name:String):bool {
        table::contains(&data.dataTable,name)
    }

}