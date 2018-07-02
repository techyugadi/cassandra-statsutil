-- The tuple 'state' consists of the following (in order):
-- Number of X-Y pairs processed so far
-- Sum of X terms
-- Sum of Y terms
-- Sum of XY terms
-- Sum of X*X terms
-- Sum of Y*Y terms
-- It is a one-pass method
CREATE OR REPLACE FUNCTION correlationState ( 
state tuple<int, int, int, int, int, int>, val tuple<int, int> ) 
CALLED ON NULL INPUT RETURNS tuple<int, int, int, int, int, int> 
LANGUAGE java AS '
if (val != null) { 
  int n = state.getInt(0) + 1;
  int xsum = state.getInt(1) + val.getInt(0);
  int ysum = state.getInt(2) + val.getInt(1);
  int xysum = state.getInt(3) + val.getInt(0) * val.getInt(1);
  int xsquaredSum = state.getInt(4) + val.getInt(0) * val.getInt(0);
  int ysquaredSum = state.getInt(5) + val.getInt(1) * val.getInt(1);
    
  state.setInt(0, n); 
  state.setInt(1, xsum);
  state.setInt(2, ysum);
  state.setInt(3, xysum);
  state.setInt(4, xsquaredSum);
  state.setInt(5, ysquaredSum);
} 
  
return state;' 
  
CREATE OR REPLACE FUNCTION correlationFinal ( 
state tuple<int, int, int, int, int, int> ) 
CALLED ON NULL INPUT RETURNS double LANGUAGE java AS '

int n = state.getInt(0);
int xsum = state.getInt(1);
int ysum = state.getInt(2);
int xysum = state.getInt(3);
int xsquaredSum = state.getInt(4);
int ysquaredSum = state.getInt(5);
  
double xmean = (xsum + 0.0) / n;
double ymean = (ysum + 0.0) / n;
double xsquaredMean = (xsquaredSum + 0.0) / n;
double ysquaredMean = (ysquaredSum + 0.0) / n;
  
double r = (xysum - n * xmean * ymean) / (java.lang.Math.sqrt(xsquaredSum - 
  n * xmean * xmean) * java.lang.Math.sqrt(ysquaredSum - n * ymean * ymean));
return Double.valueOf(r);'
  
CREATE OR REPLACE AGGREGATE correlation ( tuple<int, int> ) 
SFUNC correlationState 
STYPE tuple<int, int, int, int, int, int> 
FINALFUNC correlationFinal 
INITCOND (0, 0, 0, 0, 0, 0);
