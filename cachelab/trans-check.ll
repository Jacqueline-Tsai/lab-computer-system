; ModuleID = 'trans.c'
source_filename = "trans.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque

@.str = private unnamed_addr constant [21 x i8] c"Transpose submission\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"Basic\00", align 1
@.str.2 = private unnamed_addr constant [25 x i8] c"is_transpose(M, N, A, B)\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c"trans.c\00", align 1
@__PRETTY_FUNCTION__.transpose_submit = private unnamed_addr constant [78 x i8] c"void transpose_submit(size_t, size_t, double (*)[M], double (*)[N], double *)\00", align 1
@.str.4 = private unnamed_addr constant [27 x i8] c"M_start >= 0 && M_end <= M\00", align 1
@__PRETTY_FUNCTION__.trans_block = private unnamed_addr constant [105 x i8] c"void trans_block(size_t, size_t, double (*)[M], double (*)[N], double *, size_t, size_t, size_t, size_t)\00", align 1
@.str.5 = private unnamed_addr constant [27 x i8] c"N_start >= 0 && N_end <= N\00", align 1
@__PRETTY_FUNCTION__.trans_block_diag = private unnamed_addr constant [110 x i8] c"void trans_block_diag(size_t, size_t, double (*)[M], double (*)[N], double *, size_t, size_t, size_t, size_t)\00", align 1
@.str.6 = private unnamed_addr constant [19 x i8] c"M_start == N_start\00", align 1
@stderr = external global %struct._IO_FILE*, align 8
@.str.7 = private unnamed_addr constant [72 x i8] c"Transpose incorrect.  Fails for B[%zd][%zd] = %.3f, A[%zd][%zd] = %.3f\0A\00", align 1
@.str.8 = private unnamed_addr constant [6 x i8] c"M > 0\00", align 1
@__PRETTY_FUNCTION__.trans_basic = private unnamed_addr constant [73 x i8] c"void trans_basic(size_t, size_t, double (*)[M], double (*)[N], double *)\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c"N > 0\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @registerFunctions() #0 !dbg !10 {
  call void @registerTransFunction(void (i64, i64, double*, double*, double*)* noundef @transpose_submit, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0)), !dbg !14
  call void @registerTransFunction(void (i64, i64, double*, double*, double*)* noundef @trans_basic, i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i64 0, i64 0)), !dbg !15
  ret void, !dbg !16
}

declare void @registerTransFunction(void (i64, i64, double*, double*, double*)* noundef, i8* noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal void @transpose_submit(i64 noundef %0, i64 noundef %1, double* noundef %2, double* noundef %3, double* noundef %4) #0 !dbg !17 {
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca double*, align 8
  %9 = alloca double*, align 8
  %10 = alloca double*, align 8
  %11 = alloca i64, align 8
  %12 = alloca i64, align 8
  store i64 %0, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !29, metadata !DIExpression()), !dbg !30
  store i64 %1, i64* %7, align 8
  call void @llvm.dbg.declare(metadata i64* %7, metadata !31, metadata !DIExpression()), !dbg !32
  store double* %2, double** %8, align 8
  call void @llvm.dbg.declare(metadata double** %8, metadata !33, metadata !DIExpression()), !dbg !34
  store double* %3, double** %9, align 8
  call void @llvm.dbg.declare(metadata double** %9, metadata !35, metadata !DIExpression()), !dbg !36
  store double* %4, double** %10, align 8
  call void @llvm.dbg.declare(metadata double** %10, metadata !37, metadata !DIExpression()), !dbg !38
  %13 = load i64, i64* %7, align 8, !dbg !39
  %14 = load i64, i64* %6, align 8, !dbg !40
  %15 = load i64, i64* %6, align 8, !dbg !41
  %16 = load i64, i64* %7, align 8, !dbg !42
  %17 = load i64, i64* %6, align 8, !dbg !43
  %18 = load i64, i64* %7, align 8, !dbg !45
  %19 = icmp ne i64 %17, %18, !dbg !46
  br i1 %19, label %24, label %20, !dbg !47

20:                                               ; preds = %5
  %21 = load i64, i64* %6, align 8, !dbg !48
  %22 = urem i64 %21, 8, !dbg !49
  %23 = icmp ne i64 %22, 0, !dbg !50
  br i1 %23, label %24, label %30, !dbg !51

24:                                               ; preds = %20, %5
  %25 = load i64, i64* %6, align 8, !dbg !52
  %26 = load i64, i64* %7, align 8, !dbg !54
  %27 = load double*, double** %8, align 8, !dbg !55
  %28 = load double*, double** %9, align 8, !dbg !56
  %29 = load double*, double** %10, align 8, !dbg !57
  call void @trans_basic(i64 noundef %25, i64 noundef %26, double* noundef %27, double* noundef %28, double* noundef %29), !dbg !58
  br label %89, !dbg !59

30:                                               ; preds = %20
  call void @llvm.dbg.declare(metadata i64* %11, metadata !60, metadata !DIExpression()), !dbg !62
  store i64 0, i64* %11, align 8, !dbg !62
  br label %31, !dbg !63

31:                                               ; preds = %77, %30
  %32 = load i64, i64* %11, align 8, !dbg !64
  %33 = load i64, i64* %7, align 8, !dbg !66
  %34 = udiv i64 %33, 8, !dbg !67
  %35 = mul i64 %34, 8, !dbg !68
  %36 = icmp ult i64 %32, %35, !dbg !69
  br i1 %36, label %37, label %80, !dbg !70

37:                                               ; preds = %31
  call void @llvm.dbg.declare(metadata i64* %12, metadata !71, metadata !DIExpression()), !dbg !74
  store i64 0, i64* %12, align 8, !dbg !74
  br label %38, !dbg !75

38:                                               ; preds = %73, %37
  %39 = load i64, i64* %12, align 8, !dbg !76
  %40 = load i64, i64* %6, align 8, !dbg !78
  %41 = udiv i64 %40, 8, !dbg !79
  %42 = mul i64 %41, 8, !dbg !80
  %43 = icmp ult i64 %39, %42, !dbg !81
  br i1 %43, label %44, label %76, !dbg !82

44:                                               ; preds = %38
  %45 = load i64, i64* %11, align 8, !dbg !83
  %46 = load i64, i64* %12, align 8, !dbg !86
  %47 = icmp ne i64 %45, %46, !dbg !87
  br i1 %47, label %48, label %60, !dbg !88

48:                                               ; preds = %44
  %49 = load i64, i64* %6, align 8, !dbg !89
  %50 = load i64, i64* %7, align 8, !dbg !91
  %51 = load double*, double** %8, align 8, !dbg !92
  %52 = load double*, double** %9, align 8, !dbg !93
  %53 = load double*, double** %10, align 8, !dbg !94
  %54 = load i64, i64* %11, align 8, !dbg !95
  %55 = load i64, i64* %12, align 8, !dbg !96
  %56 = load i64, i64* %11, align 8, !dbg !97
  %57 = add i64 %56, 8, !dbg !98
  %58 = load i64, i64* %12, align 8, !dbg !99
  %59 = add i64 %58, 8, !dbg !100
  call void @trans_block(i64 noundef %49, i64 noundef %50, double* noundef %51, double* noundef %52, double* noundef %53, i64 noundef %54, i64 noundef %55, i64 noundef %57, i64 noundef %59), !dbg !101
  br label %72, !dbg !102

60:                                               ; preds = %44
  %61 = load i64, i64* %6, align 8, !dbg !103
  %62 = load i64, i64* %7, align 8, !dbg !105
  %63 = load double*, double** %8, align 8, !dbg !106
  %64 = load double*, double** %9, align 8, !dbg !107
  %65 = load double*, double** %10, align 8, !dbg !108
  %66 = load i64, i64* %11, align 8, !dbg !109
  %67 = load i64, i64* %12, align 8, !dbg !110
  %68 = load i64, i64* %11, align 8, !dbg !111
  %69 = add i64 %68, 8, !dbg !112
  %70 = load i64, i64* %12, align 8, !dbg !113
  %71 = add i64 %70, 8, !dbg !114
  call void @trans_block_diag(i64 noundef %61, i64 noundef %62, double* noundef %63, double* noundef %64, double* noundef %65, i64 noundef %66, i64 noundef %67, i64 noundef %69, i64 noundef %71), !dbg !115
  br label %72

72:                                               ; preds = %60, %48
  br label %73, !dbg !116

73:                                               ; preds = %72
  %74 = load i64, i64* %12, align 8, !dbg !117
  %75 = add i64 %74, 8, !dbg !117
  store i64 %75, i64* %12, align 8, !dbg !117
  br label %38, !dbg !118, !llvm.loop !119

76:                                               ; preds = %38
  br label %77, !dbg !121

77:                                               ; preds = %76
  %78 = load i64, i64* %11, align 8, !dbg !122
  %79 = add i64 %78, 8, !dbg !122
  store i64 %79, i64* %11, align 8, !dbg !122
  br label %31, !dbg !123, !llvm.loop !124

80:                                               ; preds = %31
  %81 = load i64, i64* %6, align 8, !dbg !126
  %82 = load i64, i64* %7, align 8, !dbg !126
  %83 = load double*, double** %8, align 8, !dbg !126
  %84 = load double*, double** %9, align 8, !dbg !126
  %85 = call zeroext i1 @is_transpose(i64 noundef %81, i64 noundef %82, double* noundef %83, double* noundef %84), !dbg !126
  br i1 %85, label %86, label %87, !dbg !126

86:                                               ; preds = %80
  br label %89, !dbg !126

87:                                               ; preds = %80
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0), i32 noundef 201, i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @__PRETTY_FUNCTION__.transpose_submit, i64 0, i64 0)) #4, !dbg !126
  unreachable, !dbg !126

88:                                               ; No predecessors!
  br label %89, !dbg !126

