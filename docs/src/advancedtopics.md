# Advanced Topics
### Fast Multipole Methode in Boundary Element Method

The FMM can be used to accelerate the BEM. There are different ways to achieve this. This package wraps a highly modified FMM code which is quiet fast as it is. 
To use the FMM in the BEM you either have to modify the internal calculations of the FMM or modify the BEM such that the FMM is used as a blackbox for point to point interactions.

Since modifying a FMM code or programming one completely is quiet cumbersome the second approach is often the easier one. 

Such an approach is implemented in the (FastBEAST)[https://github.com/sbadrian/FastBEAST] package. In this package the exafmm wrapper of the exafmm-t library is used to accelerate the BEM computation. More detailed information concerning this topic can be found in the documentation of (FastBEAST)[https://github.com/sbadrian/FastBEAST].