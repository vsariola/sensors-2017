# sensors-2017

Code related to the publication: Koivikko et al. "Screen-printed curvature sensors for soft robots" *IEEE Sensors J.*, vol. 18, no. 1, 2018.

DOI: 10.1109/JSEN.2017.2765745

http://dx.doi.org/10.1109/JSEN.2017.2765745

If you find the code or data useful, please cite that paper.

What is it?
===========

This repository contains the data and Matlab code to recreate the plots in the paper. The code was written using Matlab R2016a.

How to use it?
==============

1. Change your Matlab directory to <reposity>/src
2. Run any of the scripts "Fig_*.m" to recreate the particular figure.

Run `SupplemenaryVideo.m` to recreate the supplementary video. Notice that the raw video data is in GitLFS, so you should have GitLFS installed to get the video from the repository.

Data is under data/ directory. See data/README.md for documentation of the data files.

License
=======

The code is licensed under MIT license (see LICENSE).

The figures and the paper are licensed under  Creative Commons Attribution 3.0 License.

The code uses the export_fig library, downloaded from https://se.mathworks.com/matlabcentral/fileexchange/23629-export-fig. See src/export_fig/LICENSE for it's license.
