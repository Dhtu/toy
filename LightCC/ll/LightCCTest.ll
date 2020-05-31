
define double @average(double %x, double %y) {
entry:
  %y2 = alloca double
  %x1 = alloca double
  store double %x, double* %x1
  store double %y, double* %y2
  %x3 = load double, double* %x1
  %y4 = load double, double* %y2
  %addtmp = fadd double %x3, %y4
  %multmp = fmul double %addtmp, 5.000000e-01
  ret double %multmp
}


declare double @sin(double)


declare double @cos(double)


define double @sscc(double %x, double %y) {
entry:
  %y2 = alloca double
  %x1 = alloca double
  store double %x, double* %x1
  store double %y, double* %y2
  %x3 = load double, double* %x1
  %calltmp = call double @sin(double %x3)
  %x4 = load double, double* %x1
  %calltmp5 = call double @sin(double %x4)
  %y6 = load double, double* %y2
  %calltmp7 = call double @cos(double %y6)
  %y8 = load double, double* %y2
  %calltmp9 = call double @cos(double %y8)
  %multmp = fmul double %calltmp7, %calltmp9
  %addtmp = fadd double %calltmp5, %multmp
  %multmp10 = fmul double %calltmp, %addtmp
  ret double %multmp10
}


define double @fib(double %x) {
entry:
  %x1 = alloca double
  store double %x, double* %x1
  %x2 = load double, double* %x1
  %cmptmp = fcmp ult double %x2, 3.000000e+00
  %booltmp = uitofp i1 %cmptmp to double
  %ifcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %ifcond, label %then, label %else

then:                                             ; preds = %entry
  br label %ifcont

else:                                             ; preds = %entry
  %x3 = load double, double* %x1
  %subtmp = fsub double %x3, 1.000000e+00
  %calltmp = call double @fib(double %subtmp)
  %x4 = load double, double* %x1
  %subtmp5 = fsub double %x4, 2.000000e+00
  %calltmp6 = call double @fib(double %subtmp5)
  %addtmp = fadd double %calltmp, %calltmp6
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %iftmp = phi double [ 1.000000e+00, %then ], [ %addtmp, %else ]
  ret double %iftmp
}


declare double @printd(double)


define double @Main() {
entry:
  %calltmp = call double @fib(double 1.000000e+01)
  %calltmp1 = call double @printd(double %calltmp)
  ret double %calltmp1
}

