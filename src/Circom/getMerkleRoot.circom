pragma circom 2.0.0;
include "../circomlib/circuits/mimc.circom"; 

template GetMerkleRoot(k){
  

    signal input leaf; 
    signal input paths2_root[k]; 
    signal input paths2_root_pos[k]; 

    signal output out;

    component merkle_root[k];
    merkle_root[0] = MiMC7(91);
    merkle_root[0].x_in <== paths2_root[0] - paths2_root_pos[0]* (paths2_root[0] - leaf);
    merkle_root[0].k <== leaf - paths2_root_pos[0]* (leaf - paths2_root[0]);

    for (var v = 1; v < k; v++){
        merkle_root[v] = MiMC7(91);
        merkle_root[v].x_in <== paths2_root[v] - paths2_root_pos[v]* (paths2_root[v] - merkle_root[v-1].out);
        merkle_root[v].k <== merkle_root[v-1].out - paths2_root_pos[v]* (merkle_root[v-1].out - paths2_root[v]);
        
    }

    out <== merkle_root[k-1].out;

}