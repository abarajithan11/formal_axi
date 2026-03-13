module fv_fifo_check #(
  parameter int WIDTH     = 32,
  parameter int MAX_DELAY = 100,
  parameter bit CAUSAL    = 1      // 1: output must follow input
                                   // 0: output can precede input (AW->W)
) (
  input logic clk,
  input logic rstn,

  input logic [WIDTH-1:0] s_data,
  input logic             s_hsk,

  input logic [WIDTH-1:0] m_data,
  input logic             m_hsk
);

  // --- Arbitrary stable symbols ---
  logic [WIDTH-1:0] d1, d2, d3;
  s_stable_d1: assume property (@(posedge clk) $stable(d1));
  s_stable_d2: assume property (@(posedge clk) $stable(d2));
  s_stable_d3: assume property (@(posedge clk) $stable(d3));
  s_different: assume property (@(posedge clk) d1 != d2);

  // --- One-shot capture windows ---
  logic win1, win2;
  logic win1_used, win2_used;

  always_ff @(posedge clk)
    if (!rstn)     win1_used <= 0;
    else if (win1) win1_used <= 1;

  always_ff @(posedge clk)
    if (!rstn)     win2_used <= 0;
    else if (win2) win2_used <= 1;

  s_win1_once: assume property (@(posedge clk) win1_used |-> !win1);
  s_win2_once: assume property (@(posedge clk) win2_used |-> !win2);

  // --- D1 input tracking ---
  wire seen_s_d1 = (s_data == d1) && s_hsk && !sampled_s_d1 && win1;
  logic sampled_s_d1;

  always_ff @(posedge clk)
    if (!rstn)          sampled_s_d1 <= 0;
    else if (seen_s_d1) sampled_s_d1 <= 1;

  // --- D2 input tracking ---
  wire seen_s_d2 = (s_data == d2) && s_hsk && !sampled_s_d2 && win2;
  logic sampled_s_d2;

  always_ff @(posedge clk)
    if (!rstn)          sampled_s_d2 <= 0;
    else if (seen_s_d2) sampled_s_d2 <= 1;

  // --- D1 enters before D2 ---
  s_ordering: assume property (@(posedge clk) !sampled_s_d1 |-> !sampled_s_d2);

  // --- D1 output tracking ---
  // CAUSAL=1: only detect after input seen
  // CAUSAL=0: detect anytime (output can precede input)
  wire d1_eligible = CAUSAL ? sampled_s_d1 : 1'b1;
  wire d2_eligible = CAUSAL ? sampled_s_d2 : 1'b1;

  wire seen_m_d1 = (m_data == d1) && m_hsk && d1_eligible && !sampled_m_d1;
  logic sampled_m_d1;

  always_ff @(posedge clk)
    if (!rstn)          sampled_m_d1 <= 0;
    else if (seen_m_d1) sampled_m_d1 <= 1;

  // --- D2 output tracking ---
  wire seen_m_d2 = (m_data == d2) && m_hsk && d2_eligible && !sampled_m_d2;
  logic sampled_m_d2;

  always_ff @(posedge clk)
    if (!rstn)          sampled_m_d2 <= 0;
    else if (seen_m_d2) sampled_m_d2 <= 1;

  // --- D3 tracking (uniqueness) ---
  logic sampled_s_d3, sampled_m_d3;

  wire seen_s_d3 = (s_data == d3) && s_hsk;
  wire seen_m_d3 = (m_data == d3) && m_hsk;

  always_ff @(posedge clk)
    if (!rstn)          sampled_s_d3 <= 0;
    else if (seen_s_d3) sampled_s_d3 <= 1;

  always_ff @(posedge clk)
    if (!rstn)          sampled_m_d3 <= 0;
    else if (seen_m_d3) sampled_m_d3 <= 1;

  s_unique_in:  assume property (@(posedge clk) sampled_s_d3 |-> !seen_s_d3);
  a_unique_out: assert property (@(posedge clk) sampled_m_d3 |-> !seen_m_d3);

  // --- Assertions ---
  a_integrity: assert property (
    @(posedge clk) sampled_s_d1 |-> ##[0:MAX_DELAY] sampled_m_d1
  );

  a_ordering: assert property (
    @(posedge clk) sampled_s_d1 && sampled_s_d2 && !sampled_m_d1 |-> !sampled_m_d2
  );

endmodule