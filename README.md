# ALPHA motors 
Database of tested motors, performance information and dynamic thrust approximations for the [ALPHA project](https://www.kthaero.com/alpha), KTH.

## *Note to contributors*

I would strongly recommend to keep the following structure:

- Data base script, in which we dump all the data from the tests
- Script/functions to compare motors (this is probably what Jacob and company will do). Could be some convenient tool to compare all entries in the data base and show the best ones , etc...
- Scripts/functions for dynamic thrust approximation 
- Scripts of other useful stuff that may be decided in the future

Any change/addition that you may do, please document it in the README.md so anyone that may be new to the repo could use the tool

As of now, committing to the main branch is okay,  however if this repo becomes more significant, the proper workflow would be: Create new issue addressing what wants to be added/corrected -> create branch for said issue -> merge to main request once you finished -> if accepted, becomes part of main.

## Motor-Propeller Database

The data is stored in a `struct` object, each index (entry) corresponds to a propeller. The required data is:

1. Name or label
2. Propeller radius (metres)
3. Propeller pitch (metres)
4. Maximum RPS (revolutions per second)
5. Throttle vector (-100 to +100 format)
6. Power vector (Watts)
7. Thrust vector (grams)

The easiest is to copy the previous entry and change with the new values accordingly. The calculations will be applied to each entry of the data base.

## Motor/ESC comparisons

> **TO DO:** Describe the scripts used to compare motor perfromance or optimization, etc...

## Dynamic Thrust Approximation

An attempt was made to approximate the dynamic thrust by analytical methods, which proved to be very inaccurate compared to experimental data in wind tunnels of similar propellers. Instead an experimental correction factor was used, as presented [by Gabriel Staples' blog](https://www.flitetest.com/articles/propeller-static-dynamic-thrust-calculation) with some sight modifications. Details on the method can be found in file [thrust approx pdf](thrust_approx.pdf).

The input parameters for `dynamic_thrust_1.m` are:

1. Altitude $h$, (geometric). This is used with an ISA atmosphere model to calculate $\rho$
2. Number of motors `n_motors`
3. Drag coefficient `CD = 0.0314` as of the current half scale design
4. Drag reference area `S_wing`
5. Propeller index to plot `prop_i`

The script `dynamic_thrust_1.m` calculates dynamic thrust for each throttle level added in the data base entry for each propeller in the data base. The plots are only performed on the motor-propeller pair chosen but this could be easily changed if comparison of propellers required.

### Results, half scale, 5x4.3x3 propeller

For the current half scale design and motors (Emax ECO II Series 2207 2400KV, prop 5x4.3x3) at full throttle, the predicted dynamic thrust and form drag is plotted below. the intersection of thrust and drag represents the maximal theoretical speed.

V <sub> max </sub> = 30 m/s = 108 km/h

The zero-thrust speed is approximately:

V <sub>T=0</sub> = 51 +- 15.3 m/s

![thrust vs drag](images/dynamic_thrust.png)