89:                                               ; preds = %24, %88, %86
  ret void, !dbg !127
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @trans_basic(i64 noundef %0, i64 noundef %1, double* noundef %2, double* noundef %3, double* noundef %4) #0 !dbg !128 {
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca double*, align 8
  %9 = alloca double*, align 8
  %10 = alloca double*, align 8
  %11 = alloca i64, align 8
  %12 = alloca i64, align 8
  store i64 %0, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !129, metadata !DIExpression()), !dbg !130
  store i64 %1, i64* %7, align 8
  call void @llvm.dbg.declare(metadata i64* %7, metadata !131, metadata !DIExpression()), !dbg !132
  store double* %2, double** %8, align 8
  call void @llvm.dbg.declare(metadata double** %8, metadata !133, metadata !DIExpression()), !dbg !134
  store double* %3, double** %9, align 8
  call void @llvm.dbg.declare(metadata double** %9, metadata !135, metadata !DIExpression()), !dbg !136
  store double* %4, double** %10, align 8
  call void @llvm.dbg.declare(metadata double** %10, metadata !137, metadata !DIExpression()), !dbg !138
  %13 = load i64, i64* %7, align 8, !dbg !139
  %14 = load i64, i64* %6, align 8, !dbg !140
  %15 = load i64, i64* %6, align 8, !dbg !141
  %16 = load i64, i64* %7, align 8, !dbg !142
  %17 = load i64, i64* %6, align 8, !dbg !143
  %18 = icmp ugt i64 %17, 0, !dbg !143
  br i1 %18, label %19, label %20, !dbg !143

19:                                               ; preds = %5
  br label %22, !dbg !143

20:                                               ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.8, i64 0, i64 0), i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0), i32 noundef 84, i8* noundef getelementptr inbounds ([73 x i8], [73 x i8]* @__PRETTY_FUNCTION__.trans_basic, i64 0, i64 0)) #4, !dbg !143
  unreachable, !dbg !143

21:                                               ; No predecessors!
  br label %22, !dbg !143

22:                                               ; preds = %21, %19
  %23 = load i64, i64* %7, align 8, !dbg !144
  %24 = icmp ugt i64 %23, 0, !dbg !144
  br i1 %24, label %25, label %26, !dbg !144

25:                                               ; preds = %22
  br label %28, !dbg !144

26:                                               ; preds = %22
  call void @__assert_fail(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0), i32 noundef 85, i8* noundef getelementptr inbounds ([73 x i8], [73 x i8]* @__PRETTY_FUNCTION__.trans_basic, i64 0, i64 0)) #4, !dbg !144
  unreachable, !dbg !144

27:                                               ; No predecessors!
  br label %28, !dbg !144

28:                                               ; preds = %27, %25
  call void @llvm.dbg.declare(metadata i64* %11, metadata !145, metadata !DIExpression()), !dbg !147
  store i64 0, i64* %11, align 8, !dbg !147
  br label %29, !dbg !148

29:                                               ; preds = %56, %28
  %30 = load i64, i64* %11, align 8, !dbg !149
  %31 = load i64, i64* %7, align 8, !dbg !151
  %32 = icmp ult i64 %30, %31, !dbg !152
  br i1 %32, label %33, label %59, !dbg !153

33:                                               ; preds = %29
  call void @llvm.dbg.declare(metadata i64* %12, metadata !154, metadata !DIExpression()), !dbg !157
  store i64 0, i64* %12, align 8, !dbg !157
  br label %34, !dbg !158

34:                                               ; preds = %52, %33
  %35 = load i64, i64* %12, align 8, !dbg !159
  %36 = load i64, i64* %6, align 8, !dbg !161
  %37 = icmp ult i64 %35, %36, !dbg !162
  br i1 %37, label %38, label %55, !dbg !163

38:                                               ; preds = %34
  %39 = load double*, double** %8, align 8, !dbg !164
  %40 = load i64, i64* %11, align 8, !dbg !166
  %41 = mul nsw i64 %40, %14, !dbg !164
  %42 = getelementptr inbounds double, double* %39, i64 %41, !dbg !164
  %43 = load i64, i64* %12, align 8, !dbg !167
  %44 = getelementptr inbounds double, double* %42, i64 %43, !dbg !164
  %45 = load double, double* %44, align 8, !dbg !164
  %46 = load double*, double** %9, align 8, !dbg !168
  %47 = load i64, i64* %12, align 8, !dbg !169
  %48 = mul nsw i64 %47, %16, !dbg !168
  %49 = getelementptr inbounds double, double* %46, i64 %48, !dbg !168
  %50 = load i64, i64* %11, align 8, !dbg !170
  %51 = getelementptr inbounds double, double* %49, i64 %50, !dbg !168
  store double %45, double* %51, align 8, !dbg !171
  br label %52, !dbg !172

52:                                               ; preds = %38
  %53 = load i64, i64* %12, align 8, !dbg !173
  %54 = add i64 %53, 1, !dbg !173
  store i64 %54, i64* %12, align 8, !dbg !173
  br label %34, !dbg !174, !llvm.loop !175

55:                                               ; preds = %34
  br label %56, !dbg !177

56:                                               ; preds = %55
  %57 = load i64, i64* %11, align 8, !dbg !178
  %58 = add i64 %57, 1, !dbg !178
  store i64 %58, i64* %11, align 8, !dbg !178
  br label %29, !dbg !179, !llvm.loop !180

59:                                               ; preds = %29
  %60 = load i64, i64* %6, align 8, !dbg !182
  %61 = load i64, i64* %7, align 8, !dbg !182
  %62 = load double*, double** %8, align 8, !dbg !182
  %63 = load double*, double** %9, align 8, !dbg !182
  %64 = call zeroext i1 @is_transpose(i64 noundef %60, i64 noundef %61, double* noundef %62, double* noundef %63), !dbg !182
  br i1 %64, label %65, label %66, !dbg !182

65:                                               ; preds = %59
  br label %68, !dbg !182

66:                                               ; preds = %59
  call void @__assert_fail(i8* noundef getelementptr inbounds ([25 x i8], [25 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0), i32 noundef 93, i8* noundef getelementptr inbounds ([73 x i8], [73 x i8]* @__PRETTY_FUNCTION__.trans_basic, i64 0, i64 0)) #4, !dbg !182
  unreachable, !dbg !182

67:                                               ; No predecessors!
  br label %68, !dbg !182

68:                                               ; preds = %67, %65
  ret void, !dbg !183
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal void @trans_block(i64 noundef %0, i64 noundef %1, double* noundef %2, double* noundef %3, double* noundef %4, i64 noundef %5, i64 noundef %6, i64 noundef %7, i64 noundef %8) #0 !dbg !184 {
  %10 = alloca i64, align 8
  %11 = alloca i64, align 8
  %12 = alloca double*, align 8
  %13 = alloca double*, align 8
  %14 = alloca double*, align 8
  %15 = alloca i64, align 8
  %16 = alloca i64, align 8
  %17 = alloca i64, align 8
  %18 = alloca i64, align 8
  %19 = alloca i64, align 8
  %20 = alloca i64, align 8
  store i64 %0, i64* %10, align 8
  call void @llvm.dbg.declare(metadata i64* %10, metadata !187, metadata !DIExpression()), !dbg !188
  store i64 %1, i64* %11, align 8
  call void @llvm.dbg.declare(metadata i64* %11, metadata !189, metadata !DIExpression()), !dbg !190
  store double* %2, double** %12, align 8
  call void @llvm.dbg.declare(metadata double** %12, metadata !191, metadata !DIExpression()), !dbg !192
  store double* %3, double** %13, align 8
  call void @llvm.dbg.declare(metadata double** %13, metadata !193, metadata !DIExpression()), !dbg !194
  store double* %4, double** %14, align 8
  call void @llvm.dbg.declare(metadata double** %14, metadata !195, metadata !DIExpression()), !dbg !196
  store i64 %5, i64* %15, align 8
  call void @llvm.dbg.declare(metadata i64* %15, metadata !197, metadata !DIExpression()), !dbg !198
  store i64 %6, i64* %16, align 8
  call void @llvm.dbg.declare(metadata i64* %16, metadata !199, metadata !DIExpression()), !dbg !200
  store i64 %7, i64* %17, align 8
  call void @llvm.dbg.declare(metadata i64* %17, metadata !201, metadata !DIExpression()), !dbg !202
  store i64 %8, i64* %18, align 8
  call void @llvm.dbg.declare(metadata i64* %18, metadata !203, metadata !DIExpression()), !dbg !204
  %21 = load i64, i64* %11, align 8, !dbg !205
  %22 = load i64, i64* %10, align 8, !dbg !206
  %23 = load i64, i64* %10, align 8, !dbg !207
  %24 = load i64, i64* %11, align 8, !dbg !208
  %25 = load i64, i64* %15, align 8, !dbg !209
  %26 = icmp uge i64 %25, 0, !dbg !209
  br i1 %26, label %27, label %32, !dbg !209

27:                                               ; preds = %9
  %28 = load i64, i64* %17, align 8, !dbg !209
  %29 = load i64, i64* %10, align 8, !dbg !209
  %30 = icmp ule i64 %28, %29, !dbg !209
  br i1 %30, label %31, label %32, !dbg !209

31:                                               ; preds = %27
  br label %34, !dbg !209

32:                                               ; preds = %27, %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0), i32 noundef 117, i8* noundef getelementptr inbounds ([105 x i8], [105 x i8]* @__PRETTY_FUNCTION__.trans_block, i64 0, i64 0)) #4, !dbg !209
  unreachable, !dbg !209

33:                                               ; No predecessors!
  br label %34, !dbg !209

34:                                               ; preds = %33, %31
  %35 = load i64, i64* %16, align 8, !dbg !210
  %36 = icmp uge i64 %35, 0, !dbg !210
  br i1 %36, label %37, label %42, !dbg !210

37:                                               ; preds = %34
  %38 = load i64, i64* %18, align 8, !dbg !210
  %39 = load i64, i64* %11, align 8, !dbg !210
  %40 = icmp ule i64 %38, %39, !dbg !210
  br i1 %40, label %41, label %42, !dbg !210

41:                                               ; preds = %37
  br label %44, !dbg !210

