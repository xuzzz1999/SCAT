pragma circom 2.0.0;

template Multiplier2() {
    signal input a;
    signal input b;
    signal output c;

    // b === 1;
    c <== a+b;
 }

 component main = Multiplier2();