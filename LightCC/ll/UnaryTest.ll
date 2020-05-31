
define double @"unary!"(double %v) {
entry:
  %v1 = alloca double
  store double %v, double* %v1
  %v2 = load double, double* %v1
  %ifcond = fcmp one double %v2, 0.000000e+00
  br i1 %ifcond, label %then, label %else

then:                                             ; preds = %entry
  br label %ifcont

else:                                             ; preds = %entry
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %iftmp = phi double [ 0.000000e+00, %then ], [ 1.000000e+00, %else ]
  ret double %iftmp
}

Read top-level :
define double @__anon_expr() {
entry:
  %unop = call double @"unary!"(double 0.000000e+00)
  ret double %unop
}

