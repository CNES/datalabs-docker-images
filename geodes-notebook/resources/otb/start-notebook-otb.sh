#!/bin/bash
# Copyright 2024 CS GROUP - https://www.csgroup.eu
# Copyright 2024 CNES - https://cnes.fr
# All rights reserved
# This file is provided under MIT license. See LICENSE file.

export PROJ_LIB=/opt/otb/share/proj
export PATH=/opt/otb/bin:$PATH
export OTB_APPLICATION_PATH=/opt/otb/lib/otb/applications
export LC_NUMERIC=C
export OTB_INSTALL_DIR=/opt/otb
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$OTB_INSTALL_DIR/lib"
export PYTHONPATH=$OTB_INSTALL_DIR/lib/otb/python

# CC=/usr/bin/gcc; /opt/otb/tools/post_install.sh && /opt/otb/recompile_bindings.sh