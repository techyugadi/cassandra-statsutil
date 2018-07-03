#### cassandra-statsutil
This repository contains Cassandra User Defined Aggregates for the following 
descriptive statistics:
1. variance and standard deviations of integers in a column (using a one-pass algorithm by Welford)
2. weighted average (or expectation) of values in a single column expressed as tuples (quantity and weightage / probability)
3. Correlation between two quantities (Pearson Coefficient) expressed as tuples of two integers in a single column
4. Centroid of variables having three dimensions ( expressed as tuple of three integers in a single column)

There is also a test.cql file with CQL statements to set up simple tables with some data to test the aggregate functions above.

You may need to create appropriate keys / indexes when using these aggregates on your database, for acceptable performance.

For example, you could run the following queries:

`
SELECT variance (data) FROM mydata WHERE txtlabel='B';
SELECT stdev (data) FROM mydata WHERE txtlabel='B';
SELECT wtaverage (data) FROM mytuples WHERE txtlabel='B';
SELECT correlation (data) FROM mycorr WHERE txtlabel='A';
SELECT centroid (xyz) FROM points WHERE txtlabel='A';
`
