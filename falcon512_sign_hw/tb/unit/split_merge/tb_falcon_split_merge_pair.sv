`timescale 1ns/1ps
module tb_falcon_split_merge_pair;
    logic mode_merge, base_case;
    logic [63:0] a_re, a_im, b_re, b_im, tw_re, tw_im;
    wire  [63:0] out0_re, out0_im, out1_re, out1_im;
    reg [63:0] gm[0:2047];
    reg [63:0] data_in[0:511], split0_expected[0:255], split1_expected[0:255];
    reg [63:0] merge0_in[0:255], merge1_in[0:255], merge_expected[0:511];
    integer cid, logn, n, hn, qn, u, fails, checks;
    string dir, name;

    falcon_split_merge_pair dut(
      .mode_merge(mode_merge), .base_case(base_case),
      .a_re(a_re), .a_im(a_im), .b_re(b_re), .b_im(b_im),
      .tw_re(tw_re), .tw_im(tw_im),
      .out0_re(out0_re), .out0_im(out0_im),
      .out1_re(out1_re), .out1_im(out1_im)
    );

task automatic check(
    input [63:0] got,
    input [63:0] exp,
    input string check_tag
);
    checks = checks + 1;

    if (got !== exp) begin
        fails = fails + 1;

        if (fails <= 30)
            $display(
                "FAIL: %s got=%016h expected=%016h",
                check_tag, got, exp
            );
    end
endtask


    initial begin
        mode_merge=0; base_case=0;
        a_re=0; a_im=0; b_re=0; b_im=0; tw_re=0; tw_im=0;
        checks=0; fails=0;
        $dumpfile("build/split_merge.vcd");
        $dumpvars(0, tb_falcon_split_merge_pair);
        dir = "golden/unit/split_merge/directed";
        if ($value$plusargs("VECTOR_DIR=%s", dir))
            $display("Using external VECTOR_DIR=%s",dir);
        $readmemh("tb/unit/split_merge/gm_tab.memh",gm);

        for(cid=0;cid<9;cid=cid+1) begin
            logn=cid+1; n=1<<logn; hn=n>>1; qn=hn>>1;
            name=$sformatf("%s/split/case_%03d/input.memh",dir,cid);
            $readmemh(name,data_in);
            name=$sformatf("%s/split/case_%03d/out0.memh",dir,cid);
            $readmemh(name,split0_expected);
            name=$sformatf("%s/split/case_%03d/out1.memh",dir,cid);
            $readmemh(name,split1_expected);
            mode_merge=0; base_case=(logn==1);
            if(logn==1) begin
                a_re=data_in[0]; a_im=data_in[1];
                #2;
                check(out0_re,split0_expected[0],"SPLIT base f0");
                check(out1_re,split1_expected[0],"SPLIT base f1");
            end else for (u=0;u<qn;u=u+1) begin
                a_re=data_in[2*u]; a_im=data_in[2*u+hn];
                b_re=data_in[2*u+1]; b_im=data_in[2*u+hn+1];
                tw_re=gm[2*(u+hn)]; tw_im=gm[2*(u+hn)+1];
                #2;
                check(out0_re,split0_expected[u],"SPLIT f0 re");
                check(out0_im,split0_expected[u+qn],"SPLIT f0 im");
                check(out1_re,split1_expected[u],"SPLIT f1 re");
                check(out1_im,split1_expected[u+qn],"SPLIT f1 im");
            end

            name=$sformatf("%s/merge/case_%03d/in0.memh",dir,cid);
            $readmemh(name,merge0_in);
            name=$sformatf("%s/merge/case_%03d/in1.memh",dir,cid);
            $readmemh(name,merge1_in);
            name=$sformatf("%s/merge/case_%03d/expected.memh",dir,cid);
            $readmemh(name,merge_expected);
            mode_merge=1;
            if(logn==1) begin
                a_re=merge0_in[0]; b_re=merge1_in[0];
                #2;
                check(out0_re,merge_expected[0],"MERGE base f[0]");
                check(out1_re,merge_expected[1],"MERGE base f[1]");
            end else for (u=0;u<qn;u=u+1) begin
                a_re=merge0_in[u]; a_im=merge0_in[u+qn];
                b_re=merge1_in[u]; b_im=merge1_in[u+qn];
                tw_re=gm[2*(u+hn)]; tw_im=gm[2*(u+hn)+1];
                #2;
                check(out0_re,merge_expected[2*u],"MERGE f even re");
                check(out0_im,merge_expected[2*u+hn],"MERGE f even im");
                check(out1_re,merge_expected[2*u+1],"MERGE f odd re");
                check(out1_im,merge_expected[2*u+1+hn],"MERGE f odd im");
            end
            $display("Completed logn=%0d N=%0d accumulated_failures=%0d",logn,n,fails);
        end
        $display("TOTAL: checks=%0d errors=%0d",checks,fails);
	
$display("TOTAL: checks=%0d errors=%0d",
         checks, fails);

if (fails == 0) begin
    $display("TEST PASS: Falcon Split/Merge directed golden");
end
else begin
    $display("TEST FAIL: mismatched golden values");
end

$finish;

        $finish;
    end
endmodule
