-- The 'state' tuple consists of the following (in order)
-- The running count of values seen so far
-- A running mean value
-- A running sum of squares value
-- This method computes variance and stdev in one pass using Feldman's algo
CREATE OR REPLACE FUNCTION varState ( state tuple<int, double, double>, val int)
CALLED ON NULL INPUT RETURNS tuple<int, double, double> LANGUAGE java AS '
if (val != null) { 
  int n = state.getInt(0) + 1;
  double lastMean = state.getDouble(1);
  double newMean = state.getDouble(1) + (val.intValue() - 
                               state.getDouble(1)) / ((double) n);
  double newSquare = state.getDouble(2) + (val.intValue() - newMean) * 
                               (val.intValue() - lastMean);
  state.setInt(0, n); 
  state.setDouble(1, newMean);
  state.setDouble(2, newSquare);
} 
   
return state;' ;

CREATE OR REPLACE FUNCTION varFinal ( state tuple<int, double, double> ) 
CALLED ON NULL INPUT RETURNS double LANGUAGE java AS '
double r = 0; 
if (state.getInt(0) == 0) 
  return null; 
r = state.getDouble(2);
r /= state.getInt(0); 
return Double.valueOf(r);';

CREATE OR REPLACE AGGREGATE variance ( int ) 
SFUNC varState 
STYPE tuple<int, double, double> 
FINALFUNC varFinal 
INITCOND (0, 0.0, 0.0);

CREATE OR REPLACE FUNCTION stdevFinal ( state tuple<int, double, double> ) 
CALLED ON NULL INPUT RETURNS double LANGUAGE java AS '
double r = 0; 
if (state.getInt(0) == 0) 
  return null; 
r = state.getDouble(2);
r /= state.getInt(0); 
return Double.valueOf(java.lang.Math.sqrt(r));'
  
CREATE OR REPLACE AGGREGATE stdev ( int ) 
SFUNC varState 
STYPE tuple<int, double, double> 
FINALFUNC stdevFinal 
INITCOND (0, 0.0, 0.0);
