/**
 * @module load_use_detector
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief load use data hazard detection
 * @input ID_rs rs value in ID stage
 * @input ID_rt rt value in ID stage
 * @input EX_rt rt value in EX stage
 * @input EX_ramtoreg ramtoreg signal in EX stage
 * @output load_use_hazard load use hazard signal
 */
module load_use_detector
(
    input [4:0] ID_rs,
    input [4:0] ID_rt,
    input [4:0] EX_rt,
    input EX_ramtoreg,
    output load_use_hazard
);

    assign load_use_hazard = EX_rt != 0 && EX_ramtoreg && (EX_rt == ID_rs || EX_rt == ID_rt);
    
endmodule // load_use_detector

