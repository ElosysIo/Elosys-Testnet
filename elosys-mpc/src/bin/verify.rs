extern crate pairing;

use blake2::{Blake2b512, Digest};
use elosys_zkp::constants::ASSET_ID_LENGTH;
use std::fs::File;
use std::io::BufReader;

fn main() {
    let params = File::open("params").unwrap();
    let mut params = BufReader::with_capacity(1024 * 1024, params);

    let sapling_spend = elosys_phase2::MPCParameters::read(&mut params, true)
        .expect("couldn't deserialize Sapling Spend params");

    let sapling_output = elosys_phase2::MPCParameters::read(&mut params, true)
        .expect("couldn't deserialize Sapling Output params");

    let sapling_mint = elosys_phase2::MPCParameters::read(&mut params, true)
        .expect("couldn't deserialize Sapling Mint params");

    let sapling_spend_contributions = sapling_spend
        .verify(elosys_zkp::proofs::Spend {
            value_commitment: None,
            proof_generation_key: None,
            payment_address: None,
            commitment_randomness: None,
            ar: None,
            auth_path: vec![None; elosys_zkp::constants::TREE_DEPTH],
            anchor: None,
            sender_address: None,
        })
        .expect("parameters are invalid");

    let sapling_output_contributions = sapling_output
        .verify(elosys_zkp::proofs::Output {
            value_commitment: None,
            payment_address: None,
            commitment_randomness: None,
            esk: None,
            asset_id: [0; ASSET_ID_LENGTH],
            ar: None,
            proof_generation_key: None,
        })
        .expect("parameters are invalid");

    let sapling_mint_contributions = sapling_mint
        .verify(elosys_zkp::proofs::MintAsset {
            proof_generation_key: None,
            public_key_randomness: None,
        })
        .expect("parameters are invalid");

    for ((a, b), c) in sapling_spend_contributions
        .into_iter()
        .zip(sapling_output_contributions.into_iter())
        .zip(sapling_mint_contributions)
    {
        let mut h = Blake2b512::new();
        h.update(a);
        h.update(b);
        h.update(c);
        let h = h.finalize();

        println!("{}", into_hex(h.as_ref()));
    }
}

fn into_hex(h: &[u8]) -> String {
    let mut f = String::new();

    for byte in h {
        f += &format!("{:02x}", byte);
    }

    f
}
