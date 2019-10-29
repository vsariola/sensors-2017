*_resistance_pressure.mat
=========================

These files contain the following variables:

data
----

N x 10 double matrix, with the following columns:

1. Duty cycle (unitless). The duty cycle of the PWM used to drive the valves. 0.7 = 70% of the duty cycle is on.
2. Resistance (Ohms). The resistance of the sensor, as measured by NI USB-4065.
3. Pressure 1. This is the pressure channel that was used in the experiment. The values are as they were read by our Arduino from the pressure sensor and have to be converted to kPa by: p_kPa = (p_sensor/1024.0 - 0.1)*100.0/0.8 * 6.89475729
4. Pressure 2. Not used.
5. Pressure 3. Not used.
6. Pressure 4. Not used.
7. PWM Frequency (Hz). In these experiments, it was constant 56 Hz throughout the experiment.
8. Sample time (s). Time when this row was recorded.
9. Not used.
10. Temperature (°C). Temperature recorded from the air inlet of the actuator.

params
------

All the parameters passed to the experiment recording software, as used by src/experiments/*.m

*_curvature.mat
===============

These files contain the following variables:

imageids
---------

M x 1 array that lists the ids of the images that were taken using a DSLR camera. Each photo had the name 'IMG_XXX.jpg', where XXX is the corresponding ID. Due to the large size of the photos, they are only available from the authors by request.

results
-------
M x 5 matrix and contains the results from our machine vision algorithm applied to those photos. The machine vision algorithm attempts to detect a circular arc from the image. Each row corresponds to one image. The columns are:

1. X-coordinate where the arc starts (pixels). 1 = left edge of the image
2. Y-coordinate where the arc starts (pixels). 1 = top edge of the image
3. Angle of the tangent of the arc at the starting point (°). 0° is towards right of the photo, 90° is downwards.
4. Total length of the actuator, along the curve (pixels)
5. Difference between the final tangent and the initial tangent (°). 0 = The actuator is fully straight.

The curvature can be computed by: curvature_m = results(:,5) ./ results(:,4) / scale * pi / 180 * 100

scale
-----

contains the pixels-to-cm conversion factor, units pixels / cm.

silver_resistance_pressure.mat and silver_curvature.mat
=======================================================

Data related to Figs. 3 & 4, collected by A. Koivikko, on 2017-04-27 11:34. In this experiment, the duty cycle of the valve was slowly increased from 0.2 to 0.7 and then back to 0.2. This cycle was repeated 10 times. The actuator had a silver sensor integrated to it.

silver_resistance_vs_temperature_*.xlsx
=======================================

Data related to Fig. 5, collected by E. Sadeghian Raei. The actuator with a silver sensor was placed on a hotplate and a thermocouple was inserted inside the actuator. The resistance was measured using a multimeter. Each of the files is from one heating up cycle; the actuator was let cool down to room temperature between the experiments. The set point of the hot plate was always increased when the previous temperature was reached within the actuator.

temperature_vs_time.mat
=======================

Data related to Fig. 6, collected by A. Koivikko. There was a T-junction at the air inlet and a thermocouple was placed and sealed at the T-junction.

carbon_resistance_pressure.mat and carbon_curvature.mat
=======================================================

Data related to Fig. 7, collected by A. Koivikko. Both data files are from the same experiment. In this experiment, the duty cycle of the valve was slowly increased from 0.2 to 0.7 and then back to 0.2. This cycle was repeated 10 times. The actuator had a carbon sensor integrated to it. Note that the duty cycle was changed only every 5 rows.

blocking_resistance_pressure.mat, blocking_curvature.mat and blocking_manual_curvature.mat
==========================================================================================

Data related to Fig. 8, collected by A. Koivikko & V. Sariola. For part of the curvature values, the curves had to be picked manually instead of the machine vision algorithm, because the algorithm failed to detect the edge properly when the hand was partially hiding the bottom edge of the actuator.

dynamics.mat
============

Data related to Fig. 9, collected by A. Koivikko.

demo_resistance_pressure.mat
============================

Data related to Fig. 10, collected by A. Koivikko & V. Sariola. In this experiment, each of the three actuators of the three fingered gripper was pressurized sequentially. The actuators had silver sensors. This data corresponds to the supplementary video.

gripper_18_5_2017_4271.mp4
==========================

Notice that this file is in GitLFS. This is the video recorded of the gripper experiment for the supplementary video.
