-- The 'state' tuple consists of the following (in order)
-- A running count of points seen so far
-- The x component
-- The y component
-- The z component
-- It can be easily extended to data points with more than three dimensions
CREATE OR REPLACE FUNCTION centroidState ( 
state tuple<int, int, int, int>, val tuple<int, int, int> ) 
CALLED ON NULL INPUT RETURNS tuple<int, int, int, int> LANGUAGE java AS '
if (val != null) { 
  int n = state.getInt(0) + 1;
  int sumX = state.getInt(1) + val.getInt(0);
  int sumY = state.getInt(2) + val.getInt(1);
  int sumZ = state.getInt(3) + val.getInt(2);
    
  state.setInt(0, n); 
  state.setInt(1, sumX);
  state.setInt(2, sumY);
  state.setInt(3, sumZ);
} 
  
return state;' 
  
CREATE OR REPLACE FUNCTION centroidFinal ( state tuple<int, int, int, int> ) 
CALLED ON NULL INPUT RETURNS tuple<double, double, double> LANGUAGE java AS '
int count = state.getInt(0);
double xmean = state.getInt(1) / (count + 0.0);
double ymean = state.getInt(2) / (count + 0.0);
double zmean = state.getInt(3) / (count + 0.0);
  
com.datastax.driver.core.TupleType tupleType = 
                com.datastax.driver.core.TupleType.of(
                  com.datastax.driver.core.ProtocolVersion.NEWEST_SUPPORTED, 
                  com.datastax.driver.core.CodecRegistry.DEFAULT_INSTANCE, 
                  com.datastax.driver.core.DataType.cdouble(), 
                  com.datastax.driver.core.DataType.cdouble(),
                  com.datastax.driver.core.DataType.cdouble()
                );
com.datastax.driver.core.TupleValue r = tupleType.newValue(xmean, ymean, zmean); 
return r;'
  
CREATE OR REPLACE AGGREGATE centroid ( tuple<int, int, int> ) 
SFUNC centroidState 
STYPE tuple<int, int, int, int> 
FINALFUNC centroidFinal 
INITCOND (0, 0, 0, 0);
