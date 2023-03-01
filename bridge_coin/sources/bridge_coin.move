module bridge_coin::bridge_coin {
    use std::string::{String};
    use std::error;
    use std::signer;

    use aptos_framework::coin;

    use poly_bridge::lock_proxy as lock_proxy_v2;

    const ENOT_BRIDGE_ADMIN: u64 = 1;

    const HUGE_U64: u64 = 10000000000000000000;

    public entry fun initialize<BridgeCoinType>(
        admin: &signer,
        name: String,
        symbol: String,
        decimals: u8,
    ) {
        only_admin(admin);

        let (burn_cap, freeze_cap, mint_cap) = coin::initialize<BridgeCoinType>(
            admin,
            name,
            symbol,
            decimals,
            true, /* monitor_supply */
        );

        let initial_lock = coin::mint<BridgeCoinType>(HUGE_U64, &mint_cap);
        lock_proxy_v2::initTreasury<BridgeCoinType>(admin);
        lock_proxy_v2::deposit<BridgeCoinType>(initial_lock);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_freeze_cap(freeze_cap);
        coin::destroy_mint_cap(mint_cap);
    }

    fun only_admin(account: &signer) {
        assert!(lock_proxy_v2::is_admin(signer::address_of(account)), error::permission_denied(ENOT_BRIDGE_ADMIN));
    }
}