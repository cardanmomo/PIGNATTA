/*
 * MATLAB Compiler: 4.8 (R2008a)
 * Date: Wed Jul 16 17:03:50 2014
 * Arguments: "-B" "macro_default" "-o" "fastParallelCalcSensitivityColumn"
 * "-W" "main" "-d" "/home/lpang/work/zame/fastSMat/" "-T" "link:exe" "-R"
 * "-nojvm" "-R" "-nodisplay" "-N"
 * "/home/lpang/work/zame/fastSMat/fastParallelCalcSensitivityColumn.m" "-a"
 * "/home/lpang/work/zame/fastSMat/fastGenerateSMatrix.m" "-a"
 * "/home/lpang/work/zame/fastSMat/fastParallelCalcSensitivityMatrix.m" 
 */

#include <stdio.h>
#include "mclmcrrt.h"
#ifdef __cplusplus
extern "C" {
#endif

extern mclComponentData __MCC_fastParallelCalcSensitivityColumn_component_data;

#ifdef __cplusplus
}
#endif

static HMCRINSTANCE _mcr_inst = NULL;


#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultPrintHandler(const char *s)
{
  return mclWrite(1 /* stdout */, s, sizeof(char)*strlen(s));
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

#ifdef __cplusplus
extern "C" {
#endif

static int mclDefaultErrorHandler(const char *s)
{
  int written = 0;
  size_t len = 0;
  len = strlen(s);
  written = mclWrite(2 /* stderr */, s, sizeof(char)*len);
  if (len > 0 && s[ len-1 ] != '\n')
    written += mclWrite(2 /* stderr */, "\n", sizeof(char));
  return written;
}

#ifdef __cplusplus
} /* End extern "C" block */
#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_fastParallelCalcSensitivityColumn_C_API 
#define LIB_fastParallelCalcSensitivityColumn_C_API /* No special import/export declaration */
#endif

LIB_fastParallelCalcSensitivityColumn_C_API 
bool MW_CALL_CONV fastParallelCalcSensitivityColumnInitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler
)
{
  if (_mcr_inst != NULL)
    return true;
  if (!mclmcrInitialize())
    return false;
  if (!mclInitializeComponentInstanceWithEmbeddedCTF(&_mcr_inst,
                                                     &__MCC_fastParallelCalcSensitivityColumn_component_data,
                                                     true, NoObjectType,
                                                     ExeTarget, error_handler,
                                                     print_handler, 71421, (void *)(fastParallelCalcSensitivityColumnInitializeWithHandlers)))
    return false;
  return true;
}

LIB_fastParallelCalcSensitivityColumn_C_API 
bool MW_CALL_CONV fastParallelCalcSensitivityColumnInitialize(void)
{
  return fastParallelCalcSensitivityColumnInitializeWithHandlers(mclDefaultErrorHandler,
                                                                 mclDefaultPrintHandler);
}

LIB_fastParallelCalcSensitivityColumn_C_API 
void MW_CALL_CONV fastParallelCalcSensitivityColumnTerminate(void)
{
  if (_mcr_inst != NULL)
    mclTerminateInstance(&_mcr_inst);
}

int run_main(int argc, const char **argv)
{
  int _retval;
  /* Generate and populate the path_to_component. */
  char path_to_component[(PATH_MAX*2)+1];
  separatePathName(argv[0], path_to_component, (PATH_MAX*2)+1);
  __MCC_fastParallelCalcSensitivityColumn_component_data.path_to_component = path_to_component; 
  if (!fastParallelCalcSensitivityColumnInitialize()) {
    return -1;
  }
  _retval = mclMain(_mcr_inst, argc, argv,
                    "fastParallelCalcSensitivityColumn", 1);
  if (_retval == 0 /* no error */) mclWaitForFiguresToDie(NULL);
  fastParallelCalcSensitivityColumnTerminate();
  mclTerminateApplication();
  return _retval;
}

int main(int argc, const char **argv)
{
  if (!mclInitializeApplication(
    __MCC_fastParallelCalcSensitivityColumn_component_data.runtime_options,
    __MCC_fastParallelCalcSensitivityColumn_component_data.runtime_option_count))
    return 0;
  
  return mclRunMain(run_main, argc, argv);
}
