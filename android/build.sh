NDK="$1"
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
MAKE="$NDK/prebuilt/linux-x86_64/bin/make -j2"
TARGET_LIST=("aarch64-linux-android" "armv7a-linux-androideabi" "i686-linux-android" "x86_64-linux-android")
export API=21
export AR=$TOOLCHAIN/bin/llvm-ar

if [ ! "$NDK" ]; then
	echo "NDK não encontrado"
	exit 0
fi

for TARGET in "${TARGET_LIST[@]}"; do
mkdir "$TARGET"

if [ "$TARGET" = "armv7a-linux-androideabi" ] ; then
ARM_SOFTFP_ABI=1 NUM_THREADS=8 GEMM_MULTITHREAD_THRESHOLD=8 ONLY_CBLAS=1 TARGET=ARMV7 HOSTCC=gcc $MAKE  -C ../  \
CC="$TOOLCHAIN/bin/clang --target=$TARGET$API" \
AS="$CC"
CXX="$TOOLCHAIN/bin/clang++ --target=$TARGET$API" \
LD="$TOOLCHAIN/bin/ld"
RANLIB=$TOOLCHAIN/bin/llvm-ranlib \
STRIP=$TOOLCHAIN/bin/llvm-strip
cp ../libopenblas* $TARGET/ && $MAKE -C ../ clean
fi

if [ "$TARGET" = "i686-linux-android" ] ; then
NUM_THREADS=8 GEMM_MULTITHREAD_THRESHOLD=8 ONLY_CBLAS=1 TARGET=ATOM HOSTCC=gcc $MAKE  -C ../  \
CC="$TOOLCHAIN/bin/clang --target=$TARGET$API" \
AS="$CC"
CXX="$TOOLCHAIN/bin/clang++ --target=$TARGET$API" \
LD="$TOOLCHAIN/bin/ld"
RANLIB=$TOOLCHAIN/bin/llvm-ranlib \
STRIP=$TOOLCHAIN/bin/llvm-strip
cp ../libopenblas* $TARGET/ && $MAKE -C ../ clean
fi

if [ "$TARGET" = "x86_64-linux-android" ] ; then
NUM_THREADS=8 GEMM_MULTITHREAD_THRESHOLD=8 ONLY_CBLAS=1 TARGET=ATOM HOSTCC=gcc $MAKE  -C ../  \
CC="$TOOLCHAIN/bin/clang --target=$TARGET$API" \
AS=$CC
CXX="$TOOLCHAIN/bin/clang++ --target=$TARGET$API" \
LD="$TOOLCHAIN/bin/ld"
RANLIB=$TOOLCHAIN/bin/llvm-ranlib \
STRIP=$TOOLCHAIN/bin/llvm-strip
cp ../libopenblas* $TARGET/ && $MAKE -C ../ clean
fi

if [ $TARGET = "aarch64-linux-android" ] ; then
NUM_THREADS=8 GEMM_MULTITHREAD_THRESHOLD=8 ONLY_CBLAS=1 TARGET=ARMV8 HOSTCC=gcc $MAKE  -C ../  \
CC="$TOOLCHAIN/bin/clang --target=$TARGET$API" \
AS="$CC"
CXX="$TOOLCHAIN/bin/clang++ --target=$TARGET$API" \
LD=$TOOLCHAIN/bin/ld
RANLIB=$TOOLCHAIN/bin/llvm-ranlib \
STRIP=$TOOLCHAIN/bin/llvm-strip
cp ../libopenblas* $TARGET/ && $MAKE -C ../ clean
fi
done