42:                                               ; preds = %37, %34
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0), i32 noundef 118, i8* noundef getelementptr inbounds ([105 x i8], [105 x i8]* @__PRETTY_FUNCTION__.trans_block, i64 0, i64 0)) #4, !dbg !210
  unreachable, !dbg !210

43:                                               ; No predecessors!
  br label %44, !dbg !210

44:                                               ; preds = %43, %41
  call void @llvm.dbg.declare(metadata i64* %19, metadata !211, metadata !DIExpression()), !dbg !213
  %45 = load i64, i64* %16, align 8, !dbg !214
  store i64 %45, i64* %19, align 8, !dbg !213
  br label %46, !dbg !215

46:                                               ; preds = %74, %44
  %47 = load i64, i64* %19, align 8, !dbg !216
  %48 = load i64, i64* %18, align 8, !dbg !218
  %49 = icmp ult i64 %47, %48, !dbg !219
  br i1 %49, label %50, label %77, !dbg !220

50:                                               ; preds = %46
  call void @llvm.dbg.declare(metadata i64* %20, metadata !221, metadata !DIExpression()), !dbg !224
  %51 = load i64, i64* %15, align 8, !dbg !225
  store i64 %51, i64* %20, align 8, !dbg !224
  br label %52, !dbg !226

52:                                               ; preds = %70, %50
  %53 = load i64, i64* %20, align 8, !dbg !227
  %54 = load i64, i64* %17, align 8, !dbg !229
  %55 = icmp ult i64 %53, %54, !dbg !230
  br i1 %55, label %56, label %73, !dbg !231

56:                                               ; preds = %52
  %57 = load double*, double** %12, align 8, !dbg !232
  %58 = load i64, i64* %19, align 8, !dbg !234
  %59 = mul nsw i64 %58, %22, !dbg !232
  %60 = getelementptr inbounds double, double* %57, i64 %59, !dbg !232
  %61 = load i64, i64* %20, align 8, !dbg !235
  %62 = getelementptr inbounds double, double* %60, i64 %61, !dbg !232
  %63 = load double, double* %62, align 8, !dbg !232
  %64 = load double*, double** %13, align 8, !dbg !236
  %65 = load i64, i64* %20, align 8, !dbg !237
  %66 = mul nsw i64 %65, %24, !dbg !236
  %67 = getelementptr inbounds double, double* %64, i64 %66, !dbg !236
  %68 = load i64, i64* %19, align 8, !dbg !238
  %69 = getelementptr inbounds double, double* %67, i64 %68, !dbg !236
  store double %63, double* %69, align 8, !dbg !239
  br label %70, !dbg !240

70:                                               ; preds = %56
  %71 = load i64, i64* %20, align 8, !dbg !241
  %72 = add i64 %71, 1, !dbg !241
  store i64 %72, i64* %20, align 8, !dbg !241
  br label %52, !dbg !242, !llvm.loop !243

73:                                               ; preds = %52
  br label %74, !dbg !245

74:                                               ; preds = %73
  %75 = load i64, i64* %19, align 8, !dbg !246
  %76 = add i64 %75, 1, !dbg !246
  store i64 %76, i64* %19, align 8, !dbg !246
  br label %46, !dbg !247, !llvm.loop !248

77:                                               ; preds = %46
  ret void, !dbg !250
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @trans_block_diag(i64 noundef %0, i64 noundef %1, double* noundef %2, double* noundef %3, double* noundef %4, i64 noundef %5, i64 noundef %6, i64 noundef %7, i64 noundef %8) #0 !dbg !251 {
  %10 = alloca i64, align 8
  %11 = alloca i64, align 8
  %12 = alloca double*, align 8
  %13 = alloca double*, align 8
  %14 = alloca double*, align 8
  %15 = alloca i64, align 8
  %16 = alloca i64, align 8
  %17 = alloca i64, align 8
  %18 = alloca i64, align 8
  %19 = alloca i64, align 8
  %20 = alloca i64, align 8
  %21 = alloca i64, align 8
  %22 = alloca i64, align 8
  %23 = alloca i64, align 8
  %24 = alloca i64, align 8
  %25 = alloca i64, align 8
  store i64 %0, i64* %10, align 8
  call void @llvm.dbg.declare(metadata i64* %10, metadata !252, metadata !DIExpression()), !dbg !253
  store i64 %1, i64* %11, align 8
  call void @llvm.dbg.declare(metadata i64* %11, metadata !254, metadata !DIExpression()), !dbg !255
  store double* %2, double** %12, align 8
  call void @llvm.dbg.declare(metadata double** %12, metadata !256, metadata !DIExpression()), !dbg !257
  store double* %3, double** %13, align 8
  call void @llvm.dbg.declare(metadata double** %13, metadata !258, metadata !DIExpression()), !dbg !259
  store double* %4, double** %14, align 8
  call void @llvm.dbg.declare(metadata double** %14, metadata !260, metadata !DIExpression()), !dbg !261
  store i64 %5, i64* %15, align 8
  call void @llvm.dbg.declare(metadata i64* %15, metadata !262, metadata !DIExpression()), !dbg !263
  store i64 %6, i64* %16, align 8
  call void @llvm.dbg.declare(metadata i64* %16, metadata !264, metadata !DIExpression()), !dbg !265
  store i64 %7, i64* %17, align 8
  call void @llvm.dbg.declare(metadata i64* %17, metadata !266, metadata !DIExpression()), !dbg !267
  store i64 %8, i64* %18, align 8
  call void @llvm.dbg.declare(metadata i64* %18, metadata !268, metadata !DIExpression()), !dbg !269
  %26 = load i64, i64* %11, align 8, !dbg !270
  %27 = load i64, i64* %10, align 8, !dbg !271
  %28 = load i64, i64* %10, align 8, !dbg !272
  %29 = load i64, i64* %11, align 8, !dbg !273
  %30 = load i64, i64* %15, align 8, !dbg !274
  %31 = icmp uge i64 %30, 0, !dbg !274
  br i1 %31, label %32, label %37, !dbg !274

32:                                               ; preds = %9
  %33 = load i64, i64* %17, align 8, !dbg !274
  %34 = load i64, i64* %10, align 8, !dbg !274
  %35 = icmp ule i64 %33, %34, !dbg !274
  br i1 %35, label %36, label %37, !dbg !274

36:                                               ; preds = %32
  br label %39, !dbg !274

37:                                               ; preds = %32, %9
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0), i32 noundef 148, i8* noundef getelementptr inbounds ([110 x i8], [110 x i8]* @__PRETTY_FUNCTION__.trans_block_diag, i64 0, i64 0)) #4, !dbg !274
  unreachable, !dbg !274

38:                                               ; No predecessors!
  br label %39, !dbg !274

39:                                               ; preds = %38, %36
  %40 = load i64, i64* %16, align 8, !dbg !275
  %41 = icmp uge i64 %40, 0, !dbg !275
  br i1 %41, label %42, label %47, !dbg !275

42:                                               ; preds = %39
  %43 = load i64, i64* %18, align 8, !dbg !275
  %44 = load i64, i64* %11, align 8, !dbg !275
  %45 = icmp ule i64 %43, %44, !dbg !275
  br i1 %45, label %46, label %47, !dbg !275

46:                                               ; preds = %42
  br label %49, !dbg !275

47:                                               ; preds = %42, %39
  call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0), i32 noundef 149, i8* noundef getelementptr inbounds ([110 x i8], [110 x i8]* @__PRETTY_FUNCTION__.trans_block_diag, i64 0, i64 0)) #4, !dbg !275
  unreachable, !dbg !275

48:                                               ; No predecessors!
  br label %49, !dbg !275

49:                                               ; preds = %48, %46
  %50 = load i64, i64* %15, align 8, !dbg !276
  %51 = load i64, i64* %16, align 8, !dbg !276
  %52 = icmp eq i64 %50, %51, !dbg !276
  br i1 %52, label %53, label %54, !dbg !276

53:                                               ; preds = %49
  br label %56, !dbg !276

54:                                               ; preds = %49
  call void @__assert_fail(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0), i32 noundef 150, i8* noundef getelementptr inbounds ([110 x i8], [110 x i8]* @__PRETTY_FUNCTION__.trans_block_diag, i64 0, i64 0)) #4, !dbg !276
  unreachable, !dbg !276

55:                                               ; No predecessors!
  br label %56, !dbg !276

56:                                               ; preds = %55, %53
  call void @llvm.dbg.declare(metadata i64* %19, metadata !277, metadata !DIExpression()), !dbg !279
  %57 = load i64, i64* %16, align 8, !dbg !280
  %58 = add i64 %57, 1, !dbg !281
  store i64 %58, i64* %19, align 8, !dbg !279
  br label %59, !dbg !282

59:                                               ; preds = %98, %56
  %60 = load i64, i64* %19, align 8, !dbg !283
  %61 = load i64, i64* %18, align 8, !dbg !285
  %62 = icmp ult i64 %60, %61, !dbg !286
  br i1 %62, label %63, label %101, !dbg !287

63:                                               ; preds = %59
  call void @llvm.dbg.declare(metadata i64* %20, metadata !288, metadata !DIExpression()), !dbg !290
  %64 = load i64, i64* %16, align 8, !dbg !291
  %65 = udiv i64 %64, 8, !dbg !292
  %66 = load i64, i64* %19, align 8, !dbg !293
  %67 = load i64, i64* %16, align 8, !dbg !294
  %68 = sub i64 %66, %67, !dbg !295
  %69 = mul i64 %68, 4, !dbg !296
  %70 = add i64 %65, %69, !dbg !297
  %71 = add i64 %70, 1, !dbg !298
  %72 = urem i64 %71, 32, !dbg !299
  store i64 %72, i64* %20, align 8, !dbg !290
  call void @llvm.dbg.declare(metadata i64* %21, metadata !300, metadata !DIExpression()), !dbg !302
  %73 = load i64, i64* %15, align 8, !dbg !303
  store i64 %73, i64* %21, align 8, !dbg !302
  br label %74, !dbg !304

