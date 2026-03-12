package pkg_axi_fvip;
  property not_unknown(signal);
    !$isunknown(signal);
  endproperty

  property not_unknown_when(signal, when_cond);
    when_cond |-> !$isunknown(signal);
  endproperty

  property stable_next_when(signal, when_cond);
    when_cond |=> $stable(signal);
  endproperty
endpackage
