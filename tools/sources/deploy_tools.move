module poly_tools::deploy_tools {

    use poly::cross_chain_manager;
    use poly_bridge::lock_proxy;

    public entry fun issue_license_to_lock_proxy(account: &signer) {
        let license = cross_chain_manager::issueLicense(account, @poly_bridge, b"lock_proxy");
        lock_proxy::receiveLicense(license);
    }
}