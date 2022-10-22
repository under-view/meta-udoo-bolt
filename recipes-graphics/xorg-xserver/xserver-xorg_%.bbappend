PACKAGECONFIG[glamor] = "-Dglamor=true,-Dglamor=false,${@'libepoxy virtual/libgbm' if d.getVar('OPENGLX_FEATURE_ENABLED') == 'true' else 'libepoxy virtual/libgbm libegl'}"