74:                                               ; preds = %94, %63
  %75 = load i64, i64* %21, align 8, !dbg !305
  %76 = load i64, i64* %17, align 8, !dbg !307
  %77 = icmp ult i64 %75, %76, !dbg !308
  br i1 %77, label %78, label %97, !dbg !309

78:                                               ; preds = %74
  %79 = load double*, double** %12, align 8, !dbg !310
  %80 = load i64, i64* %19, align 8, !dbg !312
  %81 = mul nsw i64 %80, %27, !dbg !310
  %82 = getelementptr inbounds double, double* %79, i64 %81, !dbg !310
  %83 = load i64, i64* %21, align 8, !dbg !313
  %84 = getelementptr inbounds double, double* %82, i64 %83, !dbg !310
  %85 = load double, double* %84, align 8, !dbg !310
  %86 = load double*, double** %14, align 8, !dbg !314
  %87 = load i64, i64* %20, align 8, !dbg !315
  %88 = mul i64 %87, 8, !dbg !316
  %89 = load i64, i64* %21, align 8, !dbg !317
  %90 = load i64, i64* %15, align 8, !dbg !318
  %91 = sub i64 %89, %90, !dbg !319
  %92 = add i64 %88, %91, !dbg !320
  %93 = getelementptr inbounds double, double* %86, i64 %92, !dbg !314
  store double %85, double* %93, align 8, !dbg !321
  br label %94, !dbg !322

94:                                               ; preds = %78
  %95 = load i64, i64* %21, align 8, !dbg !323
  %96 = add i64 %95, 1, !dbg !323
  store i64 %96, i64* %21, align 8, !dbg !323
  br label %74, !dbg !324, !llvm.loop !325

97:                                               ; preds = %74
  br label %98, !dbg !327

98:                                               ; preds = %97
  %99 = load i64, i64* %19, align 8, !dbg !328
  %100 = add i64 %99, 1, !dbg !328
  store i64 %100, i64* %19, align 8, !dbg !328
  br label %59, !dbg !329, !llvm.loop !330

101:                                              ; preds = %59
  call void @llvm.dbg.declare(metadata i64* %22, metadata !332, metadata !DIExpression()), !dbg !334
  %102 = load i64, i64* %17, align 8, !dbg !335
  %103 = sub i64 %102, 1, !dbg !336
  store i64 %103, i64* %22, align 8, !dbg !334
  br label %104, !dbg !337

104:                                              ; preds = %122, %101
  %105 = load i64, i64* %22, align 8, !dbg !338
  %106 = load i64, i64* %15, align 8, !dbg !340
  %107 = icmp ugt i64 %105, %106, !dbg !341
  br i1 %107, label %108, label %125, !dbg !342

108:                                              ; preds = %104
  %109 = load double*, double** %12, align 8, !dbg !343
  %110 = load i64, i64* %16, align 8, !dbg !345
  %111 = mul nsw i64 %110, %27, !dbg !343
  %112 = getelementptr inbounds double, double* %109, i64 %111, !dbg !343
  %113 = load i64, i64* %22, align 8, !dbg !346
  %114 = getelementptr inbounds double, double* %112, i64 %113, !dbg !343
  %115 = load double, double* %114, align 8, !dbg !343
  %116 = load double*, double** %13, align 8, !dbg !347
  %117 = load i64, i64* %22, align 8, !dbg !348
  %118 = mul nsw i64 %117, %29, !dbg !347
  %119 = getelementptr inbounds double, double* %116, i64 %118, !dbg !347
  %120 = load i64, i64* %16, align 8, !dbg !349
  %121 = getelementptr inbounds double, double* %119, i64 %120, !dbg !347
  store double %115, double* %121, align 8, !dbg !350
  br label %122, !dbg !351

122:                                              ; preds = %108
  %123 = load i64, i64* %22, align 8, !dbg !352
  %124 = add i64 %123, -1, !dbg !352
  store i64 %124, i64* %22, align 8, !dbg !352
  br label %104, !dbg !353, !llvm.loop !354

125:                                              ; preds = %104
  %126 = load double*, double** %12, align 8, !dbg !356
  %127 = load i64, i64* %16, align 8, !dbg !357
  %128 = mul nsw i64 %127, %27, !dbg !356
  %129 = getelementptr inbounds double, double* %126, i64 %128, !dbg !356
  %130 = load i64, i64* %15, align 8, !dbg !358
  %131 = getelementptr inbounds double, double* %129, i64 %130, !dbg !356
  %132 = load double, double* %131, align 8, !dbg !356
  %133 = load double*, double** %13, align 8, !dbg !359
  %134 = load i64, i64* %15, align 8, !dbg !360
  %135 = mul nsw i64 %134, %29, !dbg !359
  %136 = getelementptr inbounds double, double* %133, i64 %135, !dbg !359
  %137 = load i64, i64* %16, align 8, !dbg !361
  %138 = getelementptr inbounds double, double* %136, i64 %137, !dbg !359
  store double %132, double* %138, align 8, !dbg !362
  call void @llvm.dbg.declare(metadata i64* %23, metadata !363, metadata !DIExpression()), !dbg !365
  %139 = load i64, i64* %16, align 8, !dbg !366
  %140 = add i64 %139, 1, !dbg !367
  store i64 %140, i64* %23, align 8, !dbg !365
  br label %141, !dbg !368

141:                                              ; preds = %180, %125
  %142 = load i64, i64* %23, align 8, !dbg !369
  %143 = load i64, i64* %18, align 8, !dbg !371
  %144 = icmp ult i64 %142, %143, !dbg !372
  br i1 %144, label %145, label %183, !dbg !373

145:                                              ; preds = %141
  call void @llvm.dbg.declare(metadata i64* %24, metadata !374, metadata !DIExpression()), !dbg !376
  %146 = load i64, i64* %16, align 8, !dbg !377
  %147 = udiv i64 %146, 8, !dbg !378
  %148 = load i64, i64* %23, align 8, !dbg !379
  %149 = load i64, i64* %16, align 8, !dbg !380
  %150 = sub i64 %148, %149, !dbg !381
  %151 = mul i64 %150, 4, !dbg !382
  %152 = add i64 %147, %151, !dbg !383
  %153 = add i64 %152, 1, !dbg !384
  %154 = urem i64 %153, 32, !dbg !385
  store i64 %154, i64* %24, align 8, !dbg !376
  call void @llvm.dbg.declare(metadata i64* %25, metadata !386, metadata !DIExpression()), !dbg !388
  %155 = load i64, i64* %15, align 8, !dbg !389
  store i64 %155, i64* %25, align 8, !dbg !388
  br label %156, !dbg !390

156:                                              ; preds = %176, %145
  %157 = load i64, i64* %25, align 8, !dbg !391
  %158 = load i64, i64* %17, align 8, !dbg !393
  %159 = icmp ult i64 %157, %158, !dbg !394
  br i1 %159, label %160, label %179, !dbg !395

160:                                              ; preds = %156
  %161 = load double*, double** %14, align 8, !dbg !396
  %162 = load i64, i64* %24, align 8, !dbg !398
  %163 = mul i64 %162, 8, !dbg !399
  %164 = load i64, i64* %25, align 8, !dbg !400
  %165 = load i64, i64* %15, align 8, !dbg !401
  %166 = sub i64 %164, %165, !dbg !402
  %167 = add i64 %163, %166, !dbg !403
  %168 = getelementptr inbounds double, double* %161, i64 %167, !dbg !396
  %169 = load double, double* %168, align 8, !dbg !396
  %170 = load double*, double** %13, align 8, !dbg !404
  %171 = load i64, i64* %25, align 8, !dbg !405
  %172 = mul nsw i64 %171, %29, !dbg !404
  %173 = getelementptr inbounds double, double* %170, i64 %172, !dbg !404
  %174 = load i64, i64* %23, align 8, !dbg !406
  %175 = getelementptr inbounds double, double* %173, i64 %174, !dbg !404
  store double %169, double* %175, align 8, !dbg !407
  br label %176, !dbg !408

176:                                              ; preds = %160
  %177 = load i64, i64* %25, align 8, !dbg !409
  %178 = add i64 %177, 1, !dbg !409
  store i64 %178, i64* %25, align 8, !dbg !409
  br label %156, !dbg !410, !llvm.loop !411

179:                                              ; preds = %156
  br label %180, !dbg !413

180:                                              ; preds = %179
  %181 = load i64, i64* %23, align 8, !dbg !414
  %182 = add i64 %181, 1, !dbg !414
  store i64 %182, i64* %23, align 8, !dbg !414
  br label %141, !dbg !415, !llvm.loop !416

183:                                              ; preds = %141
  ret void, !dbg !418
}

; Function Attrs: noinline nounwind optnone uwtable
define internal zeroext i1 @is_transpose(i64 noundef %0, i64 noundef %1, double* noundef %2, double* noundef %3) #0 !dbg !419 {
  %5 = alloca i1, align 1
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca double*, align 8
  %9 = alloca double*, align 8
  %10 = alloca i64, align 8
  %11 = alloca i64, align 8
  store i64 %0, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !423, metadata !DIExpression()), !dbg !424
  store i64 %1, i64* %7, align 8
  call void @llvm.dbg.declare(metadata i64* %7, metadata !425, metadata !DIExpression()), !dbg !426
  store double* %2, double** %8, align 8
  call void @llvm.dbg.declare(metadata double** %8, metadata !427, metadata !DIExpression()), !dbg !428
  store double* %3, double** %9, align 8
  call void @llvm.dbg.declare(metadata double** %9, metadata !429, metadata !DIExpression()), !dbg !430
  %12 = load i64, i64* %7, align 8, !dbg !431
  %13 = load i64, i64* %6, align 8, !dbg !432
  %14 = load i64, i64* %6, align 8, !dbg !433
  %15 = load i64, i64* %7, align 8, !dbg !434
  call void @llvm.dbg.declare(metadata i64* %10, metadata !435, metadata !DIExpression()), !dbg !437
  store i64 0, i64* %10, align 8, !dbg !437
  br label %16, !dbg !438

