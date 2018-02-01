REM Gets and makes the dependencies for the new sparese CVodeIntegrator
@echo off

if "x%1x"=="xklux" goto klu
if "x%1x"=="xsundialsx" goto sundials

echo "BUILD ALL"
REM Make KLU

REM For of KLU & sundials build in Windows see:
REM http://my-it-notes.com/2013/01/how-to-build-suitesparse-under-windows-using-visual-studio/
REM https://github.com/jlblancoc/suitesparse-metis-for-windows
REM https://dmerej.info/blog/post/cmake-visual-studio-and-the-command-line/
REM https://ninja-build.org/

:klu
REM Get KLU (unofficial github with Windows binaries)
git clone https://github.com/philippkraft/suitesparse-windows-binaries.git suitesparse



if "x%1x"=="xklux" goto end

:sundials
REM Get sundials (philipp's github, fixed OpenMP 3.0 problem)
git clone https://github.com/philippkraft/sundials.git sundials

cd sundials

mkdir build

cd build

cmake .. -G "NMake Makefiles" -DCMAKE_INSTALL_PREFIX=../../sundials-lib -DEXAMPLES_INSTALL=OFF 
cmake .. -DBUILD_IDA=OFF -DBUILD_IDAS=OFF -DBUILD_CVODES=OFF -DBUILD_ARKODE=OFF -DBUILD_CVODE=ON -DBUILD_KINSOL=OFF
cmake .. -DKLU_ENABLE=ON -DKLU_LIBRARY_DIR=../../suitesparse/lib/Release/x64 -DKLU_INCLUDE_DIR=../../suitesparse/include 
cmake .. -DOPENMP_ENABLE=ON -DCMAKE_BUILD_TYPE=Release
nmake
nmake install

cd ../..

:end

echo "Finished external solvers"