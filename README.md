DerelictCocoa
=============

*Warning: this an unofficial Derelict binding.*

A dynamic binding to [Cocoa](http://leenissen.dk/fann/wp/) for the D Programming Language. **This binding is incomplete. Use PR to add more stuff.**

For information on how to build DerelictCocoa and link it with your programs, please see the post [Using Derelict](http://dblog.aldacron.net/derelict-help/using-derelict/) at The One With D.

For information on how to load the Cocoa framework via DerelictCocoa, see the page [DerelictUtil for Users](https://github.com/DerelictOrg/DerelictUtil/wiki/DerelictUtil-for-Users) at the DerelictUtil Wiki. In the meantime, here's some sample code.

```D
import derelict.cocoa;

void main() {
    // Load the Cocoa framework.
    DerelictCocoa.load();

    // Now Cocoa functions can be called
    ...
}
```

