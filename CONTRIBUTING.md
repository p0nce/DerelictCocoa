We tried to be maximally compatible with the OS X version D compilers support.
As of May 2016, D compilers supports OS X 10.7 or later.

As a result:
- do load functions only introduced after OS X 10.7
- do not load functions that were removed after OS X 10.7
- follow the typical Derelict style