# Advanced Topics
## [Fast Multipole Methode(FMM) with the Boundary Element Method (BEM)](@id FMM_BEM)

There are different ways to use a FMM with a BEM. Most approaches require an internal modification of the FMM. Since an implementation of a high performance FMM is quiet difficult and is required when changing the internal structure, using highly optimized implementation such as [exafmm-t](https://github.com/exafmm/exafmm-t) is often the best approach.
 
In such an approach the FMM is used as a black box to compute point to point interactions. The points are quadrature points on each triangle of the mesh. Additionally the test and trail functions functions must be considered, which is done by weighted sums over both functions.

Integrating with a quadrature only works out for far triangles which are well separated. For close interactions the function becomes singular and the integral inaccurate. This inaccuracy must be corrected by subtraction of a correction matrix containing all close interactions from the FMM evaluation. The close interactions can afterwards be computed directly and added to the rest. 

As a formula this reads as follows

$$Ax = B_2^T(G-C)B_1x + Sx\,,$$

where $G$ is the evaluation done by the FMM, $C$ the correction matrix of the close interaction, $P_1$ and $P_2$ the matrices resembling the test and trail functions and $S$ the directly computed close interactions. 

More detailed information on this topic can be found in 
- Wang, Tingyu, Christopher D. Cooper, Timo Betcke, and Lorena A. Barba. “High-Productivity, High-Performance Workflow for Virus-Scale Electrostatic Simulations with Bempp-Exafmm.” arXiv, March 20, 2021. http://arxiv.org/abs/2103.01048.
- Adelman, Ross, Nail A. Gumerov, and Ramani Duraiswami. “FMM/GPU-Accelerated Boundary Element Method for Computational Magnetics and Electrostatics.” IEEE Transactions on Magnetics 53, no. 12 (December 2017): 1–11. https://doi.org/10.1109/TMAG.2017.2725951.
