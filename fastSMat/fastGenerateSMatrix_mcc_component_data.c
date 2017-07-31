/*
 * MATLAB Compiler: 4.8 (R2008a)
 * Date: Wed Dec  4 09:49:53 2013
 * Arguments: "-B" "macro_default" "-m" "-W" "main" "-T" "link:exe"
 * "fastGenerateSMatrix.m" 
 */

#include "mclmcrrt.h"

#ifdef __cplusplus
extern "C" {
#endif
const unsigned char __MCC_fastGenerateSMatrix_session_key[] = {
    '8', 'D', 'D', '6', '5', 'C', 'E', '3', 'D', '9', '2', '5', '8', '7', '5',
    'E', 'B', '1', '2', '7', '2', '9', 'A', '8', '4', 'D', 'D', '4', 'A', '1',
    '5', '7', 'B', 'A', 'B', '0', 'D', '2', '9', '6', '2', '7', '8', '1', '8',
    '1', 'B', '9', 'F', '1', 'C', '1', '2', 'F', 'D', 'B', 'A', '6', 'F', '9',
    '5', 'D', 'A', '8', 'A', '3', '5', 'B', '4', 'F', 'D', 'A', '5', '7', '5',
    'B', '6', 'F', '6', '7', '2', '7', '7', '7', '7', 'E', '0', '8', '5', '4',
    '9', 'C', '5', '9', '7', 'A', 'B', '9', '4', '0', '7', '3', '6', 'C', '3',
    '0', '4', 'D', '0', '6', 'B', 'D', 'F', '4', 'F', '5', '8', 'D', '1', '3',
    '2', '5', 'C', 'C', 'F', 'E', '1', '8', 'C', '4', '1', '4', '3', 'F', '2',
    'E', '3', 'A', 'A', '3', '4', '9', '0', '1', 'F', '3', '5', '9', '0', '7',
    'F', '4', '8', 'F', 'D', '2', '9', 'C', '1', '9', 'A', '3', '5', 'F', '1',
    'B', '3', '9', '5', '8', '7', 'D', 'B', 'C', 'E', 'C', '0', '0', '9', 'E',
    '6', 'A', 'A', '8', '0', '4', '5', 'E', '9', '5', '1', '7', '4', '2', '1',
    '2', '6', '9', 'A', '1', '6', '7', '6', '2', '0', '4', '3', '2', '1', '4',
    '8', '5', 'B', '3', 'C', '6', '3', '3', '8', '9', 'E', '4', '8', 'A', 'E',
    '3', 'B', '3', '2', 'D', '9', '5', '3', '8', '6', '1', 'B', 'F', '7', '6',
    '8', 'A', '1', '9', 'F', 'C', '2', 'D', '2', '0', '3', 'B', '0', '4', '3',
    'A', '\0'};

const unsigned char __MCC_fastGenerateSMatrix_public_key[] = {
    '3', '0', '8', '1', '9', 'D', '3', '0', '0', 'D', '0', '6', '0', '9', '2',
    'A', '8', '6', '4', '8', '8', '6', 'F', '7', '0', 'D', '0', '1', '0', '1',
    '0', '1', '0', '5', '0', '0', '0', '3', '8', '1', '8', 'B', '0', '0', '3',
    '0', '8', '1', '8', '7', '0', '2', '8', '1', '8', '1', '0', '0', 'C', '4',
    '9', 'C', 'A', 'C', '3', '4', 'E', 'D', '1', '3', 'A', '5', '2', '0', '6',
    '5', '8', 'F', '6', 'F', '8', 'E', '0', '1', '3', '8', 'C', '4', '3', '1',
    '5', 'B', '4', '3', '1', '5', '2', '7', '7', 'E', 'D', '3', 'F', '7', 'D',
    'A', 'E', '5', '3', '0', '9', '9', 'D', 'B', '0', '8', 'E', 'E', '5', '8',
    '9', 'F', '8', '0', '4', 'D', '4', 'B', '9', '8', '1', '3', '2', '6', 'A',
    '5', '2', 'C', 'C', 'E', '4', '3', '8', '2', 'E', '9', 'F', '2', 'B', '4',
    'D', '0', '8', '5', 'E', 'B', '9', '5', '0', 'C', '7', 'A', 'B', '1', '2',
    'E', 'D', 'E', '2', 'D', '4', '1', '2', '9', '7', '8', '2', '0', 'E', '6',
    '3', '7', '7', 'A', '5', 'F', 'E', 'B', '5', '6', '8', '9', 'D', '4', 'E',
    '6', '0', '3', '2', 'F', '6', '0', 'C', '4', '3', '0', '7', '4', 'A', '0',
    '4', 'C', '2', '6', 'A', 'B', '7', '2', 'F', '5', '4', 'B', '5', '1', 'B',
    'B', '4', '6', '0', '5', '7', '8', '7', '8', '5', 'B', '1', '9', '9', '0',
    '1', '4', '3', '1', '4', 'A', '6', '5', 'F', '0', '9', '0', 'B', '6', '1',
    'F', 'C', '2', '0', '1', '6', '9', '4', '5', '3', 'B', '5', '8', 'F', 'C',
    '8', 'B', 'A', '4', '3', 'E', '6', '7', '7', '6', 'E', 'B', '7', 'E', 'C',
    'D', '3', '1', '7', '8', 'B', '5', '6', 'A', 'B', '0', 'F', 'A', '0', '6',
    'D', 'D', '6', '4', '9', '6', '7', 'C', 'B', '1', '4', '9', 'E', '5', '0',
    '2', '0', '1', '1', '1', '\0'};

static const char * MCC_fastGenerateSMatrix_matlabpath_data[] = 
  { "fastGenerate/", "toolbox/compiler/deploy/",
    "home/gcunning/matlab/db/", "$TOOLBOXMATLABDIR/general/",
    "$TOOLBOXMATLABDIR/ops/", "$TOOLBOXMATLABDIR/lang/",
    "$TOOLBOXMATLABDIR/elmat/", "$TOOLBOXMATLABDIR/elfun/",
    "$TOOLBOXMATLABDIR/specfun/", "$TOOLBOXMATLABDIR/matfun/",
    "$TOOLBOXMATLABDIR/datafun/", "$TOOLBOXMATLABDIR/polyfun/",
    "$TOOLBOXMATLABDIR/funfun/", "$TOOLBOXMATLABDIR/sparfun/",
    "$TOOLBOXMATLABDIR/scribe/", "$TOOLBOXMATLABDIR/graph2d/",
    "$TOOLBOXMATLABDIR/graph3d/", "$TOOLBOXMATLABDIR/specgraph/",
    "$TOOLBOXMATLABDIR/graphics/", "$TOOLBOXMATLABDIR/uitools/",
    "$TOOLBOXMATLABDIR/strfun/", "$TOOLBOXMATLABDIR/imagesci/",
    "$TOOLBOXMATLABDIR/iofun/", "$TOOLBOXMATLABDIR/audiovideo/",
    "$TOOLBOXMATLABDIR/timefun/", "$TOOLBOXMATLABDIR/datatypes/",
    "$TOOLBOXMATLABDIR/verctrl/", "$TOOLBOXMATLABDIR/codetools/",
    "$TOOLBOXMATLABDIR/helptools/", "$TOOLBOXMATLABDIR/demos/",
    "$TOOLBOXMATLABDIR/timeseries/", "$TOOLBOXMATLABDIR/hds/",
    "$TOOLBOXMATLABDIR/guide/", "$TOOLBOXMATLABDIR/plottools/",
    "toolbox/local/", "toolbox/shared/dastudio/",
    "$TOOLBOXMATLABDIR/datamanager/", "toolbox/compiler/" };

static const char * MCC_fastGenerateSMatrix_classpath_data[] = 
  { "" };

static const char * MCC_fastGenerateSMatrix_libpath_data[] = 
  { "" };

static const char * MCC_fastGenerateSMatrix_app_opts_data[] = 
  { "" };

static const char * MCC_fastGenerateSMatrix_run_opts_data[] = 
  { "" };

static const char * MCC_fastGenerateSMatrix_warning_state_data[] = 
  { "off:MATLAB:dispatcher:nameConflict" };


mclComponentData __MCC_fastGenerateSMatrix_component_data = { 

  /* Public key data */
  __MCC_fastGenerateSMatrix_public_key,

  /* Component name */
  "fastGenerateSMatrix",

  /* Component Root */
  "",

  /* Application key data */
  __MCC_fastGenerateSMatrix_session_key,

  /* Component's MATLAB Path */
  MCC_fastGenerateSMatrix_matlabpath_data,

  /* Number of directories in the MATLAB Path */
  38,

  /* Component's Java class path */
  MCC_fastGenerateSMatrix_classpath_data,
  /* Number of directories in the Java class path */
  0,

  /* Component's load library path (for extra shared libraries) */
  MCC_fastGenerateSMatrix_libpath_data,
  /* Number of directories in the load library path */
  0,

  /* MCR instance-specific runtime options */
  MCC_fastGenerateSMatrix_app_opts_data,
  /* Number of MCR instance-specific runtime options */
  0,

  /* MCR global runtime options */
  MCC_fastGenerateSMatrix_run_opts_data,
  /* Number of MCR global runtime options */
  0,
  
  /* Component preferences directory */
  "fastGenerate_979563A7221A227AEEB88667CC7D8B5C",

  /* MCR warning status data */
  MCC_fastGenerateSMatrix_warning_state_data,
  /* Number of MCR warning status modifiers */
  1,

  /* Path to component - evaluated at runtime */
  NULL

};

#ifdef __cplusplus
}
#endif


