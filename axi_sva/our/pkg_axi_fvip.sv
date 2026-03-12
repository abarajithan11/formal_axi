package pkg_axi_fvip;

  property low_after(rstn, valid);
    disable iff (0)
    !rstn |=> !valid;
  endproperty

  property not_with_rise(rstn, valid);
    disable iff (0)
    $rose(rstn) |-> !valid;
  endproperty

  property not_unknown(signal);
    !$isunknown(signal);
  endproperty

  property not_unknown_when(when_cond, signal);
    when_cond |-> !$isunknown(signal);
  endproperty

  property stable_next_when(when_cond, signal);
    when_cond |=> $stable(signal);
  endproperty

  property valid_before_ready(valid, ready);
    valid && !ready;
  endproperty

endpackage
