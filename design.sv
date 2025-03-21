`timescale 1ns / 1ps

module adder_comb(
    
    output logic [31:0] c,
    input logic [31:0] a,
    input logic [31:0] b
);
logic [7:0] expon_g;
logic [7:0] expon_l;
logic [23:0] mant_g;
logic [23:0] mant_l;
logic [7:0] expon_sum_pre;
logic [7:0] expon_sum_post_1;
logic [7:0] expon_sum_post_2;
logic [24:0] mant_sum_pre;
logic [23:0] mant_sum_post;
logic sign_sum;
logic sign_unequal;
logic [12:0] layer_1;
logic [6:0]  layer_2;
logic [3:0]  layer_3;
logic [1:0]  layer_4;
logic [4:0]  position [0:5];
logic [24:0] inter_mantissa;

always_comb begin
    mant_g = (a[30:0] > b[30:0])?{(|a[30:23]),a[22:0]}:{(|b[30:23]),b[22:0]};
    mant_l = (a[30:0] > b[30:0])?{(|b[30:23]),b[22:0]}:{(|a[30:23]),a[22:0]};
    expon_g = (a[30:0] > b[30:0])? a[30:23]: b[30:23];
    expon_l = (a[30:0] > b[30:0])? b[30:23]: a[30:23];
    sign_sum = (a[30:0] > b[30:0])? a[31]: b[31];
    sign_unequal = a[31] ^ b[31];
    if (sign_unequal) mant_sum_pre = mant_g - (mant_l >> (expon_g - (|expon_g) - expon_l + (|expon_l)));
    else mant_sum_pre = mant_g + (mant_l >> (expon_g - (|expon_g) - expon_l + (|expon_l)));
    expon_sum_pre = expon_g;
    position[0] = 24;
    if (mant_sum_pre[24:12]) begin
        layer_1 = mant_sum_pre[24:12];
        position[1] = position[0];
    end else begin
        layer_1 = {mant_sum_pre[11:0],1'b0};
        position[1] = position[0] - 13;
    end
    if (layer_1[12:6]) begin
        layer_2 = layer_1[12:6];
        position[2] = position[1];
    end else begin
        layer_2 = {layer_1[5:0],1'b0};
        position[2] = position[1] - 7;
    end
    if (layer_2[6:3]) begin
        layer_3 = layer_2[6:3];
        position[3] = position[2];
    end else begin
        layer_3 = {layer_2[2:0],1'b0};
        position[3] = position[2] - 4;
    end
    if (layer_3[3:2]) begin
        layer_4 = layer_3[3:2];
        position[4] = position[3];
    end else begin
        layer_4 = layer_3[1:0];
        position[4] = position[3] - 2;
    end
    if (layer_4[1]) position[5] = position[4];
    else position[5] = position[4] - 1;
    if (expon_sum_pre < 24 - position[5]) inter_mantissa = mant_sum_pre << expon_sum_pre;
    else inter_mantissa = mant_sum_pre << (24 - position[5]);
    if (expon_sum_pre < 24 - position[5]) expon_sum_post_1 = 0;
    else expon_sum_post_1 = expon_sum_pre - 24 + position[5];
    mant_sum_post = inter_mantissa[24:1] + inter_mantissa[0];
    if (!mant_sum_post) expon_sum_post_1 = 0;
    expon_sum_post_2 = expon_sum_post_1 + mant_sum_post[23];
    c = {sign_sum, expon_sum_post_2, mant_sum_post[22:0]};
end

endmodule