# learning_dynamical_systems

This repo builds on [`ds-opt`](https://github.com/nbfigueroa/ds-opt) to explore (1) transfer learning between similar datasets, and (2) different regression methods.

To get started, clone [`ds-opt`](https://github.com/nbfigueroa/ds-opt) and its necessary dependencies. Then clone this repo, place it inside `ds-opt`, and add it to the MATLAB path.

The main scripts to run everything all begin with `demo`, e.g. `./deep_learning/demo_learn_dl.m`. However, `loop_demo.m` can be used to run a `demo` file multiple times once the necessary parameters have been set.

Currently, the `linear_parameter_varying` folder holds files needed for transferring learned parameters between datasets using the original LPV-DS method, while `deep_learning` and `multivariate_regression` hold different methods for learning a single dynamical system.

Have fun!


