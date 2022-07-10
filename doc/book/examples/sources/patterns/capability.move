module 0x0::item {
    use sui::transfer;
    use sui::id::VersionedID;
    use sui::utf8::{Self, String};
    use sui::tx_context::{Self, TxContext};

    /// Type that marks Capabality to create new `Item`s.
    struct AdminCap has key { id: VersionedID }

    /// Custom NFT-like type.
    struct Item has key, store { id: VersionedID, name: String }

    /// Module initializer is called once on module publish.
    /// Here we create only one instance of `AdminCap` and send it to the publisher.
    fun item(ctx: &mut TxContext) {
        transfer::transfer(AdminCap {
            id: tx_context::new_id(ctx)
        }, tx_context::sender(ctx))
    }

    /// The entry function can not be called if `AdminCap` is not passed as
    /// the first argument. Hence only owner of the `AdminCap` can perform
    /// this action.
    public entry fun create_and_send(
        _: &AdminCap, name: vector<u8>, to: address, ctx: &mut TxContext
    ) {
        transfer::transfer(Item {
            id: tx_context::new_id(ctx),
            name: utf8::string_unsafe(name)
        }, to)
    }
}
