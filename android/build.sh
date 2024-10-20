NDK="$1"
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
MAKE="$NDK/prebuilt/linux-x86_64/bin/make -j$(nproc)"
TARGET_LIST=("aarch64-linux-android")
#TARGET_LIST=("aarch64-linux-android" "armv7a-linux-androideabi" "i686-linux-android" "x86_64-linux-android")
export API=21

if [ ! "$NDK" ]; then
	echo "NDK not found"
	exit 0
fi

for "TARGET_NDK" in "${TARGET_LIST[@]}"; do
mkdir "$TARGET_NDK"
PREFIX=$PWD/$TARGET_NDK

if [ "$TARGET_NDK" = "armv7a-linux-androideabi" ] ; then
ARM_SOFTFP_ABI=1 \
NUM_THREADS=8 \
GEMM_MULTITHREAD_THRESHOLD=8 \
TARGET=ARMV7 \
HOSTCC=gcc \
CC="$TOOLCHAIN/bin/clang --target=$TARGET_NDK$API" \
AS="$CC" \
CXX="$TOOLCHAIN/bin/clang++ --target=$TARGET$API" \ 
LD=$TOOLCHAIN/bin/ld AR=ar \
RANLIB=$TOOLCHAIN/bin/llvm-ranlib \ 
STRIP=$TOOLCHAIN/bin/llvm-strip \ 
PREFIX=$PREFIX \
FC=arm-linux-gnueabihf-gfortran-13 \
$MAKE -C ../ 
$MAKE install PREFIX=$PREFIX -C ../
fi

if [ "$TARGET_NDK"= "i686-linux-android" ] ; then
NUM_THREADS=8 \
GEMM_MULTITHREAD_THRESHOLD=8 \
TARGET=ATOM \
HOSTCC=gcc \
CC="$TOOLCHAIN/bin/clang --target=$TARGET_NDK$API" \
AS="$CC" \
CXX="$TOOLCHAIN/bin/clang++ --target=$TARGET$API" \
LD=$TOOLCHAIN/bin/ld \
AR=ar \
RANLIB=$TOOLCHAIN/bin/llvm-ranlib \
STRIP=$TOOLCHAIN/bin/llvm-strip \
PREFIX=$PWD/$TARGET \
FC=i686-linux-gnu-gfortran-13 \
$MAKE -C ../
$MAKE install PREFIX=$PREFIX -C ../
fi

if [ "$TARGET_NDK"= "x86_64-linux-android" ] ; then
NUM_THREADS=8 \
GEMM_MULTITHREAD_THRESHOLD=8 \
TARGET=ATOM \
HOSTCC=gcc \
CC="$TOOLCHAIN/bin/clang --target=$TARGET_NDK$API" \
AS="$CC" \
CXX="$TOOLCHAIN/bin/clang++ --target=$TARGET$API" \
LD=$TOOLCHAIN/bin/ld \
AR=ar \
RANLIB=$TOOLCHAIN/bin/llvm-ranlib \
STRIP=$TOOLCHAIN/bin/llvm-strip \
PREFIX=$PWD/$TARGET \
FC=x86_64-linux-gnu-gfortran-13
$MAKE -C ../
$MAKE install PREFIX=$PREFIX -C ../
fi

if [ $TARGET_NDK = "aarch64-linux-android" ] ; then
UM_THREADS=8 \
GEMM_MULTITHREAD_THRESHOLD=8 \
TARGET=ARMV8 \
HOSTCC=gcc \
CC="$TOOLCHAIN/bin/clang --target=$TARGET_NDK$API" \
AS="$CC" \
CXX="$TOOLCHAIN/bin/clang++ --target=$TARGET$API" \
LD=$TOOLCHAIN/bin/ld \
AR=ar \
RANLIB=$TOOLCHAIN/bin/llvm-ranlib \
STRIP=$TOOLCHAIN/bin/llvm-strip \
PREFIX=$PWD/$TARGET \
FC=aarch64-linux-gnu-gfortran-13 \
$MAKE -C ../
$MAKE install PREFIX=$PREFIX -C ../
fi
done
