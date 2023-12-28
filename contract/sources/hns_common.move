module hns::hns_common {

    use sui::tx_context::{TxContext};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::table::{Self,Table};
    
    // use hns::admin::AdminCap;

    struct NameOwnerTable has key  {
        id: UID,
        data: Table<vector<u8>,OwnerData>
    }

    struct OwnerData has store {
        owner_address: vector<u8>,
        transaction: vector<u8>,
        block_height: u64
    }

    fun init(ctx: &mut TxContext){
        transfer::share_object(NameOwnerTable{
            id:object::new(ctx),
            data:table::new(ctx)
        });
    }

    entry fun update_name_owner(owner_table:&mut NameOwnerTable,name:vector<u8>,owner_address:vector<u8>,transaction:vector<u8>,block_height:u64){
        if(table::contains(&owner_table.data,name)){
            let owner_data = table::borrow_mut(&mut owner_table.data,name);
            if(owner_data.block_height < block_height){
                owner_data.owner_address = owner_address;
                owner_data.transaction = transaction;
                owner_data.block_height = block_height;
            }
        } else{
            table::add(&mut owner_table.data,name,OwnerData{
                owner_address,
                transaction,
                block_height
            });
        }
    }
    

}