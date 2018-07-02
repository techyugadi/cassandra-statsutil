-- 'state' tuple has 2 fields: running sum of quantity multipled by weight, 
-- and sum of weights totalled so far
-- 'value' tuple has 2 fields: the quantity itself and its weight 
-- (zero or a positive proper fraction)
CREATE OR REPLACE FUNCTION wtavgState ( state tuple<double, double>, 
val tuple<int, double> ) 
CALLED ON NULL INPUT RETURNS tuple<double, double> LANGUAGE java AS '
if (val != null) { 
  double product = val.getInt(0) * val.getDouble(1);
  state.setDouble(0, state.getDouble(0) + product); 
  state.setDouble(1, state.getDouble(1) + val.getDouble(1)); 
} 
   
return state;';

CREATE OR REPLACE FUNCTION wtavgFinal ( state tuple<double, double> ) 
CALLED ON NULL INPUT RETURNS double LANGUAGE java AS '
final double tolerance = 0.001;
double totalWt = state.getDouble(1); 
double delta = java.lang.Math.abs(totalWt - 1);
if (delta >= tolerance) 
  return null; 
double r = state.getDouble(0); 
return Double.valueOf(r);';

CREATE AGGREGATE IF NOT EXISTS wtaverage ( tuple<int, double> ) 
SFUNC wtavgState 
STYPE tuple<double, double> 
FINALFUNC wtavgFinal 
INITCOND (0.0, 0.0);