16:                                               ; preds = %67, %4
  %17 = load i64, i64* %10, align 8, !dbg !439
  %18 = load i64, i64* %7, align 8, !dbg !441
  %19 = icmp ult i64 %17, %18, !dbg !442
  br i1 %19, label %20, label %70, !dbg !443

20:                                               ; preds = %16
  call void @llvm.dbg.declare(metadata i64* %11, metadata !444, metadata !DIExpression()), !dbg !447
  store i64 0, i64* %11, align 8, !dbg !447
  br label %21, !dbg !448

21:                                               ; preds = %63, %20
  %22 = load i64, i64* %11, align 8, !dbg !449
  %23 = load i64, i64* %6, align 8, !dbg !451
  %24 = icmp ult i64 %22, %23, !dbg !452
  br i1 %24, label %25, label %66, !dbg !453

25:                                               ; preds = %21
  %26 = load double*, double** %8, align 8, !dbg !454
  %27 = load i64, i64* %10, align 8, !dbg !457
  %28 = mul nsw i64 %27, %13, !dbg !454
  %29 = getelementptr inbounds double, double* %26, i64 %28, !dbg !454
  %30 = load i64, i64* %11, align 8, !dbg !458
  %31 = getelementptr inbounds double, double* %29, i64 %30, !dbg !454
  %32 = load double, double* %31, align 8, !dbg !454
  %33 = load double*, double** %9, align 8, !dbg !459
  %34 = load i64, i64* %11, align 8, !dbg !460
  %35 = mul nsw i64 %34, %15, !dbg !459
  %36 = getelementptr inbounds double, double* %33, i64 %35, !dbg !459
  %37 = load i64, i64* %10, align 8, !dbg !461
  %38 = getelementptr inbounds double, double* %36, i64 %37, !dbg !459
  %39 = load double, double* %38, align 8, !dbg !459
  %40 = fcmp une double %32, %39, !dbg !462
  br i1 %40, label %41, label %62, !dbg !463

41:                                               ; preds = %25
  %42 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !464
  %43 = load i64, i64* %11, align 8, !dbg !466
  %44 = load i64, i64* %10, align 8, !dbg !467
  %45 = load double*, double** %9, align 8, !dbg !468
  %46 = load i64, i64* %11, align 8, !dbg !469
  %47 = mul nsw i64 %46, %15, !dbg !468
  %48 = getelementptr inbounds double, double* %45, i64 %47, !dbg !468
  %49 = load i64, i64* %10, align 8, !dbg !470
  %50 = getelementptr inbounds double, double* %48, i64 %49, !dbg !468
  %51 = load double, double* %50, align 8, !dbg !468
  %52 = load i64, i64* %10, align 8, !dbg !471
  %53 = load i64, i64* %11, align 8, !dbg !472
  %54 = load double*, double** %8, align 8, !dbg !473
  %55 = load i64, i64* %10, align 8, !dbg !474
  %56 = mul nsw i64 %55, %13, !dbg !473
  %57 = getelementptr inbounds double, double* %54, i64 %56, !dbg !473
  %58 = load i64, i64* %11, align 8, !dbg !475
  %59 = getelementptr inbounds double, double* %57, i64 %58, !dbg !473
  %60 = load double, double* %59, align 8, !dbg !473
  %61 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* noundef %42, i8* noundef getelementptr inbounds ([72 x i8], [72 x i8]* @.str.7, i64 0, i64 0), i64 noundef %43, i64 noundef %44, double noundef %51, i64 noundef %52, i64 noundef %53, double noundef %60), !dbg !476
  store i1 false, i1* %5, align 1, !dbg !477
  br label %71, !dbg !477

62:                                               ; preds = %25
  br label %63, !dbg !478

63:                                               ; preds = %62
  %64 = load i64, i64* %11, align 8, !dbg !479
  %65 = add i64 %64, 1, !dbg !479
  store i64 %65, i64* %11, align 8, !dbg !479
  br label %21, !dbg !480, !llvm.loop !481

66:                                               ; preds = %21
  br label %67, !dbg !483

67:                                               ; preds = %66
  %68 = load i64, i64* %10, align 8, !dbg !484
  %69 = add i64 %68, 1, !dbg !484
  store i64 %69, i64* %10, align 8, !dbg !484
  br label %16, !dbg !485, !llvm.loop !486

70:                                               ; preds = %16
  store i1 true, i1* %5, align 1, !dbg !488
  br label %71, !dbg !488

71:                                               ; preds = %70, %41
  %72 = load i1, i1* %5, align 1, !dbg !489
  ret i1 %72, !dbg !489
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #3

declare i32 @fprintf(%struct._IO_FILE* noundef, i8* noundef, ...) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "trans.c", directory: "/afs/andrew.cmu.edu/usr4/yunhsuat/private/15513/cachelab/cachelab513-m24-Jacqueline-Tsai")
!2 = !{i32 7, !"Dwarf Version", i32 4}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!10 = distinct !DISubprogram(name: "registerFunctions", scope: !1, file: !1, line: 211, type: !11, scopeLine: 211, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!11 = !DISubroutineType(types: !12)
!12 = !{null}
!13 = !{}
!14 = !DILocation(line: 213, column: 5, scope: !10)
!15 = !DILocation(line: 215, column: 5, scope: !10)
!16 = !DILocation(line: 216, column: 1, scope: !10)
!17 = distinct !DISubprogram(name: "transpose_submit", scope: !1, file: !1, line: 179, type: !18, scopeLine: 180, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !13)
!18 = !DISubroutineType(types: !19)
!19 = !{null, !20, !20, !23, !23, !28}
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !21, line: 46, baseType: !22)
!21 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "")
!22 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!24 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, elements: !26)
!25 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!26 = !{!27}
!27 = !DISubrange(count: -1)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!29 = !DILocalVariable(name: "M", arg: 1, scope: !17, file: !1, line: 179, type: !20)
!30 = !DILocation(line: 179, column: 37, scope: !17)
!31 = !DILocalVariable(name: "N", arg: 2, scope: !17, file: !1, line: 179, type: !20)
!32 = !DILocation(line: 179, column: 47, scope: !17)
!33 = !DILocalVariable(name: "A", arg: 3, scope: !17, file: !1, line: 179, type: !23)
!34 = !DILocation(line: 179, column: 57, scope: !17)
!35 = !DILocalVariable(name: "B", arg: 4, scope: !17, file: !1, line: 179, type: !23)
!36 = !DILocation(line: 179, column: 73, scope: !17)
!37 = !DILocalVariable(name: "tmp", arg: 5, scope: !17, file: !1, line: 180, type: !28)
!38 = !DILocation(line: 180, column: 37, scope: !17)
!39 = !DILocation(line: 179, column: 59, scope: !17)
!40 = !DILocation(line: 179, column: 62, scope: !17)
!41 = !DILocation(line: 179, column: 75, scope: !17)
!42 = !DILocation(line: 179, column: 78, scope: !17)
!43 = !DILocation(line: 182, column: 9, scope: !44)
!44 = distinct !DILexicalBlock(scope: !17, file: !1, line: 182, column: 9)
!45 = !DILocation(line: 182, column: 14, scope: !44)
!46 = !DILocation(line: 182, column: 11, scope: !44)
!47 = !DILocation(line: 182, column: 16, scope: !44)
!48 = !DILocation(line: 182, column: 19, scope: !44)
!49 = !DILocation(line: 182, column: 21, scope: !44)
!50 = !DILocation(line: 182, column: 25, scope: !44)
!51 = !DILocation(line: 182, column: 9, scope: !17)
!52 = !DILocation(line: 183, column: 21, scope: !53)
!53 = distinct !DILexicalBlock(scope: !44, file: !1, line: 182, column: 31)
!54 = !DILocation(line: 183, column: 24, scope: !53)
!55 = !DILocation(line: 183, column: 27, scope: !53)
!56 = !DILocation(line: 183, column: 30, scope: !53)
!57 = !DILocation(line: 183, column: 33, scope: !53)
!58 = !DILocation(line: 183, column: 9, scope: !53)
!59 = !DILocation(line: 184, column: 9, scope: !53)
!60 = !DILocalVariable(name: "i", scope: !61, file: !1, line: 187, type: !20)
!61 = distinct !DILexicalBlock(scope: !17, file: !1, line: 187, column: 5)
!62 = !DILocation(line: 187, column: 17, scope: !61)
!63 = !DILocation(line: 187, column: 10, scope: !61)
!64 = !DILocation(line: 187, column: 24, scope: !65)
!65 = distinct !DILexicalBlock(scope: !61, file: !1, line: 187, column: 5)
!66 = !DILocation(line: 187, column: 28, scope: !65)
!67 = !DILocation(line: 187, column: 30, scope: !65)
!68 = !DILocation(line: 187, column: 47, scope: !65)
!69 = !DILocation(line: 187, column: 26, scope: !65)
!70 = !DILocation(line: 187, column: 5, scope: !61)
!71 = !DILocalVariable(name: "j", scope: !72, file: !1, line: 189, type: !20)
!72 = distinct !DILexicalBlock(scope: !73, file: !1, line: 189, column: 9)
!73 = distinct !DILexicalBlock(scope: !65, file: !1, line: 188, column: 31)
!74 = !DILocation(line: 189, column: 21, scope: !72)
!75 = !DILocation(line: 189, column: 14, scope: !72)
!76 = !DILocation(line: 189, column: 28, scope: !77)
!77 = distinct !DILexicalBlock(scope: !72, file: !1, line: 189, column: 9)
!78 = !DILocation(line: 189, column: 32, scope: !77)
!79 = !DILocation(line: 189, column: 34, scope: !77)
!80 = !DILocation(line: 189, column: 51, scope: !77)
!81 = !DILocation(line: 189, column: 30, scope: !77)
!82 = !DILocation(line: 189, column: 9, scope: !72)
!83 = !DILocation(line: 191, column: 17, scope: !84)
!84 = distinct !DILexicalBlock(scope: !85, file: !1, line: 191, column: 17)
!85 = distinct !DILexicalBlock(scope: !77, file: !1, line: 190, column: 35)
!86 = !DILocation(line: 191, column: 22, scope: !84)
!87 = !DILocation(line: 191, column: 19, scope: !84)
!88 = !DILocation(line: 191, column: 17, scope: !85)
!89 = !DILocation(line: 192, column: 29, scope: !90)
!90 = distinct !DILexicalBlock(scope: !84, file: !1, line: 191, column: 25)
!91 = !DILocation(line: 192, column: 32, scope: !90)
!92 = !DILocation(line: 192, column: 35, scope: !90)
!93 = !DILocation(line: 192, column: 38, scope: !90)
!94 = !DILocation(line: 192, column: 41, scope: !90)
!95 = !DILocation(line: 192, column: 46, scope: !90)
!96 = !DILocation(line: 192, column: 49, scope: !90)
!97 = !DILocation(line: 192, column: 52, scope: !90)
!98 = !DILocation(line: 192, column: 54, scope: !90)
!99 = !DILocation(line: 193, column: 29, scope: !90)
!100 = !DILocation(line: 193, column: 31, scope: !90)
!101 = !DILocation(line: 192, column: 17, scope: !90)
!102 = !DILocation(line: 194, column: 13, scope: !90)
!103 = !DILocation(line: 195, column: 34, scope: !104)
!104 = distinct !DILexicalBlock(scope: !84, file: !1, line: 194, column: 20)
!105 = !DILocation(line: 195, column: 37, scope: !104)
!106 = !DILocation(line: 195, column: 40, scope: !104)
!107 = !DILocation(line: 195, column: 43, scope: !104)
!108 = !DILocation(line: 195, column: 46, scope: !104)
!109 = !DILocation(line: 195, column: 51, scope: !104)
!110 = !DILocation(line: 195, column: 54, scope: !104)
!111 = !DILocation(line: 196, column: 40, scope: !104)
!112 = !DILocation(line: 196, column: 42, scope: !104)
!113 = !DILocation(line: 196, column: 60, scope: !104)
!114 = !DILocation(line: 196, column: 62, scope: !104)
!115 = !DILocation(line: 195, column: 17, scope: !104)
!116 = !DILocation(line: 198, column: 9, scope: !85)
!117 = !DILocation(line: 190, column: 16, scope: !77)
!118 = !DILocation(line: 189, column: 9, scope: !77)
!119 = distinct !{!119, !82, !120}
!120 = !DILocation(line: 198, column: 9, scope: !72)
!121 = !DILocation(line: 199, column: 5, scope: !73)
!122 = !DILocation(line: 188, column: 12, scope: !65)
!123 = !DILocation(line: 187, column: 5, scope: !65)
!124 = distinct !{!124, !70, !125}
!125 = !DILocation(line: 199, column: 5, scope: !61)
!126 = !DILocation(line: 201, column: 5, scope: !17)
!127 = !DILocation(line: 202, column: 1, scope: !17)
!128 = distinct !DISubprogram(name: "trans_basic", scope: !1, file: !1, line: 82, type: !18, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !13)
!129 = !DILocalVariable(name: "M", arg: 1, scope: !128, file: !1, line: 82, type: !20)
!130 = !DILocation(line: 82, column: 32, scope: !128)
!131 = !DILocalVariable(name: "N", arg: 2, scope: !128, file: !1, line: 82, type: !20)
!132 = !DILocation(line: 82, column: 42, scope: !128)
!133 = !DILocalVariable(name: "A", arg: 3, scope: !128, file: !1, line: 82, type: !23)
!134 = !DILocation(line: 82, column: 52, scope: !128)
!135 = !DILocalVariable(name: "B", arg: 4, scope: !128, file: !1, line: 82, type: !23)
!136 = !DILocation(line: 82, column: 68, scope: !128)
!137 = !DILocalVariable(name: "tmp", arg: 5, scope: !128, file: !1, line: 83, type: !28)
!138 = !DILocation(line: 83, column: 32, scope: !128)
!139 = !DILocation(line: 82, column: 54, scope: !128)
!140 = !DILocation(line: 82, column: 57, scope: !128)
!141 = !DILocation(line: 82, column: 70, scope: !128)
!142 = !DILocation(line: 82, column: 73, scope: !128)
!143 = !DILocation(line: 84, column: 5, scope: !128)
!144 = !DILocation(line: 85, column: 5, scope: !128)
!145 = !DILocalVariable(name: "i", scope: !146, file: !1, line: 87, type: !20)
!146 = distinct !DILexicalBlock(scope: !128, file: !1, line: 87, column: 5)
!147 = !DILocation(line: 87, column: 17, scope: !146)
!148 = !DILocation(line: 87, column: 10, scope: !146)
!149 = !DILocation(line: 87, column: 24, scope: !150)
!150 = distinct !DILexicalBlock(scope: !146, file: !1, line: 87, column: 5)
!151 = !DILocation(line: 87, column: 28, scope: !150)
!152 = !DILocation(line: 87, column: 26, scope: !150)
!153 = !DILocation(line: 87, column: 5, scope: !146)
!154 = !DILocalVariable(name: "j", scope: !155, file: !1, line: 88, type: !20)
!155 = distinct !DILexicalBlock(scope: !156, file: !1, line: 88, column: 9)
!156 = distinct !DILexicalBlock(scope: !150, file: !1, line: 87, column: 36)
!157 = !DILocation(line: 88, column: 21, scope: !155)
!158 = !DILocation(line: 88, column: 14, scope: !155)
!159 = !DILocation(line: 88, column: 28, scope: !160)
!160 = distinct !DILexicalBlock(scope: !155, file: !1, line: 88, column: 9)
!161 = !DILocation(line: 88, column: 32, scope: !160)
!162 = !DILocation(line: 88, column: 30, scope: !160)
!163 = !DILocation(line: 88, column: 9, scope: !155)
!164 = !DILocation(line: 89, column: 23, scope: !165)
!165 = distinct !DILexicalBlock(scope: !160, file: !1, line: 88, column: 40)
!166 = !DILocation(line: 89, column: 25, scope: !165)
!167 = !DILocation(line: 89, column: 28, scope: !165)
!168 = !DILocation(line: 89, column: 13, scope: !165)
!169 = !DILocation(line: 89, column: 15, scope: !165)
!170 = !DILocation(line: 89, column: 18, scope: !165)
!171 = !DILocation(line: 89, column: 21, scope: !165)
!172 = !DILocation(line: 90, column: 9, scope: !165)
!173 = !DILocation(line: 88, column: 36, scope: !160)
!174 = !DILocation(line: 88, column: 9, scope: !160)
!175 = distinct !{!175, !163, !176}
!176 = !DILocation(line: 90, column: 9, scope: !155)
!177 = !DILocation(line: 91, column: 5, scope: !156)
!178 = !DILocation(line: 87, column: 32, scope: !150)
!179 = !DILocation(line: 87, column: 5, scope: !150)
!180 = distinct !{!180, !153, !181}
!181 = !DILocation(line: 91, column: 5, scope: !146)
!182 = !DILocation(line: 93, column: 5, scope: !128)
!183 = !DILocation(line: 94, column: 1, scope: !128)
!184 = distinct !DISubprogram(name: "trans_block", scope: !1, file: !1, line: 113, type: !185, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !13)
!185 = !DISubroutineType(types: !186)
!186 = !{null, !20, !20, !23, !23, !28, !20, !20, !20, !20}
!187 = !DILocalVariable(name: "M", arg: 1, scope: !184, file: !1, line: 113, type: !20)
!188 = !DILocation(line: 113, column: 32, scope: !184)
!189 = !DILocalVariable(name: "N", arg: 2, scope: !184, file: !1, line: 113, type: !20)
!190 = !DILocation(line: 113, column: 42, scope: !184)
!191 = !DILocalVariable(name: "A", arg: 3, scope: !184, file: !1, line: 113, type: !23)
!192 = !DILocation(line: 113, column: 52, scope: !184)
!193 = !DILocalVariable(name: "B", arg: 4, scope: !184, file: !1, line: 113, type: !23)
!194 = !DILocation(line: 113, column: 68, scope: !184)
!195 = !DILocalVariable(name: "tmp", arg: 5, scope: !184, file: !1, line: 114, type: !28)
!196 = !DILocation(line: 114, column: 32, scope: !184)
!197 = !DILocalVariable(name: "M_start", arg: 6, scope: !184, file: !1, line: 114, type: !20)
!198 = !DILocation(line: 114, column: 54, scope: !184)
!199 = !DILocalVariable(name: "N_start", arg: 7, scope: !184, file: !1, line: 114, type: !20)
!200 = !DILocation(line: 114, column: 70, scope: !184)
!201 = !DILocalVariable(name: "M_end", arg: 8, scope: !184, file: !1, line: 115, type: !20)
!202 = !DILocation(line: 115, column: 32, scope: !184)
!203 = !DILocalVariable(name: "N_end", arg: 9, scope: !184, file: !1, line: 115, type: !20)
!204 = !DILocation(line: 115, column: 46, scope: !184)
!205 = !DILocation(line: 113, column: 54, scope: !184)
!206 = !DILocation(line: 113, column: 57, scope: !184)
!207 = !DILocation(line: 113, column: 70, scope: !184)
!208 = !DILocation(line: 113, column: 73, scope: !184)
!209 = !DILocation(line: 117, column: 5, scope: !184)
!210 = !DILocation(line: 118, column: 5, scope: !184)
!211 = !DILocalVariable(name: "i", scope: !212, file: !1, line: 120, type: !20)
!212 = distinct !DILexicalBlock(scope: !184, file: !1, line: 120, column: 5)
!213 = !DILocation(line: 120, column: 17, scope: !212)
!214 = !DILocation(line: 120, column: 21, scope: !212)
!215 = !DILocation(line: 120, column: 10, scope: !212)
!216 = !DILocation(line: 120, column: 30, scope: !217)
!217 = distinct !DILexicalBlock(scope: !212, file: !1, line: 120, column: 5)
!218 = !DILocation(line: 120, column: 34, scope: !217)
!219 = !DILocation(line: 120, column: 32, scope: !217)
!220 = !DILocation(line: 120, column: 5, scope: !212)
!221 = !DILocalVariable(name: "j", scope: !222, file: !1, line: 121, type: !20)
!222 = distinct !DILexicalBlock(scope: !223, file: !1, line: 121, column: 9)
!223 = distinct !DILexicalBlock(scope: !217, file: !1, line: 120, column: 46)
!224 = !DILocation(line: 121, column: 21, scope: !222)
!225 = !DILocation(line: 121, column: 25, scope: !222)
!226 = !DILocation(line: 121, column: 14, scope: !222)
!227 = !DILocation(line: 121, column: 34, scope: !228)
!228 = distinct !DILexicalBlock(scope: !222, file: !1, line: 121, column: 9)
!229 = !DILocation(line: 121, column: 38, scope: !228)
!230 = !DILocation(line: 121, column: 36, scope: !228)
!231 = !DILocation(line: 121, column: 9, scope: !222)
!232 = !DILocation(line: 122, column: 23, scope: !233)
!233 = distinct !DILexicalBlock(scope: !228, file: !1, line: 121, column: 50)
!234 = !DILocation(line: 122, column: 25, scope: !233)
!235 = !DILocation(line: 122, column: 28, scope: !233)
!236 = !DILocation(line: 122, column: 13, scope: !233)
!237 = !DILocation(line: 122, column: 15, scope: !233)
!238 = !DILocation(line: 122, column: 18, scope: !233)
!239 = !DILocation(line: 122, column: 21, scope: !233)
!240 = !DILocation(line: 123, column: 9, scope: !233)
!241 = !DILocation(line: 121, column: 46, scope: !228)
!242 = !DILocation(line: 121, column: 9, scope: !228)
!243 = distinct !{!243, !231, !244}
!244 = !DILocation(line: 123, column: 9, scope: !222)
!245 = !DILocation(line: 124, column: 5, scope: !223)
!246 = !DILocation(line: 120, column: 42, scope: !217)
!247 = !DILocation(line: 120, column: 5, scope: !217)
!248 = distinct !{!248, !220, !249}
!249 = !DILocation(line: 124, column: 5, scope: !212)
!250 = !DILocation(line: 125, column: 1, scope: !184)
!251 = distinct !DISubprogram(name: "trans_block_diag", scope: !1, file: !1, line: 143, type: !185, scopeLine: 146, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !13)
!252 = !DILocalVariable(name: "M", arg: 1, scope: !251, file: !1, line: 143, type: !20)
!253 = !DILocation(line: 143, column: 37, scope: !251)
!254 = !DILocalVariable(name: "N", arg: 2, scope: !251, file: !1, line: 143, type: !20)
!255 = !DILocation(line: 143, column: 47, scope: !251)
!256 = !DILocalVariable(name: "A", arg: 3, scope: !251, file: !1, line: 143, type: !23)
!257 = !DILocation(line: 143, column: 57, scope: !251)
!258 = !DILocalVariable(name: "B", arg: 4, scope: !251, file: !1, line: 144, type: !23)
!259 = !DILocation(line: 144, column: 43, scope: !251)
!260 = !DILocalVariable(name: "tmp", arg: 5, scope: !251, file: !1, line: 144, type: !28)
!261 = !DILocation(line: 144, column: 59, scope: !251)
!262 = !DILocalVariable(name: "M_start", arg: 6, scope: !251, file: !1, line: 145, type: !20)
!263 = !DILocation(line: 145, column: 43, scope: !251)
!264 = !DILocalVariable(name: "N_start", arg: 7, scope: !251, file: !1, line: 145, type: !20)
!265 = !DILocation(line: 145, column: 59, scope: !251)
!266 = !DILocalVariable(name: "M_end", arg: 8, scope: !251, file: !1, line: 145, type: !20)
!267 = !DILocation(line: 145, column: 75, scope: !251)
!268 = !DILocalVariable(name: "N_end", arg: 9, scope: !251, file: !1, line: 146, type: !20)
!269 = !DILocation(line: 146, column: 43, scope: !251)
!270 = !DILocation(line: 143, column: 59, scope: !251)
!271 = !DILocation(line: 143, column: 62, scope: !251)
!272 = !DILocation(line: 144, column: 45, scope: !251)
!273 = !DILocation(line: 144, column: 48, scope: !251)
!274 = !DILocation(line: 148, column: 5, scope: !251)
!275 = !DILocation(line: 149, column: 5, scope: !251)
!276 = !DILocation(line: 150, column: 5, scope: !251)
!277 = !DILocalVariable(name: "i", scope: !278, file: !1, line: 152, type: !20)
!278 = distinct !DILexicalBlock(scope: !251, file: !1, line: 152, column: 5)
!279 = !DILocation(line: 152, column: 17, scope: !278)
!280 = !DILocation(line: 152, column: 21, scope: !278)
!281 = !DILocation(line: 152, column: 29, scope: !278)
!282 = !DILocation(line: 152, column: 10, scope: !278)
!283 = !DILocation(line: 152, column: 34, scope: !284)
!284 = distinct !DILexicalBlock(scope: !278, file: !1, line: 152, column: 5)
!285 = !DILocation(line: 152, column: 38, scope: !284)
!286 = !DILocation(line: 152, column: 36, scope: !284)
!287 = !DILocation(line: 152, column: 5, scope: !278)
!288 = !DILocalVariable(name: "tmp_set", scope: !289, file: !1, line: 153, type: !20)
!289 = distinct !DILexicalBlock(scope: !284, file: !1, line: 152, column: 50)
!290 = !DILocation(line: 153, column: 16, scope: !289)
!291 = !DILocation(line: 153, column: 27, scope: !289)
!292 = !DILocation(line: 153, column: 35, scope: !289)
!293 = !DILocation(line: 153, column: 42, scope: !289)
!294 = !DILocation(line: 153, column: 46, scope: !289)
!295 = !DILocation(line: 153, column: 44, scope: !289)
!296 = !DILocation(line: 153, column: 55, scope: !289)
!297 = !DILocation(line: 153, column: 39, scope: !289)
!298 = !DILocation(line: 153, column: 59, scope: !289)
!299 = !DILocation(line: 153, column: 64, scope: !289)
!300 = !DILocalVariable(name: "j", scope: !301, file: !1, line: 154, type: !20)
!301 = distinct !DILexicalBlock(scope: !289, file: !1, line: 154, column: 9)
!302 = !DILocation(line: 154, column: 21, scope: !301)
!303 = !DILocation(line: 154, column: 25, scope: !301)
!304 = !DILocation(line: 154, column: 14, scope: !301)
!305 = !DILocation(line: 154, column: 34, scope: !306)
!306 = distinct !DILexicalBlock(scope: !301, file: !1, line: 154, column: 9)
!307 = !DILocation(line: 154, column: 38, scope: !306)
!308 = !DILocation(line: 154, column: 36, scope: !306)
!309 = !DILocation(line: 154, column: 9, scope: !301)
!310 = !DILocation(line: 155, column: 48, scope: !311)
!311 = distinct !DILexicalBlock(scope: !306, file: !1, line: 154, column: 50)
!312 = !DILocation(line: 155, column: 50, scope: !311)
!313 = !DILocation(line: 155, column: 53, scope: !311)
!314 = !DILocation(line: 155, column: 13, scope: !311)
!315 = !DILocation(line: 155, column: 17, scope: !311)
!316 = !DILocation(line: 155, column: 25, scope: !311)
!317 = !DILocation(line: 155, column: 32, scope: !311)
!318 = !DILocation(line: 155, column: 36, scope: !311)
!319 = !DILocation(line: 155, column: 34, scope: !311)
!320 = !DILocation(line: 155, column: 29, scope: !311)
!321 = !DILocation(line: 155, column: 46, scope: !311)
!322 = !DILocation(line: 156, column: 9, scope: !311)
!323 = !DILocation(line: 154, column: 46, scope: !306)
!324 = !DILocation(line: 154, column: 9, scope: !306)
!325 = distinct !{!325, !309, !326}
!326 = !DILocation(line: 156, column: 9, scope: !301)
!327 = !DILocation(line: 157, column: 5, scope: !289)
!328 = !DILocation(line: 152, column: 46, scope: !284)
!329 = !DILocation(line: 152, column: 5, scope: !284)
!330 = distinct !{!330, !287, !331}
!331 = !DILocation(line: 157, column: 5, scope: !278)
!332 = !DILocalVariable(name: "j", scope: !333, file: !1, line: 159, type: !20)
!333 = distinct !DILexicalBlock(scope: !251, file: !1, line: 159, column: 5)
!334 = !DILocation(line: 159, column: 17, scope: !333)
!335 = !DILocation(line: 159, column: 21, scope: !333)
!336 = !DILocation(line: 159, column: 27, scope: !333)
!337 = !DILocation(line: 159, column: 10, scope: !333)
!338 = !DILocation(line: 159, column: 32, scope: !339)
!339 = distinct !DILexicalBlock(scope: !333, file: !1, line: 159, column: 5)
!340 = !DILocation(line: 159, column: 36, scope: !339)
!341 = !DILocation(line: 159, column: 34, scope: !339)
!342 = !DILocation(line: 159, column: 5, scope: !333)
!343 = !DILocation(line: 160, column: 25, scope: !344)
!344 = distinct !DILexicalBlock(scope: !339, file: !1, line: 159, column: 50)
!345 = !DILocation(line: 160, column: 27, scope: !344)
!346 = !DILocation(line: 160, column: 36, scope: !344)
!347 = !DILocation(line: 160, column: 9, scope: !344)
!348 = !DILocation(line: 160, column: 11, scope: !344)
!349 = !DILocation(line: 160, column: 14, scope: !344)
!350 = !DILocation(line: 160, column: 23, scope: !344)
!351 = !DILocation(line: 161, column: 5, scope: !344)
!352 = !DILocation(line: 159, column: 46, scope: !339)
!353 = !DILocation(line: 159, column: 5, scope: !339)
!354 = distinct !{!354, !342, !355}
!355 = !DILocation(line: 161, column: 5, scope: !333)
!356 = !DILocation(line: 162, column: 27, scope: !251)
!357 = !DILocation(line: 162, column: 29, scope: !251)
!358 = !DILocation(line: 162, column: 38, scope: !251)
!359 = !DILocation(line: 162, column: 5, scope: !251)
!360 = !DILocation(line: 162, column: 7, scope: !251)
!361 = !DILocation(line: 162, column: 16, scope: !251)
!362 = !DILocation(line: 162, column: 25, scope: !251)
!363 = !DILocalVariable(name: "i", scope: !364, file: !1, line: 164, type: !20)
!364 = distinct !DILexicalBlock(scope: !251, file: !1, line: 164, column: 5)
!365 = !DILocation(line: 164, column: 17, scope: !364)
!366 = !DILocation(line: 164, column: 21, scope: !364)
!367 = !DILocation(line: 164, column: 29, scope: !364)
!368 = !DILocation(line: 164, column: 10, scope: !364)
!369 = !DILocation(line: 164, column: 34, scope: !370)
!370 = distinct !DILexicalBlock(scope: !364, file: !1, line: 164, column: 5)
!371 = !DILocation(line: 164, column: 38, scope: !370)
!372 = !DILocation(line: 164, column: 36, scope: !370)
!373 = !DILocation(line: 164, column: 5, scope: !364)
!374 = !DILocalVariable(name: "tmp_set", scope: !375, file: !1, line: 165, type: !20)
!375 = distinct !DILexicalBlock(scope: !370, file: !1, line: 164, column: 50)
!376 = !DILocation(line: 165, column: 16, scope: !375)
!377 = !DILocation(line: 165, column: 27, scope: !375)
!378 = !DILocation(line: 165, column: 35, scope: !375)
!379 = !DILocation(line: 165, column: 42, scope: !375)
!380 = !DILocation(line: 165, column: 46, scope: !375)
!381 = !DILocation(line: 165, column: 44, scope: !375)
!382 = !DILocation(line: 165, column: 55, scope: !375)
!383 = !DILocation(line: 165, column: 39, scope: !375)
!384 = !DILocation(line: 165, column: 59, scope: !375)
!385 = !DILocation(line: 165, column: 64, scope: !375)
!386 = !DILocalVariable(name: "j", scope: !387, file: !1, line: 166, type: !20)
!387 = distinct !DILexicalBlock(scope: !375, file: !1, line: 166, column: 9)
!388 = !DILocation(line: 166, column: 21, scope: !387)
!389 = !DILocation(line: 166, column: 25, scope: !387)
!390 = !DILocation(line: 166, column: 14, scope: !387)
!391 = !DILocation(line: 166, column: 34, scope: !392)
!392 = distinct !DILexicalBlock(scope: !387, file: !1, line: 166, column: 9)
!393 = !DILocation(line: 166, column: 38, scope: !392)
!394 = !DILocation(line: 166, column: 36, scope: !392)
!395 = !DILocation(line: 166, column: 9, scope: !387)
!396 = !DILocation(line: 167, column: 23, scope: !397)
!397 = distinct !DILexicalBlock(scope: !392, file: !1, line: 166, column: 50)
!398 = !DILocation(line: 167, column: 27, scope: !397)
!399 = !DILocation(line: 167, column: 35, scope: !397)
!400 = !DILocation(line: 167, column: 42, scope: !397)
!401 = !DILocation(line: 167, column: 46, scope: !397)
!402 = !DILocation(line: 167, column: 44, scope: !397)
!403 = !DILocation(line: 167, column: 39, scope: !397)
!404 = !DILocation(line: 167, column: 13, scope: !397)
!405 = !DILocation(line: 167, column: 15, scope: !397)
!406 = !DILocation(line: 167, column: 18, scope: !397)
!407 = !DILocation(line: 167, column: 21, scope: !397)
!408 = !DILocation(line: 168, column: 9, scope: !397)
!409 = !DILocation(line: 166, column: 46, scope: !392)
!410 = !DILocation(line: 166, column: 9, scope: !392)
!411 = distinct !{!411, !395, !412}
!412 = !DILocation(line: 168, column: 9, scope: !387)
!413 = !DILocation(line: 169, column: 5, scope: !375)
!414 = !DILocation(line: 164, column: 46, scope: !370)
!415 = !DILocation(line: 164, column: 5, scope: !370)
!416 = distinct !{!416, !373, !417}
!417 = !DILocation(line: 169, column: 5, scope: !364)
!418 = !DILocation(line: 170, column: 1, scope: !251)
!419 = distinct !DISubprogram(name: "is_transpose", scope: !1, file: !1, line: 59, type: !420, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !13)
!420 = !DISubroutineType(types: !421)
!421 = !{!422, !20, !20, !23, !23}
!422 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!423 = !DILocalVariable(name: "M", arg: 1, scope: !419, file: !1, line: 59, type: !20)
!424 = !DILocation(line: 59, column: 33, scope: !419)
!425 = !DILocalVariable(name: "N", arg: 2, scope: !419, file: !1, line: 59, type: !20)
!426 = !DILocation(line: 59, column: 43, scope: !419)
!427 = !DILocalVariable(name: "A", arg: 3, scope: !419, file: !1, line: 59, type: !23)
!428 = !DILocation(line: 59, column: 53, scope: !419)
!429 = !DILocalVariable(name: "B", arg: 4, scope: !419, file: !1, line: 59, type: !23)
!430 = !DILocation(line: 59, column: 69, scope: !419)
!431 = !DILocation(line: 59, column: 55, scope: !419)
!432 = !DILocation(line: 59, column: 58, scope: !419)
!433 = !DILocation(line: 59, column: 71, scope: !419)
!434 = !DILocation(line: 59, column: 74, scope: !419)
!435 = !DILocalVariable(name: "i", scope: !436, file: !1, line: 60, type: !20)
!436 = distinct !DILexicalBlock(scope: !419, file: !1, line: 60, column: 5)
!437 = !DILocation(line: 60, column: 17, scope: !436)
!438 = !DILocation(line: 60, column: 10, scope: !436)
!439 = !DILocation(line: 60, column: 24, scope: !440)
!440 = distinct !DILexicalBlock(scope: !436, file: !1, line: 60, column: 5)
!441 = !DILocation(line: 60, column: 28, scope: !440)
!442 = !DILocation(line: 60, column: 26, scope: !440)
!443 = !DILocation(line: 60, column: 5, scope: !436)
!444 = !DILocalVariable(name: "j", scope: !445, file: !1, line: 61, type: !20)
!445 = distinct !DILexicalBlock(scope: !446, file: !1, line: 61, column: 9)
!446 = distinct !DILexicalBlock(scope: !440, file: !1, line: 60, column: 36)
!447 = !DILocation(line: 61, column: 21, scope: !445)
!448 = !DILocation(line: 61, column: 14, scope: !445)
!449 = !DILocation(line: 61, column: 28, scope: !450)
!450 = distinct !DILexicalBlock(scope: !445, file: !1, line: 61, column: 9)
!451 = !DILocation(line: 61, column: 32, scope: !450)
!452 = !DILocation(line: 61, column: 30, scope: !450)
!453 = !DILocation(line: 61, column: 9, scope: !445)
!454 = !DILocation(line: 62, column: 17, scope: !455)
!455 = distinct !DILexicalBlock(scope: !456, file: !1, line: 62, column: 17)
!456 = distinct !DILexicalBlock(scope: !450, file: !1, line: 61, column: 40)
!457 = !DILocation(line: 62, column: 19, scope: !455)
!458 = !DILocation(line: 62, column: 22, scope: !455)
!459 = !DILocation(line: 62, column: 28, scope: !455)
!460 = !DILocation(line: 62, column: 30, scope: !455)
!461 = !DILocation(line: 62, column: 33, scope: !455)
!462 = !DILocation(line: 62, column: 25, scope: !455)
!463 = !DILocation(line: 62, column: 17, scope: !456)
!464 = !DILocation(line: 63, column: 25, scope: !465)
!465 = distinct !DILexicalBlock(scope: !455, file: !1, line: 62, column: 37)
!466 = !DILocation(line: 66, column: 25, scope: !465)
!467 = !DILocation(line: 66, column: 28, scope: !465)
!468 = !DILocation(line: 66, column: 31, scope: !465)
!469 = !DILocation(line: 66, column: 33, scope: !465)
!470 = !DILocation(line: 66, column: 36, scope: !465)
!471 = !DILocation(line: 66, column: 40, scope: !465)
!472 = !DILocation(line: 66, column: 43, scope: !465)
!473 = !DILocation(line: 66, column: 46, scope: !465)
!474 = !DILocation(line: 66, column: 48, scope: !465)
!475 = !DILocation(line: 66, column: 51, scope: !465)
!476 = !DILocation(line: 63, column: 17, scope: !465)
!477 = !DILocation(line: 67, column: 17, scope: !465)
!478 = !DILocation(line: 69, column: 9, scope: !456)
!479 = !DILocation(line: 61, column: 35, scope: !450)
!480 = !DILocation(line: 61, column: 9, scope: !450)
!481 = distinct !{!481, !453, !482}
!482 = !DILocation(line: 69, column: 9, scope: !445)
!483 = !DILocation(line: 70, column: 5, scope: !446)
!484 = !DILocation(line: 60, column: 32, scope: !440)
!485 = !DILocation(line: 60, column: 5, scope: !440)
!486 = distinct !{!486, !443, !487}
!487 = !DILocation(line: 70, column: 5, scope: !436)
!488 = !DILocation(line: 71, column: 5, scope: !419)
!489 = !DILocation(line: 72, column: 1, scope: !419)
